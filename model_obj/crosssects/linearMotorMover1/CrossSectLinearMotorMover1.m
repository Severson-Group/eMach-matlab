classdef CrossSectLinearMotorMover1 < CrossSectBase
    %CROSSSECTHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle,
    %   with the x-axis directed down the center of one of the stator teeth.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_r_si;  %stator inner radius: class type DimLinear
        dim_w_r;  %mover length: class type DimLinear
        dim_w_ra; %axial magnet length: class type DimLinear
        dim_w_rr; %radial magnet length: class type DimLinear
        dim_r_ri; %mover inner radius: class type DimLinear
        dim_d_rm; %magnet thickness: class type DimLinear
        dim_g;    %air gap: class type DimLinear
        dim_Q;    %number of duplicates       
    end
    
    methods
        function obj = CrossSectLinearMotorMover1(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
        
        r_si = obj.dim_r_si;
        w_r = obj.dim_w_r;
        w_ra = obj.dim_w_ra;
        w_rr = obj.dim_w_rr;
        r_ri = obj.dim_r_ri;
        d_rm = obj.dim_d_rm;
        g = obj.dim_g;
        Q = obj.dim_Q;   
        
        d_ri = r_si - g - r_ri - d_rm;
        w_rs = (w_r - w_ra - 2*w_rr)/2;
        
        x1 = r_ri;
        x2 = r_ri + d_ri;
        x3 = r_ri + d_ri + d_rm;
        
        y1 = 0;
        y2 = w_rs;
        y3 = w_rs + w_rr;
        y4 = w_rs + w_rr + w_ra;
        y5 = w_r - w_rs;
        y6 = w_r;
            
        x = [ x1, x2, x2, x1, x2, x3, x2, x3, x2, x3, x2, x3];
        y = [ y1, y1, y6, y6, y2, y2, y3, y3, y4, y4, y5, y5];
        
        p1 = [x(1), y(1)];
        p2 = [x(2), y(2)];
        p3 = [x(3), y(3)];
        p4 = [x(4), y(4)];
        p5 = [x(5), y(5)];
        p6 = [x(6), y(6)];
        p7 = [x(7), y(7)];
        p8 = [x(8), y(8)];
        p9 = [x(9), y(9)];
        p10 = [x(10), y(10)];
        p11 = [x(11), y(11)];
        p12 = [x(12), y(12)];
        
        [seg1] = drawer.drawLine(p1, p2);
        [seg2] = drawer.drawLine(p2, p3);
        [seg3] = drawer.drawLine(p3, p4);
        [seg4] = drawer.drawLine(p4, p1);        
        [seg5] = drawer.drawLine(p5, p6);
        [seg6] = drawer.drawLine(p7, p8);
        [seg7] = drawer.drawLine(p9, p10);
        [seg8] = drawer.drawLine(p11, p12);
        [seg9] = drawer.drawLine(p6, p8);
        [seg10] = drawer.drawLine(p8, p10);
        [seg11] = drawer.drawLine(p10, p12);
      
        end
        
        function select(obj)
            
        end
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj); 
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_r_si,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w_r,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_w_ra,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_ri,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_rm,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_g,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_Q,{'uint8'},{'nonnegative','nonempty'})
         end
                  
         function obj = createProps(obj, len, args)
             %CREATE_PROPS Add support for value pair constructor
             
             validateattributes(len, {'numeric'}, {'even'});
             for i = 1:2:len 
                 obj.(args{i}) = args{i+1};
             end
         end
     end
end
