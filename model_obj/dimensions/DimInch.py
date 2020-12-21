from DimLinear import DimLinear
from abc import abstractmethod, ABC
class DimInch(DimLinear):
    def __new__(cls, value):
        if type(value).__bases__[0] is DimLinear:
            value = value.to_inch()
        return DimLinear.__new__(cls, value)

    def to_mm(self):
        return self * 25.4

    def to_inch(self):
        return self

    def _to_dimesionless(self):

        return float(self.data * 25.4)

    def _from_dimesionless(num1):
        x = num1 / 25.4
        return DimInch(x)




