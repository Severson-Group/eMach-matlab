import numpy as np

from ...dimensions import DimRadian
from ...dimensions.dim_linear import DimLinear
from ...dimensions.dim_angular import DimAngular
from ..cross_sect_base import CrossSectBase, CrossSectToken

__all__ = ['CrossSectInnerRotorStatorCoil']


class CrossSectInnerRotorStatorCoil(CrossSectBase):

    def __init__(self, **kwargs: any) -> None:
        """
        Initialization function for CrossSectInnerRotorStatorCoil class. This function takes in a set of keyword
        arguments and saves the information passed to protected variables.

        Args:
            **kwargs: Keyword arguments provided to the initialization function. The following argument names have to
            be included in order for the code to execute: name, location, dim_r_si, dim_d_sp, dim_d_st, dim_w_st,
            dim_r_st, dim_r_sf, dim_r_sb, Q, num_of_layers, layer, slot.

        Raises:
            TypeError: If type of arguments passed is incorrect.
        """
        self._create_attr(kwargs)

        super()._validate_attr()
        self._validate_attr()

    @property
    def dim_r_si(self):
        return self._dim_r_si

    @property
    def dim_d_sp(self):
        return self._dim_d_sp

    @property
    def dim_d_st(self):
        return self._dim_d_st

    @property
    def dim_w_st(self):
        return self._dim_w_st

    @property
    def dim_r_st(self):
        return self._dim_r_st

    @property
    def dim_r_sf(self):
        return self._dim_r_sf

    @property
    def dim_r_sb(self):
        return self._dim_r_sb

    @property
    def Q(self):
        return self._Q

    @property
    def num_of_layers(self):
        return self._num_of_layers

    @property
    def layer(self):
        return self._layer

    @property
    def slot(self):
        return self._slot

    def draw(self, drawer):
        r_si = self.dim_r_si
        d_sp = self.dim_d_sp
        d_st = self.dim_d_st
        w_st = self.dim_w_st
        r_st = self.dim_r_st
        r_sf = self.dim_r_sf
        r_sb = self.dim_r_sb
        Q = self.Q
        num_of_layers = self.num_of_layers
        layer = self.layer
        slot = self.slot

        alpha_total = DimRadian(2 * np.pi / Q)

        r1 = r_si + d_sp + d_st * layer/num_of_layers
        beta3 = np.arcsin((w_st / 2) / r1)
        x1 = r1 * np.cos(beta3)
        r2 = r1 + d_st/2
        beta4 = np.arcsin((w_st / 2) / r2)
        x2 = r2 * np.cos(beta4)
        y1 = w_st / 2
        y2 = w_st / 2

        x3 = x2 * np.cos(alpha_total * -1) + y2 * -1 * np.sin(alpha_total * -1)
        y3 = x2 * -1 * np.sin(alpha_total * -1) + y2 * -1 * np.cos(alpha_total * -1)

        x4 = x1 * np.cos(alpha_total * -1) + y1 * -1 * np.sin(alpha_total * -1)
        y4 = x1 * -1 * np.sin(alpha_total * -1) + y1 * -1 * np.cos(alpha_total * -1)

        x_arr = [x1, x2, x3, x4, x4]
        y_arr = [y1, y2, y3, y4, y4]

        arc1 = []
        arc2 = []
        seg1 = []
        seg2 = []

        # transpose list
        coords = [x_arr, y_arr]
        coords = list(zip(*coords))
        coords = [list(sublist) for sublist in coords]

        p = self.location.transform_coords(coords, alpha_total * (slot-1))
        seg1.append(drawer.draw_line(p[0], p[1]))
        arc1.append(drawer.draw_arc(self.location.anchor_xy, p[1], p[2]))
        seg2.append(drawer.draw_line(p[2], p[3]))
        arc2.append(drawer.draw_arc(self.location.anchor_xy, p[0], p[3]))

        rad = (r1 + r2) / 2
        inner_coord = self.location.transform_coords([[rad, type(rad)(0)]], alpha_total*(slot-1) + alpha_total/2)
        segments = [seg1, arc1, seg2, arc2]
        segs = [x for segment in segments for x in segment]
        cs_token = CrossSectToken(inner_coord[0], segs)
        return cs_token

    def _validate_attr(self):

        if isinstance(self._dim_r_si, DimLinear):
            pass
        else:
            raise TypeError("dim_r_si not of type DimLinear")

        if isinstance(self._dim_d_sp, DimLinear):
            pass
        else:
            raise TypeError("dim_d_sp not of type DimLinear")

        if isinstance(self._dim_d_st, DimLinear):
            pass
        else:
            raise TypeError("dim_d_st not of type DimLinear")

        if isinstance(self._dim_w_st, DimLinear):
            pass
        else:
            raise TypeError("dim_w_st not of type DimLinear")

        if isinstance(self._dim_r_sf, DimLinear):
            pass
        else:
            raise TypeError("dim_r_sf not of type DimLinear")

        if isinstance(self._dim_r_st, DimLinear):
            pass
        else:
            raise TypeError("dim_r_st not of type DimLinear")

        if isinstance(self._dim_r_sb, DimLinear):
            pass
        else:
            raise TypeError("dim_r_sb not of type DimLinear")

        if isinstance(self._Q, int):
            pass
        else:
            raise TypeError("Q not of type int")
