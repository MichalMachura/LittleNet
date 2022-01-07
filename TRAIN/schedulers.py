import numpy as np


class BaseScheduler:

    def __init__(self):
        pass

    def step(self, optimizer, loss, epoch):
        pass


class LossDependentScheduler(BaseScheduler):

    def __init__(self, mul=2.0, div=4, init_loss=-np.inf, init_lr=1, lr_min=1e-5, lr_max=1):
        super().__init__()
        self.lr = init_lr
        self.loss = init_loss
        self.mul = mul
        self.div = 1/div
        self.lr_min = lr_min
        self.lr_max = lr_max

    def calc_lr(self, loss, epoch):
        # decide of lr change 
        self.lr *= self.mul if loss < self.loss else self.div
        self.lr = max(self.lr_min, min(self.lr, self.lr_max))
        # update loss value
        self.loss = loss
        
    def step(self, optimizer, loss, epoch):
        # calculate lr
        self.calc_lr(loss, epoch)

        # set optimizer's lr
        for p in optimizer.param_groups:
            p['lr'] = self.lr
            # only first lr
            break




