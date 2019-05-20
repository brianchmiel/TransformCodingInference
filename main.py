from __future__ import print_function
import torch
import argparse
import logging
import os
import time
from datetime import datetime
from inspect import getfile, currentframe
from os import getpid, environ
from os.path import dirname, abspath
from socket import gethostname
from sys import exit, argv

import numpy as np
import torch.backends.cudnn as cudnn
import torch.optim as optim
import tqdm
from torch import manual_seed as torch_manual_seed
from torch.cuda import is_available, set_device
from torch.cuda import manual_seed as cuda_manual_seed
from torch.nn import CrossEntropyLoss

import Models
from run import Run
from utils import loadModelNames,  saveArgsToJSON, TqdmLoggingHandler, load_data
from quantizeWeights import quantizeWeights

def parseArgs():
    modelNames = loadModelNames()

    parser = argparse.ArgumentParser(description='Feature Map Transform Coding')
    parser.add_argument('--data', type=str, help='location of the data corpus', required = True)
    parser.add_argument('--gpu', type=str, default='0', help='gpu device id, e.g. 0,1,3')

    parser.add_argument('--batch', default=250, type=int, help='batch size')

    parser.add_argument('--save', type=str, default='EXP', help='experiment name')
    parser.add_argument('--actBitwidth', default=32, type=float,
                        help='Quantization activation bitwidth (default: 32)')
    parser.add_argument('--weightBitwidth', default=32, type=int,
                        help='Quantization weight bitwidth (default: 32)')
    parser.add_argument('--model', '-a', metavar='MODEL', choices=modelNames,
                        help='model architecture: ' + ' | '.join(modelNames))
    parser.add_argument('--MicroBlockSz', type=int, default=1, help='Size of block in H*W')
    parser.add_argument('--channelsDiv', type=int, default=1, help='How many parts divide the number of channels')
    parser.add_argument('--eigenVar', type=float, default=1.0, help='EigenVar - should be between 0 to 1')
    parser.add_argument('--transformType', type=str, default='eye', choices=['eye', 'pca', 'pcaT','pcaQ'],
                        help='which projection we do: [eye, pca, pcaQ, pcaT]')
    parser.add_argument('--transform', action='store_true', help='if use linear transformation, otherwise use regular inference')
    parser.add_argument('--fold', action='store_true',
                        help='if use fold for hardware implementation, currently only in resnet18')

    args = parser.parse_args()



    # update GPUs list
    if type(args.gpu) is not 'None':
        args.gpu = [int(i) for i in args.gpu.split(',')]

    args.device = 'cuda:' + str(args.gpu[0])


    # create folder
    baseFolder = dirname(abspath(getfile(currentframe())))
    args.time = time.strftime("%Y%m%d-%H%M%S")
    args.folderName = '{}_{}_{}_{}_{}_{}_{}'.format(args.model, args.transformType, args.actBitwidth, args.weightBitwidth, args.MicroBlockSz,
                                                 args.channelsDiv, args.time)
    args.save = '{}/results/{}'.format(baseFolder, args.folderName)
    if not os.path.exists(args.save):
        os.makedirs(args.save)

    # save args to JSON
    saveArgsToJSON(args)

    return args


if __name__ == '__main__':

    args = parseArgs()

    if not is_available():
        print('no gpu device available')
        exit(1)

    # CUDA
    args.seed = datetime.now().microsecond
    np.random.seed(args.seed)
    set_device(args.gpu[0])
    cudnn.benchmark = True
    torch_manual_seed(args.seed)
    cudnn.enabled = True
    cuda_manual_seed(args.seed)

    # Logger
    log_format = '%(asctime)s %(message)s'
    logging.basicConfig(filename=os.path.join(args.save, 'log.txt'), level=logging.INFO,
                        format=log_format, datefmt='%m/%d %I:%M:%S %p')
    th = TqdmLoggingHandler()
    th.setFormatter(logging.Formatter(log_format))
    log = logging.getLogger()
    log.addHandler(th)

    # Data
    testLoader, statloader = load_data(args, logging)

    # Model
    logging.info('==> Building model..')
    #currently fold only for resnet18 for HW implementation
    if args.fold:
        assert (args.model == 'resnet18')
        args.model += 'a'

    modelClass = Models.__dict__[args.model]
    model = modelClass(args)



    # Load preTrained weights.
    logging.info('==> Resuming from checkpoint..')
    model.loadPreTrained()
    model = model.cuda()

    criterion = CrossEntropyLoss().cuda()

    run = Run(model, logging, criterion)

    # log command line
    logging.info('CommandLine: {} PID: {} '
                 'Hostname: {} CUDA_VISIBLE_DEVICES {}'.format(argv, getpid(), gethostname(),
                                                               environ.get('CUDA_VISIBLE_DEVICES')))

    # Weights quantization
    if args.weightBitwidth < 32 and not args.fold:
        model_path = './qmodels'
        if not os.path.exists(model_path):
            os.makedirs(model_path)
        model_path = os.path.join(model_path, args.model + ('_kmeans%dbit.pt' % args.weightBitwidth))
        if not os.path.exists(model_path):
            model = quantizeWeights(model, args.weightBitwidth, logging)
            torch.save(model, model_path)
        else:
            torch.load(model_path)
            logging.info('Loaded preTrained model with weights quantized to {} bits'.format(args.weightBitwidth))


    # collect statistics
    logging.info('Starting collect statistics')
    run.collectStats(statloader)
    logging.info('Finish collect statistics')
    # Weights quantization
    if args.weightBitwidth < 32 and args.fold:
        run.model = quantizeWeights(run.model.cpu(), args.weightBitwidth, logging).cuda()
    logging.info('Run Projection on inference')
    run.runTest(args, testLoader, 0)

