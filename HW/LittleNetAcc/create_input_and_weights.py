import numpy as np
import os



def array_to_str(a, parallelism=1, sep='\n', width=8, f='b'):
    pixels = a.flatten().tolist()
    s = ''
    for i,v in enumerate(pixels):
        # s += format(v, f).zfill(bit_width)
        s += (f % v).zfill(width)
        if ((i+1)%parallelism) == 0:
            s += sep
    
    return s


def parallelize_weights(w, parallelism):
    # each row is a filter/out_channel
    out_channels = w.shape[0]
    ch_per_thread = (out_channels -1) // parallelism +1
    filled_out_channels = ch_per_thread*parallelism
    
    filled_w = np.zeros((filled_out_channels, w.shape[1]), dtype=w.dtype)
    # beginning as original weights, rest as zeros
    filled_w[:w.shape[0],:] = w
    
    parallel_parts = []
    for p in range(parallelism):
        f_beg = p*ch_per_thread
        f_end = (p+1)*ch_per_thread
        f_w = filled_w[f_beg:f_end,:]
        parallel_parts.append(f_w.reshape((-1,1)))
    
    parallelized = np.concatenate(parallel_parts, axis=1)
    parallelized_chpth = parallelized.reshape((ch_per_thread,-1))
    parallelized = parallelized.reshape((-1,parallelism))

    return parallelized


if __name__ == '__main__':
    
    in_sh = (112,208,3)
    w_sh = (15,in_sh[2]+1+2)
    
    rg = np.random.Generator(np.random.PCG64(seed=1))
    data = (rg.random(in_sh)*255).astype(np.uint8)
    weights = ((np.random.rand(*w_sh)*2-1)*5).astype(np.int8).astype(np.uint8)
    
    # for i in range(in_sh[0]):
    #     data[i,...] = np.arange(0,in_sh[1]*in_sh[2],dtype=weights.dtype).reshape(in_sh[1:])+i
    # data = data % 10 - 5
    
    print("weights")
    print(weights.astype(np.int8))
    print("data")
    print(data.astype(np.uint8))
    
    # for i in range(w_sh[0]):
    #     weights[i,:] = np.arange(0,w_sh[1],dtype=weights.dtype)+i
    parallelism = 3
    
    weights = parallelize_weights(weights,parallelism)
    
    ws = array_to_str(weights,parallelism=parallelism,sep='\n',width=2,f='%02x')[:-1]
    
    d = os.path.dirname(__file__)

    with open(os.path.join(d,'sim_memory_weights.mem'),'w') as f:
        f.write(ws)
    with open(os.path.join(d,'sim_memory_weights.txt'),'w') as f:
        f.write(weights.astype(np.int8).__str__())
    
    s = [str(i) for i in data.flatten().tolist()]
    s = ', '.join(s)
    data = data.reshape((-1,4)).astype(np.uint32)
    data = data[:,3] << 3*8 | data[:,2] << 2*8 | data[:,1] << 8 | data[:,0]
    # data = data[:,3] | data[:,2] << 8 | data[:,1] << 2*8 | data[:,0] << 3*8
    ds = array_to_str(data,parallelism=1,sep='\n',width=8,f='%08x')[:-1]
    
    with open(os.path.join(d,'sim_memory_input.mem'),'w') as f:
        f.write(ds)
    with open(os.path.join(d,'sim_memory_input.txt'),'w') as f:
        f.write("data = np.array([{}],dtype=np.uint8).reshape((32,32,3))".format(s))
        