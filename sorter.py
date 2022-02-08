import os
import re

from numpy import int8, uint16, uint8, int16

def cmp(L1,L2):
    if len(L1) != len(L2):
        print("Differnt len ", end='')
        return False
    else:
        for ((a1,v1),(a2,v2)) in zip(L1,L2):
            if a1 != a2 or uint8(v1) != uint8(v2):
                return False
        return True


r = re.compile('(\d+),\s+(-?\d+)')


for i in range(20):
    ref_path = 'ref/layer_'+str(i)+'.txt'
    
    with open(ref_path, 'r') as f:
        data = f.read()
    
    ref = r.findall(data)
    ref = [[int(a),int16(v)] for a,v in ref]
    ref = sorted(ref,key=lambda x:x[0])
    
    files = ['tmp/'+f for f in os.listdir('tmp') if 'layer_'+str(i)+'_' in f]
    for path in files:
        with open(path,'r') as f:
            data = f.read()    
        pred = r.findall(data)
    
        pred = [[int(a),int16(v)] for a,v in pred]
        pred = sorted(pred,key=lambda x:x[0])
        
        if cmp(ref, pred):
            print(ref_path,'==',path)
        else:
            print(ref_path,'!=',path)

