
import numpy as np

from ...dimensions import DimRadian
from ...dimensions.dim_linear import DimLinear
from ...dimensions.dim_angular import DimAngular
from ..cross_sect_base import CrossSectBase, CrossSectToken

__all__ = ['CrossSectInnerRotorStator']
class CrossSectInnerRotorStator(CrossSectBase):
    
    def __init__(self, **kwargs: any) -> None: 
        '''
        Intialization function for HollowCylinder class. This function takes in
        arguments and saves the information passed to private variable to make
        them read-only
        Parameters
        ----------
        **kwargs : any
            DESCRIPTION. Keyword arguments provided to the initialization funcntion.
            The following argument names have to be included in order for the code
            to execute: name, dim_t, dim_r_o, location. 
            
        Returns
        -------
        None
        '''
        self._create_attr(kwargs)  
        
        super()._validate_attr()
        self._validate_attr()
    
    @property
    def dim_alpha_st(self):
        return self._dim_alpha_st
    
    @property
    def dim_alpha_so(self):
        return self._dim_alpha_so
    
    @property
    def dim_r_si(self):
        return self._dim_r_si
    
    @property
    def dim_d_so(self):
        return self._dim_d_so
    
    @property
    def dim_d_sp(self):
        return self._dim_d_sp
    
    @property
    def dim_d_st(self):
        return self._dim_d_st
    
    @property
    def dim_d_sy(self):
        return self._dim_d_sy
    
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

    
    def draw(self, drawer):

        alpha_st = DimRadian(self.dim_alpha_st)
        alpha_so = DimRadian(self.dim_alpha_so)
        r_si = self.dim_r_si
        d_so = self.dim_d_so
        d_sp = self.dim_d_sp
        d_st = self.dim_d_st
        d_sy = self.dim_d_sy
        w_st = self.dim_w_st
        r_st = self.dim_r_st
        r_sf = self.dim_r_sf
        r_sb = self.dim_r_sb
        Q = self.Q
        
        alpha_total = DimRadian(2*np.pi/Q)
        
        x1 = r_si*np.cos(alpha_st/2)
        beta2 = alpha_st/2 - alpha_so
        x2 = x1 + d_so*np.cos( beta2 )
        r3 = r_si + d_sp
        beta3 = np.arcsin((w_st/2)/r3)
        x3 = r3*np.cos(beta3)
        r4 = r3 + d_st
        beta4 = np.arcsin((w_st/2)/r4)
        x4 = r4*np.cos(beta4)
        x5 = r4*np.cos(alpha_total/2)
        x6 = (r4 + d_sy)*np.cos(alpha_total/2)
        
        y1 = r_si*np.sin(alpha_st/2)
        y2 = y1 + d_so*np.sin(beta2)
        y3 = w_st/2
        y4 = w_st/2
        y5 = r4*np.sin(alpha_total/2)
        y6 = (r4 + d_sy)*np.sin(alpha_total/2)
        
        x_arr = [ x1, x1, x2, x3, x4, x5, x6, x6, x5, x4, x3, x2 ]
        y_arr = [-y1, y1, y2, y3, y4, y5, y6, -y6, -y5, -y4, -y3, -y2]
        
        arc1 = []
        arc2 = []
        arc3 = []
        arc4 = []
        seg1 = []
        seg2 = []
        seg3 = []
        seg4 = []
        seg5 = []
        seg6 = []
        
        z = np.array([x_arr, y_arr])
        
        coords = np.transpose(z)# convert coordinates to a form of [[x1,y1]..]
        
        for i in range(0,Q):
          
            p = self.location.transform_coords(coords, alpha_total*i)
            
            x = p[:,0]
            y = p[:,1]
        
            p1 = [x[0], y[0]]
            p2 = [x[1], y[1]]
            p3 = [x[2], y[2]]
            p4 = [x[3], y[3]]
            p5 = [x[4], y[4]]
            p6 = [x[5], y[5]]
            p7 = [x[6], y[6]]
            p8 = [x[7], y[7]]
            p9 = [x[8], y[8]]
            p10 = [x[9], y[9]]
            p11 = [x[10], y[10]]
            p12 = [x[11], y[11]]

            arc1.append(drawer.draw_arc(self.location.anchor_xy, p1, p2))
            seg1.append(drawer.draw_line(p2, p3))
            seg2.append(drawer.draw_line(p3, p4))
            seg3.append(drawer.draw_line(p4, p5))
            arc2.append(drawer.draw_arc(self.location.anchor_xy, p5, p6))
            arc3.append(drawer.draw_arc(self.location.anchor_xy, p8, p7))
            arc4.append(drawer.draw_arc(self.location.anchor_xy, p9, p10))
            seg4.append(drawer.draw_line(p10, p11))
            seg5.append(drawer.draw_line(p11, p12))
            seg6.append(drawer.draw_line(p12, p1))
        
        rad = (x3 + x4)/2
        inner_coord = self.location.transform_coords(np.array([[rad, 0]]))
        segments = [arc1, seg1, seg2, seg3, arc2, arc3, arc4, seg4, seg5, seg6]
        cs_token = CrossSectToken(inner_coord[0,:], segments)
        return cs_token
        
    def _validate_attr(self):
        
        if isinstance(self._dim_alpha_st, DimAngular):
            pass
        else:
            raise TypeError("dim_alpha_st not of type DimAngular")
            
        if isinstance(self._dim_alpha_so, DimAngular):
            pass
        else:
            raise TypeError("dim_alpha_so not of type DimAngular")  
        
        if isinstance(self._dim_r_si, DimLinear):
            pass
        else:
            raise TypeError("dim_r_si not of type DimLinear") 
            
        if isinstance(self._dim_d_so, DimLinear):
            pass
        else:
            raise TypeError("dim_d_so not of type DimLinear") 
        
        if isinstance(self._dim_d_sp, DimLinear):
            pass
        else:
            raise TypeError("dim_d_sp not of type DimLinear") 
            
        if isinstance(self._dim_d_st, DimLinear):
            pass
        else:
            raise TypeError("dim_d_st not of type DimLinear") 
            
        if isinstance(self._dim_d_sy, DimLinear):
            pass
        else:
            raise TypeError("dim_d_sy not of type DimLinear") 
            
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
            
            
        
            
            
            
            
