classdef CrossSectLinearMotorStator < CrossSectBase
    %CROSSSECTHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle,
    %   with the x-axis directed down the center of one of the stator teeth.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_w_s;  %stator length: class type DimLinear
        dim_w_st; %stator tooth width: class type DimLinear
        dim_w_so; %stator slot opening: class type DimLinear
        dim_r_so; %stator outer radius: class type DimLinear
        dim_r_si; %stator inner radius: class type DimLinear
        dim_d_so; %tooth edge length: class type DimLinear
        dim_d_sp; %tooth tip length: class type DimLinear
        dim_d_sy; %back iron thickness: class type DimLinear
        dim_r_st; %fillet on outer tooth: class type DimLinear
        dim_r_sf; %fillet between tooth tip and base: class type DimLinear
        dim_r_sb; %fillet at tooth base: class type DimLinear
        dim_Q;    %number of stator slots       
    end
    
    methods
        function obj = CrossSectLinearMotorStator(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
        w_s = obj.dim_w_s;
        w_st = obj.dim_w_st;
        w_so = obj.dim_w_so;
        r_so = obj.dim_r_so;
        r_si = obj.dim_r_si;
        d_so = obj.dim_d_so;
        d_sp = obj.dim_d_sp;
        d_sy = obj.dim_d_sy;
        r_st = obj.dim_r_st;
        r_sf = obj.dim_r_sf;
        r_sb = obj.dim_r_sb;
        Q = obj.dim_Q;   
        
        x1 = r_si;
        x2 = r_si + d_so;
        x3 = r_si + d_sp;
        x4 = r_so - d_sy;
        x5 = r_so;
        
        y1 = 0;
        y2 = w_st/2;
        y3 = (w_s-2*w_so)/4;
        y4 = y3+w_so;
        y5 = y4+y3-y2;
        y6 = y5+w_st;
        y7 = y6+y3-y2;
        y8 = y7+w_so;
        y9 = y8+y3-y2;
        y10 = y9+w_st/2;
            
        x = [ x1, x5, x5,  x1,  x1, x2, x3, x4, x4, x3, x2, x1...
              x1, x2, x3, x4, x4, x3, x2, x1];
        y = [ y1, y1, y10, y10, y8, y8, y9, y9, y6, y6, y7, y7...
              y4, y4, y5, y5, y2, y2, y3, y3];
        
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
        p13 = [x(13), y(13)];
        p14 = [x(14), y(14)];
        p15 = [x(15), y(15)];
        p16 = [x(16), y(16)];
        p17 = [x(17), y(17)];
        p18 = [x(18), y(18)];
        p19 = [x(19), y(19)];
        p20 = [x(20), y(20)];
        
        [seg1] = drawer.drawLine(p1, p2);
        [seg2] = drawer.drawLine(p2, p3);
        [seg3] = drawer.drawLine(p3, p4);
        [seg4] = drawer.drawLine(p4, p5);
        [seg5] = drawer.drawLine(p5, p6);
        [seg6] = drawer.drawLine(p6, p7);
        [seg7] = drawer.drawLine(p7, p8);
        [seg8] = drawer.drawLine(p8, p9);
        [seg9] = drawer.drawLine(p9, p10);
        [seg10] = drawer.drawLine(p10, p11);
        [seg11] = drawer.drawLine(p11, p12);
        [seg12] = drawer.drawLine(p12, p13);
        [seg13] = drawer.drawLine(p13, p14);
        [seg14] = drawer.drawLine(p14, p15);
        [seg15] = drawer.drawLine(p15, p16);
        [seg16] = drawer.drawLine(p16, p17);
        [seg17] = drawer.drawLine(p17, p18);
        [seg18] = drawer.drawLine(p18, p19);
        [seg19] = drawer.drawLine(p19, p20);
        [seg20] = drawer.drawLine(p20, p1);
      
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
            validateattributes(obj.dim_w_s,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w_st,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_w_so,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_so,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_si,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_so,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_sp,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_sy,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_st,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_sf,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_sb,{'DimLinear'},{'nonnegative','nonempty'})
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
