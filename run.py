import os

import numpy as np
import torch
import tqdm


class Run:

    def __init__(self, model, logging, criterion):
        self.model = model
        self.logging = logging
        self.best_acc = 0
        self.criterion = criterion
    def collectStats(self, testLoader):
        self.model.eval()
        with torch.no_grad():
            for batch_idx, (inputs, targets) in enumerate(testLoader):
                inputs, targets = inputs.cuda(), targets.cuda()
                self.model(inputs)


    def runTest(self, args, testLoader, epoch):
        self.model.eval()
        # crossEntrTotalLoss, compressTotalLoss, test_loss, correct, total = 0, 0, 0, 0, 0
        test_loss, correct, total, entropy, entropyH, mseTotal = 0, 0, 0, 0,0,0
        with torch.no_grad():
            for batch_idx, (inputs, targets) in enumerate(tqdm.tqdm(testLoader)):
                inputs, targets = inputs.cuda(), targets.cuda()
                out = self.model(inputs)
                loss = self.criterion(out, targets)
                test_loss += loss.item()
                _, predicted = out.max(1)
                total += targets.size(0)
                correct += predicted.eq(targets).sum().item()
                ent = np.array([x.bit_count for x in self.model.modules() if hasattr(x, "bit_count")])
                entH = np.array([x.bit_countH for x in self.model.modules() if hasattr(x, "bit_countH")])
                mse = np.array([x.mse for x in self.model.modules() if hasattr(x, "mse")])
                if args.transform:
                    entropy += np.sum(ent)
                    entropyH += np.sum(entH)
                    mseTotal +=np.sum(mse)
                if batch_idx % 10 == 0 :
                    self.logging.info('step: {} / {} : Loss: {:.3f}  | ent: {:.3f} Mbit | huff: {:.3f} Mbit | '
                                      'Acc: {:.3f}% ({}/{})'
                                      .format(batch_idx + 1, len(testLoader), test_loss / (batch_idx + 1),
                                              entropy / 1e6 / (batch_idx + 1), entropyH / 1e6 / (batch_idx + 1),
                                              100. * correct / total, correct, total))

        self.logging.info('step: {} / {} : Loss: {:.3f}  | ent: {:.3f} Mbit | huff: {:.3f} Mbit | '
                          'Acc: {:.3f}% ({}/{})'
                          .format(batch_idx + 1, len(testLoader), test_loss / (batch_idx + 1),
                                  entropy / 1e6 / (batch_idx + 1), entropyH / 1e6 / (batch_idx + 1),
                                  100. * correct / total, correct, total))

        act_count = np.sum(np.array([x.act_size for x in self.model.modules() if hasattr(x, "act_size")]))
        self.logging.info('Activation count: {}. Average entropy: {:.4f}. Huffman bits: {:.4f}. MSE: {:.4f}.'
                          .format(act_count, entropy / len(testLoader) / act_count, float(entropyH) / len(testLoader) / act_count,
                                  mseTotal / len(testLoader) / act_count))


        # Save checkpoint.
        acc = 100. * correct / total
        if acc > self.best_acc:
            self.logging.info('Saving..')
            state = {
                'net': self.model.state_dict(),
                'acc': acc,
                'epoch': epoch,
            }
            if not os.path.isdir('results'):
                os.mkdir('results')
            torch.save(state, args.save + '/ckpt.t7')
            self.best_acc = acc
