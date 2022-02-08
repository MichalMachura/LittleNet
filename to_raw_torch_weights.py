import torch
import sys
import TRAIN
sys.path.append('TRAIN')
# from TRAIN import *
import argparse
import numpy as np


if __name__ == "__main__":    
    parser = argparse.ArgumentParser()
    parser.add_argument('--src',required=True)
    parser.add_argument('--dst')
    parser.add_argument('--convert',action='store_true')
    
    args = parser.parse_args()
    
    f_name = args.src
    dst_name = args.dst if args.dst is not None else  'weights_'+f_name
    
    print("Opening file:",f_name)
    with open(f_name,'rb') as f:
        sd = torch.load(f)
        if args.convert is not None:
            torch.save(sd,dst_name,_use_new_zipfile_serialization=False)
            exit()
        w = sd['model']
        
    torch.save(w,dst_name,_use_new_zipfile_serialization=False)
    print("Weight file saved as:", dst_name)
    
    k_a_mul = list(sd['model'].keys())[-1]
    v_a_mul = list(sd['model'].values())[-1]
    # calc anchor multipliers
    anchor_mul = torch.exp(v_a_mul.cpu()).numpy().reshape((2,-1)).T
    # get anchors
    anchors = sd['additional_state']['anchors_wh'].reshape((-1,2))
    # get multiplied anchors
    
    print("Anchors multipiers:")
    print(anchor_mul)
    print("Anchors:")
    print(anchors)
    with open(f_name+'.anchors.txt', 'w') as f:
        f.write("anchor_mul = "+str(anchor_mul.tolist()))
        f.write("\n")
        f.write("anchors = "+str(anchors.tolist()))
        
    
    