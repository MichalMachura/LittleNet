import numpy as np
import pynq
import numpy as np
import time


def sigmoid(a):
    e = np.exp(a)
    return e / (e+1)


def iou(A,B):
    A = np.array(A).astype(np.float32)
    B = np.array(B).astype(np.float32)
    
    C_lt = np.maximum(A[:,:2],B[:,:2])
    C_rb = np.minimum(A[:,-2:],B[:,-2:])
    
    C_wh = C_rb - C_lt + 1
    C_wh = np.maximum(C_wh, 0.0)
    
    A_wh = A[:,-2:] - A[:,:2]+1
    B_wh = B[:,-2:] - B[:,:2]+1
    
    A_S = A_wh[:,0]*A_wh[:,1]
    B_S = B_wh[:,0]*B_wh[:,1]
    C_S = C_wh[:,0]*C_wh[:,1]
    
    IOU = C_S / (A_S+B_S-C_S+1e-6)
    
    return IOU


class PowerRecorder(pynq.pmbus.DataRecorder):
    def __init__(self):
        r = pynq.get_rails()
        sensors = [r['AUX'].power,
                    r['1V2'].power,
                    r['PSDDR'].power,
                    r['INT'].power,
                    r['3V3_D'].power,
                    r['PSAUX'].power,
                    r['PSINT_LP'].power,
                    r['3V3'].power,
                    r['PSINT_FP'].power,
                    r['PSPLL'].power]
        super().__init__(*sensors)
    
    @property
    def mean_power(self):
        f = self.frame
        cols = f.columns.tolist()
        a = f.values[:,1:]
        r = np.sum(a,axis=1)
        return np.mean(r)
    
    
    