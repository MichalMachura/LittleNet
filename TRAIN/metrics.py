import torch
import numpy as np
import utils
from data_types import Types


class BaseMetric:
    
    def __init__(self, device='cpu'):
        self.device = device

    def to(self, device):
        if Types.is_device(device):
            self.device = device
        for k,v in self.__dict__.items():
            if type(v) is torch.tensor:
                v.to(device)

    def __call__(self, y_predict, y_ref):
        pass


class CONSTANTS:
    CIOU_SWITCH = True
    OLD_TORCH = False


def iou_based_metric(bbox1, bbox2, border_width=1, mode='iou', eps=1e-7):
    """
    :param bbox1: tensor of shape (-1,4) as [L,T,R,B]
    :param bbox2: tensor of shape (-1,4) as [L,T,R,B]
    :param border_width: width of border
    :param mode: type of iou loss
                available: ['iou', 'giou', 'diou', 'ciou', 'gciou', 'gdciou']
                'gciou' is ciou minus giou_part. Could be named as 'Generalized Complete IoU'
                'gdciou' return tuple('iou', 'giou', 'diou', 'ciou'), but not 'gciou'! 
    :return iou_loss:
    """
    
    # convert types - float16 has too small range
    bbox1 = bbox1.to(torch.float32)
    bbox2 = bbox2.to(torch.float32)
    
    if mode not in ['iou', 'giou', 'diou', 'ciou', 'gciou', 'gdciou']:
        raise Exception("Mode '{}' not is not supported!".format(mode))
    
    if CONSTANTS.OLD_TORCH:
        LT = torch.max(bbox1[:,:2], bbox2[:,:2])
        RB = torch.min(bbox1[:,-2:],bbox2[:,-2:])
    else:
        LT = torch.maximum(bbox1[:,:2], bbox2[:,:2])
        RB = torch.minimum(bbox1[:,-2:],bbox2[:,-2:])
    
    # calculate width and height of intersection
    WH = RB - LT + border_width
    # negative values of wh mean that intersection is not met.
    WH = WH.clamp(min=0)
    # calc intersection area
    intersection = WH[:,:1]*WH[:,1:]
    # get width and height of bboxes
    WH1 = bbox1[:,-2:] - bbox1[:, :2] + border_width
    WH2 = bbox2[:,-2:] - bbox2[:, :2] + border_width
    # calc area of boxes
    A = WH1[:, :1]*WH1[:, -1:]
    B = WH2[:, :1]*WH2[:, -1:]

    # IoU metric value
    iou = intersection / (A+B-intersection+eps)

    if mode != 'iou':
        # compute the smallest box with both boxes A and B
        if CONSTANTS.OLD_TORCH:
            C_LT = torch.min(bbox1[:,:2], bbox2[:,:2])
            C_RB = torch.max(bbox1[:,-2:],bbox2[:,-2:])
        else:
            C_LT = torch.minimum(bbox1[:,:2], bbox2[:,:2])
            C_RB = torch.maximum(bbox1[:,-2:],bbox2[:,-2:])
        
        C_WH = C_RB - C_LT + border_width

    # init with 0, when needed values will be changed
    giou_part = diou_part = ciou_part = 0.0
    
    if mode in ['giou', 'gciou', 'gdciou']:
        # area of C
        C = C_WH[:,:1]*C_WH[:,1:2]
        # area out of boxes A and B included in C
        C_nor_AB = C - (A + B - intersection)
        # ratio of out of boxes AB to C
        giou_part = C_nor_AB / (C+eps)
       
    if mode in ['gciou', 'diou', 'ciou', 'gdciou']:
        # centers of A and B
        A_center = bbox1[:,:2] + WH1/2
        B_center = bbox2[:,:2] + WH2/2
        # distances of center
        d = torch.sum((B_center-A_center)**2, axis=1).reshape(-1,1)
        # diagonal of C box
        c = torch.sum(C_WH**2, axis=1).reshape(-1,1)
        # distance of centers normalized to diagonal length
        diou_part = d/c 
    
    if mode in ['gciou', 'ciou', 'gdciou']:
        # normalized WH ratio 
        arc1 = torch.atan2(WH1[:,:1], WH1[:,1:2])
        arc2 = torch.atan2(WH2[:,:1], WH2[:,1:2])
        # scale difference metric
        V = ((2.0/np.pi)*(arc2 - arc1))**2
        
        # 'trade-off' factor - CONST !?
        with torch.no_grad():
            alpha = V / (V + 1 - iou+eps)
            # alpha = 1
            # # when iou is small => do not use scale metric 
            if CONSTANTS.CIOU_SWITCH:
                alpha = torch.where(iou < 0.5, torch.tensor(0., dtype=V.dtype, device=bbox1.device), alpha)       
        
        # scale metic part
        ciou_part = alpha*V

    if mode == 'gdciou':
        giou = iou - giou_part
        diou = iou - diou_part
        ciou = diou - ciou_part
        
        return iou, giou, diou, ciou
    else:
        return iou - giou_part - diou_part - ciou_part


class ProxyMetric(BaseMetric):
    """
    Proxy object which allow to make computions and storage inside another object,
    and return only the value of one of the results stored in list.
    """
    def __init__(self, values_container, idx):
        self.values_container = values_container
        self.idx = idx

    def __call__(self, y_predict, y_ref):
        return self.values_container[self.idx]


class ProxyAttributeMetric(BaseMetric):
    def __init__(self, obj, attr_name):
        self.obj = obj
        self.attr_name = attr_name

        if not hasattr(self.obj, self.attr_name):
            raise Exception("obj:{}, has not attr:{}".format(self.obj,self.attr_name))

    def __call__(self, y_pred, y_ref):

        if not hasattr(self.obj, self.attr_name):
            raise Exception("obj:{}, has not attr:{}".format(self.obj,self.attr_name))

        return getattr(self.obj, self.attr_name)


class SingleObjectIOUsBasedMetrics(BaseMetric):

    def __init__(self, anchors, img_shape, device='cpu'):
        super().__init__(device)
        self.anchors = torch.tensor(anchors, dtype=Types.T_F_DEFAULT, device=device)
        self.img_shape = img_shape
        self.metrics = [0,0,0,0]

    def get_gdciou(self):
        """
        :return giou, diou, ciou: ProxyMetric objects
        """
        return ProxyMetric(self.metrics, 1),\
               ProxyMetric(self.metrics, 2),\
               ProxyMetric(self.metrics, 3)
        
    def __call__(self, y_predicted, y_ref):
        with torch.no_grad():
            y_pred = y_predicted.clone().detach()
            y_pred[:,:3*self.anchors.shape[0],:,:] = torch.sigmoid(y_pred[:,:3*self.anchors.shape[0],:,:])
            # get predicted bboxes 
            bbox_pred = utils.yolo_outputs_to_single_bbox_v3(y_pred, self.anchors, self.img_shape)
            # convert (p)xcycwh into left top right bottom
            bbox_pred = utils.xcycwh_to_ltrb(bbox_pred[:,1:])
            # reference bboxes
            bbox_ref = y_ref[0]

            # when is used mode 'for_each_anchor' at to_anchor_for_iou_loss
            if bbox_pred.shape[0] < bbox_ref.shape[0]:
                bbox_ref = bbox_ref[:bbox_pred.shape[0],:]

            # calculate iou based factors for each sample in batch
            iou_based_values = iou_based_metric(bbox_pred, bbox_ref, border_width=1, mode='gdciou')
            
            for i, m in enumerate(iou_based_values):
                # calculate mean of iou based metric
                self.metrics[i] = torch.mean(m).item()

        # return iou
        return self.metrics[0]




