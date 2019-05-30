classdef CrossSectOuterRotorStator < CrossSectBase
    %CrossSectOuterRotorStator Describes the outer rotor stator.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the stator,
    %   with the x-axis directed down the center of one of the stator teeth.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_alpha_st; % span angle of tooth: class type DimAngular
        dim_alpha_so; % angle of tooth edge: class type DimAngular
        dim_r_si;     % inner radius of stator teeth: class type DimLinear
        dim_d_so;     % tooth edge length: class type DimLinear
        dim_d_sp;     % tooth tip length: class type DimLinear
        dim_d_st;     % tooth base length: class type DimLinear
        dim_d_sy;     % back iron thickness: class type DimLinear
        dim_w_st;     % tooth base width: class type DimLinear
        dim_r_st;     % fillet on outer tooth: class type DimLinear
        dim_r_sf;     % fillet between tooth tip and base: class type DimLinear
        dim_r_sb;     % fillet at tooth base: class type DimLinear
        dim_Q;        % number of stator slots (integer)
    end
    
    methods
        function obj = CrossSectOuterRotorStator(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            
            % create local variables of all of the attributes
            % for more readable code
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
            Q = obj.dim_Q;
            
            alpha_total = DimDegree(360/Q).toRadians();
            
            % Inner arc
            x1 = r_si * cos(alpha_total/2);
            y1 = r_si * sin(alpha_total/2);

            % Outer arc on tooth
            r = r_si + d_sy + d_st + d_sp;
            x2 = r * cos(alpha_st/2);
            y2 = r * sin(alpha_st/2);
            
            % Outer wall arc (above tooth [below is mirror])
            r = r_si + d_sy;
            x3 = r * cos(alpha_total/2); % top point
            y3 = r * sin(alpha_total/2); % top point
            
            phi = asin((w_st / 2) / r);
            x4 = r * cos(phi); % lower point (still above x-axis)
            y4 = r * sin(phi); % lower point (still above x-axis)
            
            % Tooth horizontal line outer point
            r = r_si + d_sy + d_st;
            phi = asin((w_st / 2) / r);
            x5 = r * cos(phi); % lower point (still above x-axis)
            y5 = r * sin(phi); % lower point (still above x-axis)
            
            % Left point of d_so line
            theta = alpha_st / 2;
            phi = DimDegree(180).toRadians() - alpha_so + theta;
            L = r_si + d_sy + d_st + d_sp;
            R = d_so;
            x6 = L * cos(theta) + R * cos(phi);
            y6 = L * sin(theta) + R * sin(phi);

            x_arr = [x1,  x1,  x2,  x2,  x3,  x4,  x3,  x4,  x5,  x5,  x6,  x6];
            y_arr = [y1, -y1,  y2, -y2,  y3,  y4, -y3, -y4,  y5, -y5,  y6, -y6];

            for i = 1:Q
                p = obj.location.transformCoords([x_arr',y_arr'], DimRadian((i-1)*alpha_total));

                x = p(:,1);
                y = p(:,2);

                p1 = [x(2), y(2)];
                p2 = [x(1), y(1)];

                p3 = [x(4), y(4)];
                p4 = [x(3), y(3)];

                p5 = [x(6), y(6)];
                p6 = [x(5), y(5)];

                p7 = [x(7), y(7)];
                p8 = [x(8), y(8)];

                p9 = [x(9), y(9)];
                p10 = [x(10), y(10)];

                p11 = [x(11), y(11)];
                p12 = [x(12), y(12)];

                arc1(i) = drawer.drawArc(obj.location.anchor_xy, p1, p2);
                arc2(i) = drawer.drawArc(obj.location.anchor_xy, p3, p4);
                arc3(i) = drawer.drawArc(obj.location.anchor_xy, p5, p6);
                arc4(i) = drawer.drawArc(obj.location.anchor_xy, p7, p8);
                
                seg1(i) = drawer.drawLine(p5, p9);
                seg2(i) = drawer.drawLine(p8, p10);
                seg3(i) = drawer.drawLine(p4, p11);
                seg4(i) = drawer.drawLine(p3, p12);
                seg5(i) = drawer.drawLine(p11, p9);
                seg6(i) = drawer.drawLine(p12, p10);
            end
            
            rad = r_si + (d_sy / 2);
            innerCoord = obj.location.transformCoords([rad, 0]); 
            segments = [arc1, arc2, arc3, arc4, seg1, seg2, seg3, seg4, seg5, seg6];
            csToken = CrossSectToken(innerCoord, segments);
        end
        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. Use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   
            
            %2. Validate the new properties that have been added here
            validateattributes(obj.dim_alpha_st,{'DimAngular'},{'nonnegative', 'nonempty'});
            validateattributes(obj.dim_alpha_so,{'DimAngular'},{'nonempty'});
            validateattributes(obj.dim_r_si,{'DimLinear'},{'nonnegative','nonempty'})  ;          
            validateattributes(obj.dim_d_so,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_d_sp,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_d_st,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_d_sy,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_w_st,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_r_st,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_r_sf,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_r_sb,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_Q,{'double'},{'nonnegative','nonempty','integer'});
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
