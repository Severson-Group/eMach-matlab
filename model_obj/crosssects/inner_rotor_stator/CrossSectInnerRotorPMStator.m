classdef CrossSectInnerRotorPMStator < CrossSectBase
    %CrossSectInnerRotorPMStator Describes the inner rotor PM stator.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the stator,
    %   with the x-axis directed down the center of one of the stator teeth.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_alpha_st; %span angle of tooth: class type DimAngular
        dim_alpha_so; %angle of tooth edge: class type DimAngular
        dim_r_si; %inner radius of stator teeth: class type DimLinear
        dim_d_so; %tooth edge length: class type DimLinear
        dim_d_sp; %tooth tip length: class type DimLinear
        dim_d_st; %tooth base length: class type DimLinear
        dim_d_sy; %back iron thickness: class type DimLinear
        dim_w_st; %tooth base width: class type DimLinear
        dim_r_st; %fillet on outter tooth: class type DimLinear
        dim_r_sf; %fillet between tooth tip and base: class type DimLinear
        dim_r_sb; %fillet at tooth base: class type DimLinear
        stator_slots; %number of stator slots
        
    end
    
    methods
        function obj = CrossSectInnerRotorPMStator(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            %creating local variables of all of the attributes for more
            %readable code
            alpha_st = obj.dim_alpha_st.toRadians();
            alpha_so = obj.dim_alpha_so.toRadians();
            r_si = obj.dim_r_si;
            d_so = obj.dim_d_so;
            d_sp = obj.dim_d_sp;
            d_st = obj.dim_d_st;
            d_sy = obj.dim_d_sy;
            w_st = obj.dim_w_st;
            r_st = obj.dim_r_st;
            r_sf = obj.dim_r_sf;
            r_sb = obj.dim_r_sb;
            slots = obj.stator_slots;
            
            alpha_total = DimDegree(360/slots).toRadians();
            
            x1 = r_si*cos(alpha_st/2);
            beta2 = alpha_st/2 - alpha_so;
            x2 = x1 + d_so*cos( beta2 );
            r3 = r_si + d_sp;
            beta3 = asin((w_st/2)/r3);
            x3 = r3*cos(beta3);
            r4 = r3 + d_st;
            beta4 = asin((w_st/2)/r4);
            x4 = r4*cos(beta4);
            x5 = r4*cos(alpha_total/2);
            x6 = (r4 + d_sy)*cos(alpha_total/2);
            
            y1 = r_si*sin(alpha_st/2);
            y2 = y1 + d_so*sin(beta2);
            y3 = w_st/2;
            y4 = w_st/2;
            y5 = r4*sin(alpha_total/2);
            y6 = (r4 + d_sy)*sin(alpha_total/2);
            
            x = [ x1, x1, x2, x3, x4, x5, x6, x6, x5, x4, x3, x2 ];
            y = [-y1, y1, y2, y3, y4, y5, y6, -y6, -y5, -y4, -y3, -y2];
            
            [x,y] = obj.location.transformCoords(x,y);
            
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
            
            [arc1] = drawer.drawArc(obj.location.anchor_xy, p1, p2);
            [seg1] = drawer.drawLine(p2, p3);
            [seg2] = drawer.drawLine(p3, p4);
            [seg3] = drawer.drawLine(p4, p5);
            [arc2] = drawer.drawArc(obj.location.anchor_xy, p5, p6);
%             [seg4] = drawer.drawLine(p6, p7);
            [arc3] = drawer.drawArc(obj.location.anchor_xy, p8, p7);
%             [seg5] = drawer.drawLine(p8, p9);
            [arc4] = drawer.drawArc(obj.location.anchor_xy, p9, p10);
            [seg6] = drawer.drawLine(p10, p11);
            [seg7] = drawer.drawLine(p11, p12);
            [seg8] = drawer.drawLine(p12, p1);


            %segments = [top_seg, bottom_seg, left_seg, right_seg];
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
            validateattributes(obj.dim_alpha_st,{'DimAngular'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha_so,{'DimAngular'},{'nonempty'})
            validateattributes(obj.dim_r_si,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_d_so,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_sp,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_st,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_sy,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_w_st,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_st,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_sf,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r_sb,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.stator_slots,{'double'},{'nonnegative','nonempty'})
            
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





