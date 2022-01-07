import torch
from TRAIN.networks import PWConv2d, DWConv2d


"""
external_signals = {
                    'in':{
                        'sig_name':WIDTH,
                        },
                    'out':{
                        'sig_name':WIDTH,
                        },
                    }
"""


modules_names = []
signals_names = []


class GenBlk:
    
    def external_signals(self)->dict:
        ...
    
    def generate(self) -> str:
        ...
    

class LayerBlock(GenBlk):
    
    def __init__(self, in_shape, out_shape) -> None:
        super().__init__()
        self.in_shape = in_shape
        self.out_shape = out_shape


class PWBlock(LayerBlock):

    def __init__(self, input_tensor, m:PWConv2d) -> None:
        self.config = self.extract_config(input_tensor, m)
        self.name:str = None
        
    def extract_config(self,input_tensor, m:PWConv2d):
        return {}
    
    def external_signals(self):
        return {}
    
    def generate(self) -> str:
        return ''
        
    
class DWBlock(LayerBlock):

    def __init__(self, input_tensor, m:DWConv2d) -> None:
        self.config = self.extract_config(input_tensor, m)
        self.name:str = None
        
    def extract_config(self,input_tensor, m:DWConv2d):
        return {}
        
    def external_signals(self):
        return {}
    
    def generate(self) -> str:
        return ''


class SharedMemoryBlocks(GenBlk):
    
    def __init__(self, layers:list(LayerBlock)) -> None:
        self.name = None
        self.config = {}
        
    def extract_config(self,):
        return {}
    
    def external_signals(self):
        return {}
        
    def generate(self) -> str:
        return ''


class LastBlock(GenBlk):

    def __init__(self, layer:LayerBlock) -> None:
        self.name = None
        self.config = {}
        
    def extract_config(self,):
        return {}
    
    def external_signals(self):
        return {}
        
    def generate(self) -> str:
        return ''


class FirstBlock(GenBlk):

    def __init__(self, layer:LayerBlock) -> None:
        self.name = None
        self.config = {}
        
    def extract_config(self,):
        return {}
    
    def external_signals(self):
        return {}
        
    def generate(self) -> str:
        return ''

    