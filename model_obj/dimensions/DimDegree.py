from DimAngular import DimAngular


class DimDegree(DimAngular):
    def __new__(cls, value):
        if type(value).__bases__[0] is DimAngular:
            value = value.to_degrees()
        return DimAngular.__new__(cls, value)

    def to_degrees(self):
        return self

    def to_radians(self):
        return self*3.14/180


    # def _to_dimes(self):
    #     return float(self)
    #
    # def _from_dimes(num1):
    #     x = num1
    #     return DimDegree(x)

        