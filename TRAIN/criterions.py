import torch
import utils
import metrics
import callbacks
from data_types import Types
import quantizers as q


class BaseCriterion:
    def __init__(self):
        pass
    
    def __call__(self, y_pred, y_ref):
        pass


class MultioutputCriterion(BaseCriterion):

    def __init__(self, criterions, weights=None):
        self.criterions = criterions
        self.weights = weights if weights is not None else [1]**len(criterions)

    def __call__(self, y_pred, y_ref):
        """
        :params y_pred: list of tensors
        :params y_ref: list of tensors
        """
        zipped = list(zip(y_pred, y_ref, self.criterions, self.weights))
        
        # first loss
        pred, ref, c, w = zipped[0]
        loss = c(pred, ref)*w
        
        # rest of losses
        for pred, ref, c, w in zipped[1:]:
            loss += c(pred, ref)*w

        return loss



def mean_square_value(y):
    return torch.mean(y**2)
    
mean_sqare_value = mean_square_value


def sqrt_loss(y_pred, y_ref):
    e = (torch.sqrt(y_ref) - torch.sqrt(y_pred))**2
    return torch.mean(e)


def sqrt_exp_loss(y_pred, y_ref):
    e_pred = torch.exp(y_pred)
    e_ref = torch.exp(y_ref)

    return sqrt_loss(e_pred, e_ref)


def predicted_to_bbox_at_pos(y_pred, 
                             num_of_anchors,
                             anchor_window,
                             anchors,
                             batch_idx, 
                             pos_anchor,
                             pos_X,
                             pos_Y):

    X = torch.sigmoid(y_pred[batch_idx,num_of_anchors+pos_anchor, pos_Y, pos_X])
    Y = torch.sigmoid(y_pred[batch_idx,2*num_of_anchors+pos_anchor, pos_Y, pos_X])
    W = y_pred[batch_idx,3*num_of_anchors+pos_anchor, pos_Y, pos_X]
    H = y_pred[batch_idx,4*num_of_anchors+pos_anchor, pos_Y, pos_X]
    # to absolute units
    X = ((pos_X + X)*anchor_window[0]).reshape(-1,1)
    Y = ((pos_Y + Y)*anchor_window[1]).reshape(-1,1)
    W = (torch.exp(W)*anchors[pos_anchor,0]).reshape(-1,1)
    H = (torch.exp(H)*anchors[pos_anchor,1]).reshape(-1,1)
    # concatenate to bbox
    bbox_pred = torch.cat((X,Y,W,H), dim=1)
    # convert from [X center, Y center, width, height] to [left, top, right, bottom]
    bbox_pred = utils.xcycwh_to_ltrb(bbox_pred)

    return bbox_pred


def focal_loss(y, eps=1e-8):
    return y*torch.sqrt(1+eps-torch.exp(-y))


def super_loss(loss, eps=1e-8):
    exponential_loss = torch.exp(-loss)
    exp_cross_entropy = -loss*torch.log((1+eps) - exponential_loss)
    
    return exp_cross_entropy + loss + torch.sqrt(loss)
    
def sqrt_of_abs(y):
    return torch.sqrt(torch.abs(y))
       
    
class NearestQuantLoss:
    
    def __init__(self, bit_width, int_width, signed=True, 
                 narrow_range=False, norm=torch.abs, 
                 reduction=torch.mean):
        super().__init__()
        self.bit_width = bit_width 
        self.int_width = int_width 
        self.signed = signed
        self.narrow_range = narrow_range
        self.norm = norm
        self.reduction = reduction
    
    def __call__(self, x):
        
        # TODO - check why NaN is returned
        
        scale = 2**(self.int_width-self.signed)
        # get range of values
        min_val = (-(2**(self.bit_width-1))+self.narrow_range) if self.signed else 0
        max_val = 2**(self.bit_width-self.signed) -1 - self.narrow_range
        # abs max range
        max_abs = max(abs(min_val), abs(max_val))
        # find the mostly similar quant value 
        with torch.no_grad():
            # rescale to [-1,1] +- overflow
            y = x / scale
            # make abs(1) to be max quant value 
            y *= max_abs
            # limit to bit width range
            y = torch.clamp(y, min_val, max_val)
            # to range [0,2**bit_width]
            y -= min_val
            # quntization
            y = torch.round(y)
            # back to original space
            y += min_val
            y *= scale / max_abs
            
        dist_norm = self.norm(x-y)
        reduced = self.reduction(dist_norm)
        if torch.isnan(reduced).item():
            raise Exception(x, y, dist_norm, reduced)

        return reduced


