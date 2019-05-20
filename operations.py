
import numpy as np
import torch
import torch.nn as nn
from sklearn.cluster import KMeans
from torch.nn import functional as F

from entropy import shannon_entropy
from huffman import huffman_encode


def quantize1d_kmeans(x, num_bits=8, n_jobs=-1):
    orig_shape = x.shape
    x = np.expand_dims(x.flatten(), -1)
    kmeans = KMeans(n_clusters=2 ** num_bits, random_state=0, n_jobs=n_jobs)
    x_kmeans = kmeans.fit_predict(x)
    q_kmeans = np.array([kmeans.cluster_centers_[i] for i in x_kmeans])
    return q_kmeans.reshape(orig_shape)



def get_projection_matrix(im, projType, eigenVar):
    if projType == 'eye':
        u, s = torch.eye(im.shape[0]).to(im), torch.ones(im.shape[0]).to(im)
    else:
        # covariance matrix
        cov = torch.matmul(im, im.t()) / im.shape[1]
        # svd
        u, s, _ = torch.svd(cov)
        if projType == 'pcaQ':
            u = torch.tensor(quantize1d_kmeans(u.cpu().detach().numpy(), num_bits=8)).cuda()
        elif projType == 'pcaT':
            # find index where eigenvalues are more important
            sRatio = torch.cumsum(s, 0) / torch.sum(s)
            cutIdx = (sRatio >= eigenVar).nonzero()[0]
            # throw unimportant eigenvector
            u = u[:, :cutIdx]
            s = s[:cutIdx]

    return u, s


def featuresReshape(input, N, C, H, W, microBlockSz, channelsDiv):
    # check input
    if (microBlockSz > H):
        microBlockSz = H
    if (channelsDiv > C):
        channelsDiv = C
    assert (C % channelsDiv == 0)
    Ct = C // channelsDiv
    featureSize = microBlockSz * microBlockSz * Ct

    input = input.view(-1, Ct, H, W)  # N' x Ct x H x W
    input = input.permute(0, 2, 3, 1)  # N' x H x W x Ct
    input = input.contiguous().view(-1, microBlockSz, W, Ct).permute(0, 2, 1, 3)  # N'' x W x microBlockSz x Ct
    input = input.contiguous().view(-1, microBlockSz, microBlockSz, Ct).permute(0, 3, 2,1)  # N''' x Ct x microBlockSz x microBlockSz

    return input.contiguous().view(-1, featureSize).t()


def featuresReshapeBack(input, N, C, H, W, microBlockSz, channelsDiv):
    if (microBlockSz > H):
        microBlockSz = H
    if (channelsDiv > C):
        channelsDiv = C
    assert (C % channelsDiv == 0)

    input = input.t()
    Ct = C // channelsDiv

    input = input.view(-1, Ct, microBlockSz, microBlockSz).permute(0, 3, 2,1)  # N'''  x microBlockSz x microBlockSz x Ct
    input = input.contiguous().view(-1, H, microBlockSz, Ct).permute(0, 2, 1,3)  # N''  x microBlockSz x H x Ct
    input = input.contiguous().view(-1, H, W, Ct).permute(0, 3, 1, 2)  # N' x Ct x H x W X
    input = input.contiguous().view(N, C, H, W)  # N x C x H x W

    return input



class ReLuPCA(nn.Module):
    def __init__(self, args, mxRelu6=False):
        super(ReLuPCA, self).__init__()
        self.actBitwidth = args.actBitwidth
        self.transformType = args.transformType

        self.transform = args.transform
        self.collectStats = True
        self.bit_count = None

        self.microBlockSz = args.MicroBlockSz
        self.channelsDiv = args.channelsDiv
        self.eigenVar = args.eigenVar
        if mxRelu6:
            self.relu = nn.ReLU6(inplace=True)
        else:
            self.relu = nn.ReLU(inplace=True)



    def forward(self, input):

        if self.transform:
            N, C, H, W = input.shape  # N x C x H x W
            im = featuresReshape(input, N, C, H, W, self.microBlockSz,self.channelsDiv)

            self.channels = im.shape[0]

            mn = torch.mean(im, dim=1, keepdim=True)
            # Centering the data
            im = im - mn

            # Calculate projection matrix if needed
            if self.collectStats:
                self.u, self.s = get_projection_matrix(im, self.transformType, self.eigenVar)
                self.original_channels = self.u.shape[0]

            self.channels = self.u.shape[1]

            # projection
            imProj = torch.matmul(self.u.t(), im)

            mult = torch.zeros(1).to(imProj)
            add = torch.zeros(1).to(imProj)


            dynMax = torch.max(imProj)
            dynMin = torch.min(imProj)

            if self.actBitwidth < 30:
                imProj, mult, add = part_quant(imProj, max=dynMax, min=dynMin,
                                               bitwidth=self.actBitwidth)

            self.act_size = imProj.numel()
            self.bit_per_entry = shannon_entropy(imProj).item()
            self.bit_count = self.bit_per_entry * self.act_size
            if False: #add if want to show huffman code in additional to theoretical entropy
                self.bit_countH = huffman_encode(imProj)
                self.bit_per_entryH = self.bit_countH / self.act_size

            if self.actBitwidth < 30:
                imProj = imProj * mult + add

            imProj = torch.matmul(self.u, imProj)

            # Bias Correction
            imProj = imProj - torch.mean(imProj, dim=1, keepdim=True)

            self.mse = torch.sum((imProj - im) ** 2)
            # return original mean
            imProj = imProj + mn

            # return to general
            input = featuresReshapeBack(imProj, N, C, H, W, self.microBlockSz,self.channelsDiv)

            self.collectStats = False

        input = self.relu(input)
        return input



