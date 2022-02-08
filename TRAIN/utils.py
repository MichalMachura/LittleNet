from data_types import Types
import numpy as np
import numpy.random as rnd
import cv2 as cv
import matplotlib.pyplot as plt
import xml.dom.minidom as DOM
import os
import torch


def seconds_to_hmsms(seconds):
    """
    Convert float number of seconds into string format h:min:s:ms
    """
    s = int(seconds)
    ms = int((seconds-s)*1000)
    min = s //60
    h = min // 60

    min -= h*60
    s -= h*60*60 + min*60

    txt = str(h)+'[h]:' if h else ''
    txt += str(min)+'[min]:' if min else ''
    txt += str(s)+'[s]:' if s else ''
    txt += str(ms)+'[ms]'
    
    return txt


def bar(value, max_value, pre_text='', post_text='', length=100, end='', completed_char='█', in_progress_char='>', to_process_char=' '):
	
	state = int(float(value)/max_value*length)
	rest = length - state
		
	s = '\r'+ pre_text + ' [' + completed_char*state

	if rest > 0:
		s += in_progress_char
		rest -= 1  
	
	s += to_process_char*rest
	s += '] '
	s += '['+str(value)+'/'+str(max_value)+'] '

	s += post_text

	print(s, end=end)
	

def load_bbox(path):
	"""
	Load bounding box from file.
	Bbox is of type [x_center, y_center, width, height]
	<bndbox>
		<xmax>273</xmax>
		<xmin>196</xmin>
		<ymax>323</ymax>
		<ymin>164</ymin>
	</bndbox>
	:param path: path to file
	:return: np.array of shape (4,), [xc,yc,w,h]
	"""
	xml_file = DOM.parse(path)
	
	item = xml_file.getElementsByTagName('bndbox')[0]
	xmax = int(item.getElementsByTagName('xmax')[0].firstChild.data)
	xmin = int(item.getElementsByTagName('xmin')[0].firstChild.data)
	ymax = int(item.getElementsByTagName('ymax')[0].firstChild.data)
	ymin = int(item.getElementsByTagName('ymin')[0].firstChild.data)
	# xc, yc, w, h
	bbox = np.array([(xmax+xmin)/2, (ymax+ymin)/2, xmax-xmin, ymax-ymin]).reshape((4,))

	return bbox


def shape_similarity(wh1, anchor_wh):
	"""
	Compute similarity(IoU) of bounding boxes and given anchor size.

	:param wh1: np.array Nx2 [width, height] of object
	:param anchor_wh: np.aray 1x2 [width, height] of anchor
	:return: np.array of shape Nx1 with values of similarity factor
	"""
	# get min (w,h)
	WHm = np.where(wh1 < anchor_wh, wh1, anchor_wh)
	# intersection area
	num = WHm[:,0]*WHm[:,1]
	# IoU
	return num / (wh1[:,0]*wh1[:,1] + anchor_wh[0]*anchor_wh[1] - num)


def get_all_dir_files(path_to_dataset, quiet=True):
	"""
	search for jpg files at subdirectories
	:param path_to_dataset: path to directory with subdirs with images and bboxes
	:return: {'subdir_name':[(img_path, bbox_path),...]}
					img_path - path to image from  'path_to_dataset'
					bbox -     path to bbox -||-
	"""
	directories = [d for d in os.listdir(path_to_dataset) if os.path.isdir(os.path.join(path_to_dataset, d))]

	dataset = {}

	for d in directories:
		image_label = [(d+'/'+f,d+'/'+f[:-3]+'xml') for f in os.listdir(path_to_dataset+'/'+d) if os.path.isfile(os.path.join(path_to_dataset+'/'+d, f)) and '.jpg' == f[-4:]]
		dataset[d] = image_label
		if not quiet:
			print('Found', len(image_label), 'files in directory', "'"+d+"'")

	return dataset


