import utils
import numpy as np
import numpy.random as rnd
import cv2 as cv
import os
import time
from threading import Thread
import threading
from queue import Queue
import callbacks as clb
import torch
from data_types import Types


class Transformer:
    def __init__(self, generator=rnd.default_rng(),**kwargs):
        """
        Initialization of Transformer object
        :param self: -
        :param generator: np.random.Generator object, 
                          default np.random.default_rng()
        :param kwargs: key-word type arguments where: key - name of method/transformation,
                        word-parameters of key-method
        """
        self.rand_generator = generator
        # names of transformation as np.array
        self.operations = np.array(list(kwargs))
        self.transform_dict = {}

        # format transformation args into tuples
        for k,v in kwargs.items():
            # if not tuple
            if type(v) is not tuple:
                self.transform_dict[k] = (v,)
            else:
                self.transform_dict[k] = v

    def __call__(self, X, y):
        """
        Apply transformation on image and it's bbox.
        Number of transformation and choice are random.
        :param self: -
        :param : X - image NxMx3, floating point [0.0;1.0] !!!
        :param : y - bbox np.array of size (4,)
        :return : X, y after applied transfomations
        """
        # get number of operation to execute on img
        num = self.rand_generator.integers(0,len(self.transform_dict.keys())+1)
        # num = len(self.transform_dict.keys())
        # get operations names to exec
        keys = self.rand_generator.choice(self.operations,size=num, replace=False)

        # execute operations with update of image and bbox
        for k in keys:
            X, y = getattr(self, k)(X, y,*self.transform_dict[k])
        
        return X, y

    def rotate(self, X, y, angle_min, angle_max, *args):
        """
        Image rotation around object center by random angle 
        from range [angle_min; angle_max].
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param angle_min: begin of angle range [deg]
        :param angle_max: end of angle range [deg]
        :param *args: anything
        :return : X, y after rotation
        """
        angle = self.rand_generator.random()*(angle_max-angle_min) + angle_min
        row,col = X.shape[:2]
        # center = (col/2, row/2)
        center = tuple(y[:2]) # rotate around 
        rot_mat = cv.getRotationMatrix2D(center, angle, 1.0)
        X = cv.warpAffine(X, rot_mat, (col,row))

        # adjust bounding box width and height,
        w_2 = y[2]/2
        h_2 = y[3]/2
        beta = np.arctan2(h_2, w_2)
        r = np.sqrt(w_2**2+h_2**2)
        angle = np.deg2rad(angle)
        gamma = [beta+angle,-beta+angle] # ,np.pi+beta+angle,np.pi-beta+angle]
        
        x_p = np.cos(gamma)
        y_p = np.sin(gamma)

        w = 2*r*np.max(np.abs(x_p))
        h = 2*r*np.max(np.abs(y_p))
        y[2:4] = [w,h]

        return X, y

    def scale(self, X, y, scale_min, scale_max, *args):
        """
        Image scale by random scale factor 
        from range [scale_min; scale_max].
        If after scaling object defined by y, object size is larger than input 
        image size, applied is scale which allow for closing object size 
        inside image size.
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param scale_min: begin of scale range > 0.0
        :param scale_max: end of scale range > 0.0
        :param *args: anything
        :return : X, y after scaling
        """
        # random interpolation
        interpolation = self.rand_generator.choice([cv.INTER_AREA, 
                                                    cv.INTER_NEAREST, 
                                                    cv.INTER_LANCZOS4, 
                                                    cv.INTER_LINEAR, 
                                                    cv.INTER_CUBIC])
        # random scale
        scale = self.rand_generator.random()*(scale_max-scale_min) + scale_min
        # output array's shape
        original_shape = np.array(X.shape[:2])
        # new bbox
        new_y = y*scale
        # scale saturation
        if not (new_y[2] < original_shape[1] and new_y[3] < original_shape[0]):
            new_scale = [original_shape[1]/y[2], original_shape[0]/y[3]]
            scale = np.min(new_scale)
        
        # resize img and rescale bbox
        new_img = cv.resize(X, None, fx=scale, fy=scale, interpolation=interpolation)
        y = y*scale
        scaled_shape = new_img.shape[:2]

        if scale < 1.0:
            # if new img is smaller -> fill with zeros
            X = np.zeros_like(X)
            X[:scaled_shape[0], :scaled_shape[1],:] = new_img
        else:
            #if image is larger -> try get equal surroundings of object center
            end = [y[1], y[0]]+original_shape//2
            # saturate by rescaled image size
            end = np.where(end<scaled_shape, end, scaled_shape).astype(np.int)
            beg = end - original_shape
            # if obj is too close left-top => start from (0,0)
            beg = np.where(beg<0,0,beg)
            end = beg +original_shape
            # get part of new image and change offset
            X = new_img[beg[0]:end[0],beg[1]:end[1],:]
            y[0] -= beg[1]
            y[1] -= beg[0]
        
        return X, y
    
    def blur(self, X, y, max_kernel_size=1, *args):
        """
        Image blur with random kernel size from range [1;max_kernel_size]. 
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param max_kernel_size: max size of kernel
        :param *args: anything
        :return : X, y after blur
        """
        # get random filter size
        k_size = self.rand_generator.integers(1, max_kernel_size+1)
        k_size = (k_size//2)*2+1

        if k_size > 2:
            X = cv.blur(X, (k_size, k_size))

        return X, y

    def equalize_hist(self, X, y, probability=0.1, *args):
        """
        Image histograms equalizations. Transformation is executed with given 
        probaility.  
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param probaility: probaility value of transformation execution
        :param *args: anything
        :return : X, y after histograms equalizations
        """
        p = self.rand_generator.random()
        if p < probability:
            X = (X*255).astype(np.uint8)
            X[:,:,0] = cv.equalizeHist(X[:,:,0])
            X[:,:,1] = cv.equalizeHist(X[:,:,1])
            X[:,:,2] = cv.equalizeHist(X[:,:,2])
            X = X/255.0

        return X, y
    
    def translate(self, X, y, x_min_max, y_min_max,*args):
        x_move = self.rand_generator.integers(*x_min_max)
        y_move = self.rand_generator.integers(*y_min_max)
        
        # check if bbox after move is on image 
        xy_min = (y[:2] - y[2:]/2).astype(np.int)
        xy_max = (xy_min + y[2:]).astype(np.int)
        end_point = np.array(X.shape[:2][::-1])
        xy_move = np.array([x_move,y_move])
        c1 = (xy_min + xy_move) < 0
        c2 = (xy_max + xy_move) < end_point
        c = np.sum(c1+c2)
        
        # object is out of img
        if c > 0:
            # return unchanged img and bbox
            return X, y
        
        beg = np.maximum(xy_move,0)
        end = np.minimum(end_point+xy_move,end_point)
        M = np.float32([[1, 0, x_move],
                        [0, 1, y_move]])
        X = cv.warpAffine(X, M, X.shape[:2][::-1])
        y[:2] += xy_move

        return X, y

    def HSV(self, X, y, sigma,*args):
        X = cv.cvtColor(X, cv.COLOR_BGR2HSV)
        rand_noise = self.rand_generator.normal(loc=0, scale=sigma, size=X.shape)
        # add noise to original image
        X += rand_noise
        # avoid overflow
        np.clip(X, 0.0, 1.0)
        
        X = cv.cvtColor(X, cv.COLOR_HSV2BGR)
        return X, y

    def LAB(self, X, y, sigma,*args):
        X = cv.cvtColor(X, cv.COLOR_BGR2LAB)
        rand_noise = self.rand_generator.normal(loc=0, scale=sigma, size=X.shape)
        # add noise to original image
        X += rand_noise
        # avoid overflow
        np.clip(X, 0.0, 1.0)
        X = cv.cvtColor(X, cv.COLOR_LAB2BGR)
        
        return X, y

    def YCrCb(self, X, y, sigma,*args):
        X = cv.cvtColor(X, cv.COLOR_BGR2YCrCb)
        rand_noise = self.rand_generator.normal(loc=0, scale=sigma, size=X.shape)
        # add noise to original image
        X += rand_noise
        # avoid overflow
        np.clip(X, 0.0, 1.0)
        X = cv.cvtColor(X, cv.COLOR_YCrCb2BGR)
        
        return X, y

    def horizontal_flip(self, X, y, *args):
        """
        Image horizontal flip
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param *args: anything
        :return : X, y after flip
        """
        X = np.fliplr(X)
        y[0] = X.shape[1] - y[0]
        
        return X, y

    def vertical_flip(self, X, y, *args):
        """
        Image vertical flip
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param *args: anything
        :return : X, y after flip
        """
        X = np.flipud(X)
        y[1] = X.shape[0] - y[1]
        
        return X, y
    
    def dilate(self, X, y, max_kernel_size, *args):
        """
        Apply on image maximal filter of random kernel size from 
        range [1; max_kernel_size]
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param *args: anything
        :param max_kernel_size: int, max size of dilate kernel 
        :return : X, y after dilate
        """
        # get random filter size
        k_size = self.rand_generator.integers(1, max_kernel_size+1)
        k_size = (k_size//2)*2+1
        # create structural element
        se = np.ones((k_size, k_size), dtype=X.dtype)
        if k_size > 2:
            # exec dilation
            X = cv.dilate(X, se)
        
        return X, y
    
    def erode(self, X, y, max_kernel_size, *args):
        """
        Apply on image minimal filter of random kernel size from 
        range [1; max_kernel_size]
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param *args: anything
        :param max_kernel_size: int, max size of dilate kernel 
        :return : X, y after erode
        """
        # get random filter size
        k_size = self.rand_generator.integers(1, max_kernel_size+1)
        k_size = (k_size//2)*2+1
        # create structural element
        se = np.ones((k_size, k_size), dtype=X.dtype)
        
        if k_size > 2:
            # exec erode
            X = cv.erode(X, se)
        
        return X, y

    def noise(self, X, y, sigma, *args):
        """
        Add to image noise with normal distribution of mean at 0 
        and standard deviation sigma.
        Expect X of type float normalized to [0.0;1.0].
        Output is saturated to range [0.0;1.0]
        :param self: -
        :param X : image np.array of shape NxM x3
        :param y: bbox np.array of size (4,)
        :param *args: anything
        :param sigma: standard deviation of noise 
        :return : X, y after adding noise
        """
        rand_noise = self.rand_generator.normal(loc=0, scale=sigma, size=X.shape)
        # add noise to original image
        X += rand_noise
        # avoid overflow
        np.clip(X, 0.0, 1.0)

        return X, y


class BaseGenerator(clb.BaseCallback):

    MAX_NUMBER_OF_THREADS = 30


    def __init__(self, batch_size):
        super().__init__()
        self.batch_size = batch_size
        # for paralelizm
        self.thread = None
        self.thread_data = (-1, None) # (idx, data)
    
    def __getstate__(self):
        """
        Return dict without thread object and it's data
        """
        d = self.__dict__.copy() 
        # save as reset 
        d['thread'] = None
        d['thread_data'] = (-1, None)
        
        return d

    def __getitem__(self, idx, debug=False):
        # while debug mode run sequential version
        if debug or BaseGenerator.MAX_NUMBER_OF_THREADS < 3:
            data = self.load_data(idx, debug)
        else:
            # load data with paralellism
            data =  self.get_data(idx)
        
        return data

    # method to overload
    def __len__(self):
        raise Exception('This method should be overloaded')

    # method to overload
    def load_data(self, idx, debug=False):
        """
        Method should return data 
        for idx-th batch of data.
        If idx is out of range method should return None. 
        
        :param idx: index of batch to load
        :param debug: debug mode could give specific results 
        
        :retrun data: data for idx-th batch or None if out of range 
        """
        raise Exception('This method should be overloaded for sequetial parallelism of data loading')

    def get_data(self, idx):
        """
        Method return data for idx by parallel.
        if idx-th data loading were started earlier, these data are returned,
        else data are loaded by this thread sequentially.
        
        Method start loading next batch in parallel.
        
        :param idx: index of batch to load
        
        :return data: loaded data for idx-th batch
        """
        # wait for thread if run
        self._join()
        # check idx of loaded data
        if self.thread_data[0] == idx:
            data = self.thread_data[1]
        # loaded previously data is not appropriate 
        else: 
            # load idx-th batch of data by this main thread
            data = self.load_data(idx)
        
        # start loading ext batch
        self.load_data_parallel(idx+1)
        
        return data

    def _join(self):
        """
        Method join existing thread with main thread.
        """
        if self.thread is not None:
            self.thread.join()
            self.thread = None

    def load_data_parallel(self, idx):
        """
        Method loads idx-th batch of data into self.thread_data, 
        without check if data were loaded previously. 
        Method does not return anything directly. 
        To obtain data from parallel thread, thread must by joined by self._join()
        and then returned data are available by self.thread_data.
        
        :param idx: index of batch to load
        
        :return : None
        """
        # if previous were not joined / finished
        if self.thread is not None:
            self._join()
        # create new thread
        thread = threading.Thread(target=self._thread_function, 
                                  args=(idx,))
        # run it without wait
        thread.start()
        # and save
        self.thread = thread

    def _thread_function(self, idx):
        """
        Method call method load_data in parallel thread
        :param idx: index of batch to load
        """
        data = self.load_data(idx)
        # save data with idx 
        self.thread_data = (idx, data)

    def _parallel_loading_init(self):
        """
        Method initialize parallel loading
        """
        # run get first batch
        if BaseGenerator.MAX_NUMBER_OF_THREADS > 2:
            self.load_data_parallel(0)

    def _parallel_loading_end(self):
        """
        Method finish parallel loading
        """
        # join last thread
        self._join()
        # reset thread data
        self.thread_data = (-1, None)
    
    def reset(self):
        super().reset()
        # self._join()
        if self.thread is not None:
            self.thread.join(3)
            self.thread = None

        self.thread_data = (-1, None)

    def on_epoch_begin(self, *args, **kwargs):
        self.reset()
        self._parallel_loading_init()

    def on_training_begin(self, *args, **kwargs):
        self.reset()
        self._parallel_loading_init()

    def on_training_end(self, *args, **kwargs):
        self._parallel_loading_end()
    
    # used for validation and test set evaluation
    def on_score_begin(self, *args, **kwargs):
        self.reset()
        self._parallel_loading_init()

    def on_score_end(self, *args, **kwargs):
        self._parallel_loading_end()

    def on_epoch_end(self, *args, **kwargs):
        self._parallel_loading_end()


def to_anchors_for_iou_loss(self, bboxes, for_each_anchor=True, neighbors=False):
    batch_size = bboxes.shape[0]
    batch_idx = np.arange(0,batch_size,dtype=Types.NP_INDEX)
    num_of_anchors = self.anchors.shape[0]
    output_size = list(self.output_size)

    # field of view for single output neuron WH
    anchor_window = np.array(list(self.input_shape[:2])[::-1]) / output_size
    # normalize bbox to reference anchor size
    normalized_xy = bboxes[:,:2] / anchor_window
    # xy indeces of neuron
    anchor_pos = np.floor(normalized_xy).astype(Types.NP_INDEX)

    if not for_each_anchor:
        # get shape similarity bbox for each anchor 
        similarity = [utils.shape_similarity(bboxes[:,2:], anchor).reshape(-1,1) for anchor in self.anchors]
        similarity = np.concatenate(similarity, axis=1)
        # get most similar anchors idx
        indeces = np.argmax(similarity, axis=1).astype(Types.NP_INDEX)
    else:
        batch_idx = np.tile(batch_idx, (num_of_anchors,))
        indeces = [np.ones(batch_size, dtype=Types.NP_INDEX)*i for i in range(num_of_anchors)]
        indeces = np.concatenate(indeces, axis=0)
        anchor_pos = np.tile(anchor_pos,(num_of_anchors,1))
        bboxes = np.tile(bboxes, (num_of_anchors,1))
    
    if neighbors:
        # propagate on the neighbors
        a_p = []
        offsets = np.array([
                            [0,0],  [0,-1],[0,1],
                            [-1,-1],[-1,0],[-1,1],
                            [1,-1], [1,0], [1,1]
                            ])
        for offset in offsets:
            a_p.append(anchor_pos-offset)
        
        anchor_pos = np.concatenate(tuple(a_p), axis=0)
        # tiling
        batch_idx = np.tile(batch_idx, (offsets.shape[0],))
        indeces = np.tile(indeces, (offsets.shape[0],))
        bboxes = np.tile(bboxes, (offsets.shape[0],1))
        
    # prevent out of range
    prev_pos = anchor_pos
    anchor_pos = np.clip(anchor_pos, 
                         a_min=np.array([0,0]), 
                         a_max=np.array(output_size)-1)
    # comp = anchor_pos != prev_pos
    # if np.sum(comp) > 0:
    #     print(prev_pos.tolist())
    #     print(anchor_pos.tolist())
    #     raise Exception("Wrong anchor pos.",)
    
    # position X and Y
    pos_X = anchor_pos[:,0]
    pos_Y = anchor_pos[:,1]
    pos_anchor = indeces
    # bboxes from xcycwh to ltrb
    bboxes = utils.xcycwh_to_ltrb(bboxes.copy()).astype(Types.NP_F_DEFAULT)

    return bboxes, batch_idx, pos_anchor, pos_X, pos_Y


def numpy_to_torch_iou_params(device):

    def tmp(X,y, device=device):
        X = torch.tensor(np.moveaxis(X, 3, 1 ), dtype=Types.T_F_DEFAULT).contiguous().to(device)
        
        y_out = []
        for i in range(len(y)):
            y_out.append(torch.tensor(y[i], device=device))

        return X, tuple(y_out)

    return tmp
    

# class YoloDataGenerator(keras.utils.Sequence, BaseGenerator):
class YoloDataGenerator(BaseGenerator):

    NUMBER_OF_THREADS = BaseGenerator.MAX_NUMBER_OF_THREADS if BaseGenerator.MAX_NUMBER_OF_THREADS < 3 \
                                                           else BaseGenerator.MAX_NUMBER_OF_THREADS-1
    NAIVE_RESIZE = False

    def __init__(self,
                path_to_dataset,
                input_shape,
                anchors,  # [[21,21], [50,50], [100,100]]
                images_labes, # [('img_path', 'label_path')], 
                batch_size,
                name='YoloDataGenerator', 
                augmentator=None,
                output_size=None,
                rand_generator=rnd.default_rng(),
                after_load=None,
                bbox_to_anchors=to_anchors_for_iou_loss,
                ):
        """
        Initialize Generator object.
        :param self: -
        :param path_to_dataset: path to directory with dataset
        :param input_shape:  shape of images 
        :param anchors: size of anchors np.array of shape N x 2
        :param images_labes: list of tuples ('path_to_img', 'path_to_bbox')
                             both paths are relative to path_to_dataset
        :param batch_size: size of batch, int
        :param name: name of genrator
        :param augmentator: object which allow for augmentation
                          - overloaded __call__(X, bbox)
                                - X img, bbox
        :param output_size: size of output layer (W,H) - np.array of shape (2,)
        :param rand_generator: np.random.Generator object, 
                               default np.ranodom.default_rng()
        :param after_load: function like X,y = after_load(X,y)
                            addition processing of X,y batch like numpy_to_torch
        """
        super().__init__(batch_size)
        
        self.images_labes = images_labes
        self.path_to_dataset = path_to_dataset
        self.name = name
        self.augmentator = augmentator
        self.anchors = anchors
        self.input_shape = input_shape
        self.rand_generator = rand_generator
        self.after_load = after_load
        self.to_anchors = bbox_to_anchors
        self.output_size = output_size
        
    def load_data(self, idx, debug=False):
        """
        Get one batch of images with references outputs of each anchor's maps.
        Possible is return of batch bounding box - for debug=True
        :param self: - 
        :param idx: int, index of batch
        :param debug: bool, flag which allows for return also bboxes, 
                      default False
        :return: X - batch of images - np.array,
                 y - tuple of batches of anchor's maps - np.array,
                 bbox - batch of bbox - np.array
        """
        if idx >= self.__len__():
            return None
        
        X, bbox = self.load_batch(idx)
        # convert bbox to anchors related format or whatever is needed 
        y = self.to_anchors(self, bbox)
        
        # possible additional operation on input and labes data like: convert numpy to tensor
        if self.after_load:
            X, y = self.after_load(X, y)
        
        # return also bbox when is used debug mode
        if debug:
            return X, y, bbox
        
        return X, y
    
    def load_batch(self, idx):
        """
        Load batch of images with corresponding bboxes.
        If augmentator object is available, augmentation is applied 
        for each image(it's with bbox).
        Augmentation is executed by second thread, first thred load 
        data from disc to queue.
        :param self: - 
        :param idx: int, index of batch
        :return: X - np.array of shape batch_size x image_shape, 
                 y - np.array of shape batch_size x 4 [xc, yc, w, h]
        """
        # indeces of begin and end of idx-batch
        batch_beg = idx*self.batch_size
        batch_end = min(batch_beg+self.batch_size, len(self.images_labes))
        # batch size have not to be the same at the end of data
        batch_size = max(0, batch_end - batch_beg)
        # init empty arrays
        X = np.empty((batch_size,)+self.input_shape, dtype=Types.NP_F_DEFAULT)
        y = np.empty((batch_size,)+(4,), dtype=Types.NP_F_DEFAULT)

        # create queue and fill with indeces
        queue = Queue(batch_size,)
        for i in range(batch_size):
            queue.put(i)

        def processing_fcn(self=self, queue=queue, batch_beg=batch_beg, X=X, y=y):
            while not queue.empty():
                try:
                    # get in-batch position
                    pos = queue.get()
                    # unlock queue for another thread
                    queue.task_done()
                except:
                    # get could raise an exception when queue is empty
                    # so going to next iteration allow for processing data, when they appear in meantime
                    # if not main loop condition will braek the loop
                    continue
                
                # index at images_labes
                index = batch_beg + pos
                # load image
                th_img = cv.imread(os.path.join(self.path_to_dataset, self.images_labes[index][0]) )
                # get bbox
                th_bbox = self.images_labes[index][1].copy()
                # optional error printing
                if th_img is None or th_bbox is None:
                    print("Error while reading {}-th element as img_path = {} ({}) bbox = {}".format(index,os.path.join(self.path_to_dataset, self.images_labes[index][0]), *self.images_labes[index]))
                else:
                    H_in, W_in = th_img.shape[:2]
                    H_dst, W_dst = self.input_shape[:2]
                    # if resize is necessary
                    if H_in != H_dst or W_in != W_dst:
                        # resize image 
                        if YoloDataGenerator.NAIVE_RESIZE:
                            th_img = cv.resize(th_img, (W_dst, H_dst), interpolation=cv.INTER_LINEAR)
                            W_new = W_dst
                            H_new = H_dst
                        else:
                            th_img, W_new, H_new = resize(th_img, 
                                                            W_dst, 
                                                            H_dst, 
                                                            INTER=cv.INTER_LINEAR)
                        # rescale bbox
                        th_bbox[0::2] *= W_new/W_in 
                        th_bbox[1::2] *= H_new/H_in

                    # normalize
                    th_img = th_img.astype(np.float32) / 255

                    if self.augmentator:
                        th_img, th_bbox = self.augmentator(th_img, th_bbox)
                    
                    # save in arrays
                    X[pos,:,:,:] = th_img
                    y[pos,:] = th_bbox

        num_of_threads = YoloDataGenerator.NUMBER_OF_THREADS
        # create threads and start them
        threads = [Thread(target=processing_fcn) for i in range(num_of_threads-1)]
        for th in threads:
            th.start()
        # processing also at main thread
        processing_fcn()
        # when main thread completed = > nothing to process
        # join all threads
        for th in threads:
            th.join()

        return X, y
        
    def __len__(self):
        """
        Return number of batches available for that generator
        :param self: -
        :return : number of batches as integer
        """
        return ((len(self.images_labes)-1)//self.batch_size) + 1
    
    def on_epoch_end(self, *args, **kwargs):
            """
            Method called to apply random images sequences
            :param self: -
            """
            super().on_epoch_end()
            self.rand_generator.shuffle(self.images_labes)


def resize(img, W_DST, H_DST, INTER):
    H,W = img.shape[:2]

    # sizes after scale for each axis
    H1 = H * W_DST / W # W1 as W_DST
    W1 = W * H_DST / H # H1 as H_DST

    # prevent img cut
    if H1 > H_DST:
        H1 = H_DST
    elif W1 > W_DST:
        W1 = W_DST

    # new shape as int
    W1 = int(W1)
    H1 = int(H1)
    # resize img with keep ratio
    img = cv.resize(img,(W1,H1), interpolation=INTER)
    # final shape
    out_img = np.zeros((H_DST,W_DST,img.shape[2]), dtype=img.dtype)
    # paste resized img, img parts can have black areas
    out_img[:H1,:W1,:] = img

    return out_img, W1,H1











