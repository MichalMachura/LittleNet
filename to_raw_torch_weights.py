import torch
import sys
import TRAIN
sys.path.append('TRAIN')
# from TRAIN import *
import argparse

if __name__ == "__main__":    
    parser = argparse.ArgumentParser()
    parser.add_argument('--src',required=True)
    parser.add_argument('--dst')
    
    args = parser.parse_args()
    
    f_name = args.src
    dst_name = args.dst if args.dst is not None else  'weights_'+f_name
    
    print("Opening file:",f_name)
    with open(f_name,'rb') as f:
        sd = torch.load(f)
        w = sd['model']
        
    torch.save(w,dst_name,_use_new_zipfile_serialization=False)
    print("Weight file saved as:", dst_name)
    
    