def get_all_imgs_gts(path_to_dataset, quiet=True):
    path_to_imgs = os.path.join(path_to_dataset, 'images')
    path_to_gts = os.path.join(path_to_dataset, 'gts')

    directories = [d for d in os.listdir(path_to_imgs) if os.path.isdir(os.path.join(path_to_imgs, d))]

    dataset = {}

    for d in directories:
        images = [os.path.join('images',d,f) for f in os.listdir(path_to_imgs+'/'+d) if '.jpg' in f]
        images = sorted(images)
        labels = np.load(os.path.join(path_to_gts,d,'groundtruth.txt'))
        labels[:,:2] += labels[:,-2:]/2 # ltwh to xywh
        labels = [np.array(L, dtype=np.float32) for L in labels.tolist()]
        
        images_labels = list(zip(images,labels))

        dataset[d] = images_labels
        if not quiet:
            print('Found', len(images_labels), 'files in directory', "'"+d+"'")

    return dataset


def train_test_split(dataset, test_size=0.1, rand_generator=rnd.default_rng()):
	"""
	Split dataset into two datasets
	:param dataset: original dataset as dict
	:param test_size: size of test dataset from [0;1]
	:param rand_generator: np.random.Generator object (defoult is np.random.default_rng())
	:return: train_datasetm, test_dataset - both are dict
	"""
	train_dataset = {}
	test_dataset = {}

	for k, v in dataset.items():
		rand_generator.shuffle(v)
		th = len(v) - int(np.ceil(len(v)*test_size))
		train_dataset[k] = v[:th]
		test_dataset[k] = v[th:]

	return train_dataset, test_dataset


def dataset_to_list(dataset, rand_generator=rnd.default_rng()):
	"""
	Convert dataset from dict to list
	:param dataset: dataset as dict
	:param rand_generator: np.random.Generator object (default is np.random.default_rng())
	:return: dataset as list of tuple (path_img, path_bbox) 
		* paths are relative to main dataset dir
	"""
	dt_list = []

	for k,v in dataset.items():
		dt_list.extend(v)
	
	rand_generator.shuffle(dt_list)

	return dt_list


def print_dataset(dataset):
	"""
	Print dataset
	:param dataset: dataset as dict
	"""
	for k,v in dataset.items():
		print(k, '->',len(v), v)


def draw_bbox(img, bbox, color=(255,0,0), thickness=1):
	"""
	Draw bounding box on image img with given color and line's thickness
	:param img: image np.array 
	:param bbox: bounding box np.array([xc,yc,w,h])
	:param color: tuple(RGB) or nuber value for intensity image 
	:param thickness: line size
	:return: img with drawn bbox  
	"""
	xmin,xmax,ymin,ymax =  bbox[0]-bbox[2]/2,bbox[0]+bbox[2]/2,bbox[1]-bbox[3]/2,bbox[1]+bbox[3]/2 
	img = cv.rectangle(img,(int(xmin), int(ymin)), (int(xmax), int(ymax)),color, thickness)
	# img = cv.circle(img, (int(bbox[0]),int(bbox[1])), 3, color, thickness)

	return img


def split_into_folds(dataset, folds_num):
	folds = [{} for i in range(folds_num)]

	# for each directory
	for k,v in dataset.items():
		# randomize order
		np.random.shuffle(v)
		# calc fold size
		size = int(np.ceil(len(v)/folds_num))
		beg = 0
		for i in range(folds_num-1):
			folds[i][k] = v[beg: beg+size]
			beg += size
		# last one fold could be smaller
		folds[-1][k] = v[beg:]
	
	return folds 


def folds_dict_to_folds_list(folds_of_dicts):
    out_lists = [dataset_to_list(d) for d in folds_of_dicts]

    return out_lists


def unravel_index(index, shape):
    """
    """
    out = []
    for dim in reversed(shape):
        idx = index % dim
        out.append(idx)
        index //= dim

    return tuple(reversed(out))