class YoloIOULoss(BaseCriterion):

    def __init__(self, anchors, input_shape, weights=[1,1], iou_mode='giou'):
        self.anchors = torch.tensor(anchors)
        self.input_shape = torch.tensor(list(input_shape), dtype=Types.T_F_DEFAULT)
        self.weights = weights
        self.loss_validity = 0
        self.loss_iou = 0
        self.iou_mode = iou_mode

    def __getstate__(self):
        d = self.__dict__.copy()
        d['anchors'] = self.anchors.cpu().detach().numpy()
        d['input_shape'] = self.input_shape.cpu().detach().numpy()
        
        return d

    def __setstate__(self, d):
        self.__dict__ = d
        self.anchors = torch.tensor(d['anchors'])
        self.input_shape = torch.tensor(d['input_shape'])
        # self.weights = d['weights']
        self.loss_validity = d['loss_validity'] if 'loss_validity' in d.keys() else 0
        self.loss_iou = d['loss_iou'] if 'loss_iou' in d.keys() else 0
        self.iou_mode = d['iou_mode'] if 'iou_mode' in d.keys() else 'giou'

    def __call__(self, y_pred, y_ref):
        # some constants
        dev = y_pred.device
        batch_size = y_pred.shape[0]
        # batch_idx = torch.arange(0, batch_size, dtype=torch.long, device=dev)
        num_of_anchors = self.anchors.shape[0]
        # set device
        self.anchors = self.anchors.to(dev) 
        self.input_shape = self.input_shape.to(dev)
        # WH
        output_size = torch.tensor(list(y_pred.shape[-2:])[::-1], device=dev)
        # single neuron's field of view
        anchor_window = torch.flip(self.input_shape[:2], dims=(0,)) / output_size

        # get references
        bboxes_ref, batch_idx, pos_anchor, pos_X, pos_Y = y_ref
        V_ref = torch.zeros((batch_size,num_of_anchors,output_size[1],output_size[0]), 
                            dtype=Types.T_F_DEFAULT, 
                            device=dev)
        V_ref[batch_idx,pos_anchor,pos_Y,pos_X] = 1.0

        # network answers
        # validity/objectness/probability
        V_pred = torch.sigmoid(y_pred[:,:num_of_anchors,:,:])
        # bboxes at reference positions
        bboxes_pred = predicted_to_bbox_at_pos(y_pred, num_of_anchors,
                                               anchor_window, self.anchors, 
                                               batch_idx, pos_anchor, 
                                               pos_X, pos_Y)
        
        # loss of validity
        validity_loss = torch.nn.functional.binary_cross_entropy(V_pred, V_ref, reduction='none')
        # validity_loss = super_loss(validity_loss)
        validity_loss = torch.mean(validity_loss)
        # loss of bbox prediction
        iou_loss = 1 - metrics.iou_based_metric(bboxes_pred, bboxes_ref, border_width=1, mode=self.iou_mode)
        # iou_loss = super_loss(iou_loss)
        iou_loss = torch.mean(iou_loss)
       
        # save losses for display
        self.loss_validity = validity_loss
        self.loss_iou = iou_loss
       
        return self.weights[0]*validity_loss + self.weights[1]*iou_loss


# class Regularization(BaseCriterion):
class Regularization(BaseCriterion, callbacks.BaseCallback):
    """
    Must be added also as callback!!!
    """

    def __init__(self, 
                 loss_fcn, 
                 regularization_loss=mean_sqare_value, 
                 weights=[1,1]):
        self.regularization_loss = regularization_loss
        self.loss_fcn = loss_fcn
        self.weights = weights
        self.model = None
        self.main_loss = 0
        self.reg_loss = 0

    def __getstate__(self):
        d = {k:v for (k, v) in self.__dict__.items()}
        # prevent of torch.nn.Module save
        d['model'] = None

        return d
        
    def __setstate__(self, d):
        self.__dict__ = d
        
        if 'main_loss' not in d.keys():
            self.main_loss = 0
        
        if 'reg_loss' not in d.keys():
            self.reg_loss = 0
        
        return d

    def on_fit_begin(self, state, model):
        # save model reference for weight regularization
        self.model = model
    
    def compute_regularization_loss(self):
        dev = next(self.model.parameters()).device
        loss = torch.tensor(0., device=dev)
        cntr = 0
        
        for n,p in self.model.named_parameters():
            # ommit quantizers
            if '.tensor_quant.' in n:
                continue
            
            loss += self.regularization_loss(p)
            cntr += 1
        
        return loss / cntr

    def bit_width_regularization(self):
        dev = next(self.model.parameters()).device
        bit_width_loss = torch.tensor(0.0, dtype=torch.float32, device=dev)
        cntr = 0
        
        for m in self.model.modules():
            if isinstance(m,q.ParameterBitWidth):
                bit_width_loss += m.forward()
                cntr += 1
        
        # if there are not bit width modules
        return bit_width_loss / cntr if cntr else torch.tensor(0.0, dtype=torch.float32, device=dev)        

    def __call__(self, y_pred, y_ref):
        loss = self.loss_fcn(y_pred, y_ref)
        reg_loss = self.compute_regularization_loss()
        
        self.main_loss = loss
        # reg loss with bit width loss
        self.reg_loss = reg_loss + 0.01*self.bit_width_regularization() / 8
        
        return self.weights[0]*loss + self.weights[1]*reg_loss
   



