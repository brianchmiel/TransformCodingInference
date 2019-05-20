
from sklearn.cluster import KMeans
import numpy as np
import torch
from tqdm import tqdm
import copy

def quantize1d_kmeans(x, num_bits=8, n_jobs=-1):
    if x.size < 2**num_bits:
        return x
    else:
        orig_shape = x.shape
        x = np.expand_dims(x.flatten(), -1)
        # init = np.expand_dims(np.linspace(x.min(), x.max(), 2**num_bits), -1)
        kmeans = KMeans(n_clusters=2**num_bits, random_state=0, n_jobs=n_jobs)
        x_kmeans = kmeans.fit_predict(x)
        q_kmeans = np.array([kmeans.cluster_centers_[i] for i in x_kmeans])
        return q_kmeans.reshape(orig_shape)


def leave_8_bit(name,param):
    # first layer or last layer
    return ('weight' in name and param.dim() > 1 and param.shape[1] == 3) or \
           ('fc' in name and param.shape[0] == 1000) or \
           ('classifier' in  name and param.shape[0] == 1000)

  #  (name == 'Conv2d_2a_3x3.conv.weight')  # WA for inception_v3

def bn_layers(name, param):
    # BN
    return (param.dim() == 1) and (param.shape[0] != 1000)


def quantize_model_parameters(model, num_bits):
    # Quantize parameters of the model with kmeans
    named_params = [np for np in model.named_parameters() if not bn_layers(*np) and not leave_8_bit(*np)]
    named_params_8 = [np for np in model.named_parameters() if leave_8_bit(*np)]
    named_params_16 = [np for np in model.named_parameters() if bn_layers(*np)]
    for np in tqdm(named_params):
        np[1].data = torch.tensor(quantize1d_kmeans(np[1].detach().numpy(), num_bits=num_bits))
    for np in tqdm(named_params_8):
        np[1].data = torch.tensor(quantize1d_kmeans(np[1].detach().numpy(), num_bits=8))
    for np in tqdm(named_params_16):
        np[1].data = torch.tensor(quantize1d_kmeans(np[1].detach().numpy(), num_bits=16))

def quantizeWeights(model, num_bits,log):

    # Quantize model by kmeans non uniform quantization
    model_qkmeans = copy.deepcopy(model)

    quantize_model_parameters(model_qkmeans, num_bits=num_bits)


    # Per channel bias correction
    p_km = [np for np in model_qkmeans.named_parameters()]
    p_orig = [np for np in model.named_parameters()]
    for i in tqdm(range(len(p_km))):
        if not bn_layers(p_km[i][0], p_km[i][1]) and not (leave_8_bit(p_km[i][0], p_km[i][1])):
            w_km = p_km[i][1]
            w_orig = p_orig[i][1]
            mean_delta = w_km.view(w_km.shape[0], -1).mean(dim=-1) - w_orig.view(w_orig.shape[0], -1).mean(dim=-1)
            p_km[i][1].data = (w_km.view(w_km.shape[0], -1) - mean_delta.view(mean_delta.shape[0], 1)).view(
                w_orig.shape)

    log.info('Weights quantized to {} bits'.format(num_bits))
    return model_qkmeans