def yolo_outputs_to_single_bbox_v3(y, anchors, input_shape):
    """
    Find max probable object's parameters for each sample in batch

    :param y: tensor of shape(batch_size, 5*num_of_anchors, W, H)
              output of yolo layer
    :param anchors: tensor of shape (-1, 2), anchors WH
    :param input_shape: tuple (H,W,Ch)
    :return: tensor of shape(batch_size, 5), 
             the most probable object's parameters for each sample
             (p,xc,yc,w,h), retransformed to original size  
    """
    device = anchors.device
    num_of_anchors = anchors.shape[0]
    batch_size = y.shape[0]
    batch_idx = torch.arange(0, batch_size, device=device, dtype=torch.long)
    window_X = input_shape[1] / y.shape[-1]
    window_Y = input_shape[0] / y.shape[-2]

    validity = y[:,:num_of_anchors,:,:].reshape(batch_size,-1)
    idx_max = torch.argmax(validity, dim=1)
    channel, row, col = unravel_index(idx_max, (5,)+y.shape[2:])
    
    # out = y.reshape((-1,num_of_anchors,5,)+y.shape[2:])[batch_idx,channel,:,row, col]
    
    out = torch.empty((batch_size,5), dtype=y.dtype,device=device)
    # validity
    out[:,0] = y[batch_idx,channel,row, col]
    # position X
    out[:,1] = y[batch_idx,channel+num_of_anchors,row, col]+col
    out[:,1] *= window_X
    
    # position Y
    out[:,2] = y[batch_idx,channel+2*num_of_anchors,row, col]+row
    out[:,2] *= window_Y

    # WH
    out[:,3] = y[batch_idx,channel+3*num_of_anchors,row, col]
    out[:,4] = y[batch_idx,channel+4*num_of_anchors,row, col]
    out[:,3:5] = torch.exp(out[:,3:5])*anchors[channel,:]

    return out


def convert_2x_path_into_path_bbox(path_to_dataset, images_labels):
    converted = []
    for p, xml in images_labels:
        bbox = load_bbox(os.path.join(path_to_dataset, xml)).astype(Types.NP_F_DEFAULT)
        # to LTWH
        # bbox[:2] -= bbox[2:]/2
        # bbox = bbox.astype(np.int).tolist()

        converted.append((p, bbox))

    return converted


def xcycwh_to_ltrb(bbox_batch):
    # move center to left top
    bbox_batch[:,:2] -= bbox_batch[:,-2:]/2
    # change wh into right bottom
    bbox_batch[:,-2:] += bbox_batch[:,:2]
    
    return bbox_batch


def ltrb_to_xcycwh(bbox_batch):
    # change right bottom into wh
    bbox_batch[:,-2:] -= bbox_batch[:,:2]
    # move left top to center
    bbox_batch[:,:2] += bbox_batch[:,-2:]/2
    
    return bbox_batch


def plot_history(hist, formatable_path:str=None):
    """
    :param hist: dict like key : list of values
                 where:
                 - key is name of loss, metric, etc.
                 list of values is list of values obtained at the whole training process
    :formatable_path: formatable path, which allow to format with one arg. as key name
                 to save it's history into file
    """
    keys = [k for k in hist.keys() if 'val_' not in k]

    for k in keys:
        v1 = hist[k]
        v2 = hist['val_'+k]
        
        v1 = [v.item() if isinstance(v, torch.Tensor) else v for v in v1]
        v2 = [v.item() if isinstance(v, torch.Tensor) else v for v in v2]

        size = min(len(v1),len(v2))
        x = np.arange(0,size)+1

        plt.plot(x, v1[:size], label=k)
        plt.plot(x, v2[:size], label='val_'+k)
        plt.legend()
        plt.xlabel("Epoch")
        plt.ylabel(k+' value')
        plt.title("History of '{}'".format(k))
        
        if formatable_path is not None:
            path = formatable_path.format(k)
            plt.savefig(path)

        plt.show()


def data_to_tensor(X, y, device):
    """
    Convert numpy array X (bs,h,w,c) -> (bs,c,h,w)-> torch.tensor
    and y tuple of numpy arrays -> tuple of torch.tensor
    :param X: numpy array of shape (-1,N,M,C)
    :param y: tuple of numpy arrays of shapes (-1,C,N,M)
    :param device: device to execute
    """
    labels = []

    # to batches with apropriate size and device
    for L in range(len(y)):
        labels.append(torch.tensor(y[L], dtype=Types.T_F_DEFAULT, device=device))
    # b,h,w,c -> b,c,h,w
    inputs = torch.tensor(np.moveaxis(X, 3, 1 ), dtype=Types.T_F_DEFAULT).contiguous().to(device)
    
    return inputs, labels


def data_to_tensor_v3(X, y, device):
    """
    Convert numpy array X (bs,h,w,c) -> (bs,c,h,w)-> torch.tensor
    and y tuple of numpy arrays -> tuple of torch.tensor
    :param X: numpy array of shape (-1,N,M,C)
    :param y: tuple of numpy arrays of shapes (-1,C,N,M)
    :param device: device to execute
    """
    labels = torch.tensor(y, dtype=Types.T_F_DEFAULT, device=device)
    # b,h,w,c -> b,c,h,w
    inputs = torch.tensor(np.moveaxis(X, 3, 1 ), dtype=Types.T_F_DEFAULT).contiguous().to(device)
    
    return inputs, labels

