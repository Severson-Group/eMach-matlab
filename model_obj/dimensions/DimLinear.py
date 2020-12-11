from DimBase import DimBase
from abc import abstractmethod, ABC

class DimLinear(DimBase,ABC):
    def __new__(cls, value):
        return DimBase.__new__(cls, value)
    def __init__(self, data):
        DimBase.__init__(self, data)

    def __add__(self, other):
        add = self._to_dimes() + other._to_dimes()
        return type(self)._from_dimes(add)

    def __sub__(self, other):
        sub = self._to_dimes() - other._to_dimes()
        return type(self)._from_dimes(sub)


    def __mul__(self, other):
        if (isinstance(self,DimLinear) and isinstance(other,DimLinear)):
            raise Exception ('Multiplication Not valid')


        if((isinstance(self,DimLinear))):
            mul = (other) * (self._to_dimes())
            return type(self)._from_dimes(mul)

    def __rmul__(self, other):
        if (isinstance(self,DimLinear) and isinstance(other,DimLinear)):
            raise Exception ('Multiplication Not valid')

        if((isinstance(self,DimLinear))):
            mul = (other) * (self._to_dimes())
            return type(self)._from_dimes(mul)

    def __neg__(self):
        return self*-1

    def __pos__(self):
        if self<0:
            return self*-1
        else:
            return self






    @abstractmethod
    def to_millimeter(self):
        pass

    @abstractmethod
    def to_inch(self):
        pass

    @abstractmethod
    def to_dimes(self):
        pass

    @abstractmethod
    def from_dimes(var):
        pass