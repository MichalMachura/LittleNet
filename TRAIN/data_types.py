import numpy as np
import torch


class Types:

    T_F_DEFAULT = torch.float32
    NP_F_DEFAULT = np.float32

    T_INT_DEFAULT = torch.int32
    NP_INT_DEFAULT = np.int32
    
    T_WEIGHT = torch.float32
    NP_WEIGHT = np.float32
    
    T_INPUT = torch.float32
    NP_INPUT = np.float32
    
    T_INDEX = torch.long
    NP_INDEX = np.longlong
    
    def is_device(type_):
        type_ = str(type_)
        
        return type_ in ['cpu', 'cuda', 'cuda:0']