class ConvBNPCA(nn.Conv2d):
    def __init__(self, args, in_channels, out_channels, kernel_size, stride=1,
                 padding=0, dilation=1, groups=1, bias=True):
        super(ConvBNPCA, self).__init__(in_channels, out_channels, kernel_size, stride,
                                        padding, dilation, groups, bias)
        self.actBitwidth = args.actBitwidth
        self.transformType = args.transformType

        self.transform = args.transform
        self.collectStats = True
        self.bit_count = None

        self.microBlockSz = args.MicroBlockSz
        self.channelsDiv = args.channelsDiv
        self.eigenVar = args.eigenVar


    def get_stats_params(self, im):
        self.u, self.s = get_projection_matrix(im, self.transformType, self.eigenVar)
        self.original_channels = self.u.shape[0]

        # update weights
        self.weight.data = self.weight.data.transpose(0, 3).unsqueeze(4)
        self.weight.data = torch.matmul(self.u.t(), self.weight.data)
        self.weight.data = self.weight.data.squeeze(4).transpose(0, 3).contiguous()
        if self.bias is None:
            zeros = torch.Tensor(self.out_channels).zero_().type(self.weight.data.type())
            self.bias = nn.Parameter(zeros)
        self.bias.data -= self.mn.squeeze()
        self.bias.data = torch.matmul(self.u.t(), self.bias.data)

    def forward(self, input):
        if self.transform:
            self.channels = self.out_channels

            if not hasattr(self, 'mn'):
                self.register_buffer('mn', torch.zeros(self.channels, 1))

            # Calculate projection matrix if needed
            if self.collectStats:
                im = F.conv2d(input, self.weight, self.bias, self.stride,
                              self.padding, self.dilation, self.groups)
                N, C, H, W = im.shape  # N x C x H x W


                im = featuresReshape(im, N, C, H, W, self.microBlockSz,self.channelsDiv)
                self.mn = torch.mean(im, dim=1, keepdim=True)

                # Centering the data
                im = im - self.mn
                self.get_stats_params(im)
                # projection
                imProj = torch.matmul(self.u.t(), im)

                # conv + bn if exists + projection
                im2 = F.conv2d(input, self.weight, self.bias, self.stride,
                               self.padding, self.dilation, self.groups)
                imProj2 = featuresReshape(im2, N, C, H, W, self.microBlockSz,self.channelsDiv)
                assert (torch.max(torch.abs(imProj - imProj2)) < 0.1)
            else:
                # conv + bn if exists + projection
                im = F.conv2d(input, self.weight, self.bias, self.stride,
                              self.padding, self.dilation, self.groups)
                N, C, H, W = im.shape  # N x C x H x W
                imProj = featuresReshape(im, N, C, H, W, self.microBlockSz,self.channelsDiv)

            mult = torch.zeros(1).to(imProj)
            add = torch.zeros(1).to(imProj)


            self.collectStats = False

            dynMax = torch.max(imProj)
            dynMin = torch.min(imProj)


            if self.actBitwidth < 30:
                imProj, mult, add = part_quant(imProj, max=dynMax, min=dynMin,
                                               bitwidth=self.actBitwidth)

            self.act_size = imProj.numel()
            self.bit_per_entry = shannon_entropy(imProj).item()
            self.bit_count = self.bit_per_entry * self.act_size
            if False: #add if want to show huffman code in additional to theoretical entropy
                self.bit_countH = huffman_encode(imProj)
                self.bit_per_entryH = self.bit_countH / self.act_size

            if self.actBitwidth < 30:
                imProj = imProj * mult + add

            imProj = torch.matmul(self.u, imProj)

            # return original mean
            imProj = imProj + self.mn

            input = featuresReshapeBack(imProj, N, C, H, W, self.microBlockSz,self.channelsDiv)

        else:
            input = F.conv2d(input, self.weight, self.bias, self.stride,
                             self.padding, self.dilation, self.groups)

        return input



def part_quant(x, max, min, bitwidth):
    if max != min:
        act_scale = (2 ** bitwidth - 2) / (max - min)
        q_x = Round.apply((x - min) * act_scale)
        return q_x, 1 / act_scale, min
    else:
        q_x = x
        return q_x, 1, 0



class Round(torch.autograd.Function):
    @staticmethod
    def forward(self, x):
        round = x.round()
        return round.to(x.device)

    @staticmethod
    def backward(self, grad_output):
        grad_input = grad_output
        return grad_input, None, None
