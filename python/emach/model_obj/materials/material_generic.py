
__all__ = ['MaterialGeneric']

class MaterialGeneric():
    
    def __init__(self, name):
        self._name = name
        
    def name(self):
        return self._name
        