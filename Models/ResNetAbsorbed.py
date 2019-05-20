import torch
import torch.nn as nn
import torch.utils.model_zoo as model_zoo

from absorbe_bn import search_absorbe_bn
from operations import ConvBNPCA as Conv2d

model_urls = {
    'resnet18': 'https://download.pytorch.org/models/resnet18-5c106cde.pth'
}


def flatten(x):
    return x.view(x.size(0), -1)


def conv3x3(args, in_planes, out_planes, stride=1):
    "3x3 convolution with padding"
    return Conv2d(args, in_planes, out_planes, kernel_size=3, stride=stride, padding=1, bias=False)


def conv1x1(args, in_planes, out_planes, stride=1):
    """1x1 convolution"""
    return Conv2d(args, in_planes, out_planes, kernel_size=1, stride=stride, bias=False)


class BasicBlock(nn.Module):
    expansion = 1

    def __init__(self, args, in_planes, planes, stride=1, downsample=None):
        super(BasicBlock, self).__init__()

        self.conv1 = conv3x3(args, in_planes, planes, stride)
        self.bn1 = nn.BatchNorm2d(planes)
        self.relu1 = nn.ReLU(inplace=True)

        self.conv2 = conv3x3(args, planes, planes)
        self.bn2 = nn.BatchNorm2d(planes)
        self.relu2 = nn.ReLU(inplace=True)

        self.downsample = downsample

        self.stride = stride

    def forward(self, x):
        residue = x

        if not self.bn1.absorbed:
            out = self.relu1(self.bn1(self.conv1(x)))
        else:
            out = self.relu1(self.conv1(x))

        if not self.bn2.absorbed:
            out = self.bn2(self.conv2(out))
        else:
            out = self.conv2(out)


        if self.downsample is not None:
            residue = self.downsample(x)

        out += residue
        out = self.relu2(out)
        return out



class Bottleneck(nn.Module):
    expansion = 4

    def __init__(self, args, inplanes, planes, stride=1, downsample=None):
        super(Bottleneck, self).__init__()
        self.conv1 = conv1x1(args, inplanes, planes)
        self.bn1 = nn.BatchNorm2d(planes)
        self.relu1 = nn.ReLU(inplace=True)
        self.conv2 = conv3x3(args, planes, planes, stride)
        self.bn2 = nn.BatchNorm2d(planes)
        self.relu2 = nn.ReLU(inplace=True)
        self.conv3 = conv1x1(args, planes, planes * self.expansion)
        self.bn3 = nn.BatchNorm2d(planes * self.expansion)
        self.relu3 = nn.ReLU(inplace=True)
        self.downsample = downsample
        self.stride = stride

    def forward(self, x):
        identity = x

        if not self.bn1.absorbed:
            out = self.relu1(self.bn1(self.conv1(x)))
        else:
            out = self.relu1(self.conv1(x))

        if not self.bn2.absorbed:
            out = self.relu2(self.bn2(self.conv2(out)))
        else:
            out = self.relu2(self.conv2(out))

        if not self.bn3.absorbed:
            out =self.bn3(self.conv3(out))
        else:
            out = self.conv3(out)

        if self.downsample is not None:
            identity = self.downsample(x)

        out += identity
        out = self.relu3(out)

        return out




class ResNetImagenet(nn.Module):

    def __init__(self, block, layers, args, zero_init_residual=False):
        super(ResNetImagenet, self).__init__()
        num_classes = 1000
        self.name = args.model[:-1]
        self.inplanes = 64
        self.conv1 = Conv2d(args, 3, 64, kernel_size=7, stride=2, padding=3,
                               bias=False)
        self.bn1 = nn.BatchNorm2d(64)
        self.relu = nn.ReLU(inplace=True)
        self.maxpool = nn.MaxPool2d(kernel_size=3, stride=2, padding=1)
        self.layer1 = self._make_layer(args, block, 64, layers[0])
        self.layer2 = self._make_layer(args, block, 128, layers[1], stride=2)
        self.layer3 = self._make_layer(args, block, 256, layers[2], stride=2)
        self.layer4 = self._make_layer(args, block, 512, layers[3], stride=2)
        self.avgpool = nn.AdaptiveAvgPool2d((1, 1))
        self.fc = nn.Linear(512 * block.expansion, num_classes)



    def _make_layer(self, args, block, planes, blocks, stride=1):
        downsample = None
        if stride != 1 or self.inplanes != planes * block.expansion:
            downsample = nn.Sequential(
                conv1x1(args, self.inplanes, planes * block.expansion, stride),
                nn.BatchNorm2d(planes * block.expansion),
            )

        layers = []
        layers.append(block(args, self.inplanes, planes, stride, downsample))
        self.inplanes = planes * block.expansion
        for _ in range(1, blocks):
            layers.append(block(args, self.inplanes, planes))

        return nn.Sequential(*layers)

    def forward(self, x):
        x = self.conv1(x)
        if not self.bn1.absorbed:
            x = self.bn1(x)
        x = self.relu(x)
        x = self.maxpool(x)

        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        x = self.layer4(x)

        x = self.avgpool(x)
        x = x.view(x.size(0), -1)
        x = self.fc(x)

        return x

    def loadPreTrained(self):
        self.load_state_dict(model_zoo.load_url(model_urls[self.name]), False)
        search_absorbe_bn(self)





def ResNet18(args):
    model = ResNetImagenet(BasicBlock, [2, 2, 2, 2], args)
    return model
