# Feature Map Transform Coding for Energy-Efficient CNN Inference



This code implements the papper "Feature Map Transform Coding for Energy-Efficient CNN Inference"

List of links to quantize models can be download from:

https://www.mediafire.com/file/ajna79opjt53c12/qmodels.tar/file

Running instructions
--------------------
--------------------

python main.py --data <ImageNet folder location> --model <Model name (resnet18 / resnet50 / resnet101 / inception_v3 / mobilenet_v2)>  --actBitwidth <Bits for main principal component> --weightBitwidth <4/8>  --transform -transformType (eye/pca/pcaQ/pcaT)
  