# RESOURCE counter

def bram_usage(shape,
               bit_width=8,
               bram_bit_width=32,
               bram_addresses=1024):
    # get shapes without batch dim
    shape = np.array(shape)
    # get number of elements for each intermediate results
    num_of_elements = np.prod(shape,axis=0)
    # number of elements stored under one address
    package_size = bram_bit_width // bit_width
    # get bram usage for it
    brams = np.ceil(num_of_elements / (package_size*bram_addresses))

    return brams


def buffers_brams_usage(layers_outputs_shapes:list, 
                        layers_per2buffers=3, 
                        separate_out=True):
    layers_brams = [ bram_usage(shape[-3:]) for shape in layers_outputs_shapes]

    in_layer = layers_brams[0]
    middle_layers = layers_brams[1:(-1 if separate_out else None)]
    out_layer = layers_brams[-1]

    blocks_number = 1 + (len(middle_layers)-1) // layers_per2buffers

    blocks_buffers = [[0, 0] for m in range(blocks_number)]
    assignments = [[[],[]] for m in range(blocks_number)]

    for layer_idx, layer_bram in enumerate(middle_layers):
        # get dst buffer
        blk_idx = layer_idx // layers_per2buffers
        buffer_idx = (layer_idx - blk_idx*layers_per2buffers)  % 2
        # get current buffer size
        buffer_bram = blocks_buffers[blk_idx][buffer_idx]
        # update: buffer should have enough space to contain 
        # previus and curremt layer result 
        blocks_buffers[blk_idx][buffer_idx] = max(buffer_bram, layer_bram)
        # store assigned layer_idx (first layer was removed)
        assignments[blk_idx][buffer_idx].append(layer_idx+1)

    return in_layer, blocks_buffers, out_layer, assignments


def shb_params(width,
                 byte=9,
                 shb=18,
                 shb_len=1024):
    
    if width <= byte:
        if width == 2:
            # 2 baytes each of 4 two bits values
            bram_width = 2*4*width
            bram_len = shb_len*8
        elif width == 4:
            # 2 baytes each of 2 four bits values
            bram_width = 2*2*width
            bram_len = shb_len*4
        elif width == 8 or width == 9:
            # 2 baytes each of 2 four bits values
            bram_width = 2*width
            bram_len = shb_len*2
        bram_blk = 1

    else:
        i = 0
        while True:
            # check multiplication of shb
            if width <= (2*byte)*i:
                break
            i += 1
        
        bram_width = (2*byte)*i
        bram_len = shb_len
        bram_blk = i
   
    return bram_width, bram_len, bram_blk
    

def get_bram_params(paralellism,
                    bit_width=8,
                    ):
    base_byte_width = 9 
    single_half_bram_bit_width = 18,
    bram_addresses=1024

    width = paralellism * bit_width
    bram_width, bram_len, bram_blk = shb_params(width,
                                                base_byte_width,
                                                single_half_bram_bit_width,
                                                bram_addresses)
    
    return width, bram_width, bram_len, bram_blk


def roms_usage(parameters_desc:list,
               bit_width=8):
    parameters_brams = []

    for shape, is_dw, paralellism in parameters_desc:
        # num of filters must be multiplication of paralellism
        aligned_filters = (shape[0]-1) // paralellism +1
        new_shape = [aligned_filters,shape[1]]
        
        # get params
        width, bram_width, bram_len, bram_blk = get_bram_params(paralellism,bit_width)
        brams = bram_usage(new_shape,
                            bit_width=width,
                            bram_bit_width=bram_width,
                            bram_addresses=bram_len)
        
        # print((shape, is_dw, paralellism),new_shape, width, bram_width, bram_len, bram_blk, brams)
        # for some cases 'one' mean more shb
        brams *= bram_blk
        # single half bram => single bram
        brams /= 2.0

        parameters_brams.append(brams)
    
    return parameters_brams

def DSP_cout(params):
    dsp_sum = 0
    for shape, is_dw, p in params:
        if is_dw:
            dsp_sum += 9+1
        else:
            dsp_sum += p*2 + 1
    
    return dsp_sum