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
            
            %points with no fillets
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
            
            %calculating with addition of fillets
%             gamma = atan(abs((y3-y2)/(x3-x2)));
%             xf2_c = x3 + r_sf*(sin(gamma) - ((1-cos(gamma))/tan(gamma)));
%             yf2_c = y3 + r_sf;
%             xf2 = x3 - r_sf*(1-cos(gamma))/tan(gamma);
%             yf2 = y3 + r_sf*(1-cos(gamma));
%             
%             vf1_1 = [x1-x2; y1-y2];
%             vf1_2 = [x3-x2; y3-y2];
%             rf1_1 = r_st*[-vf1_1(2); vf1_1(1)]/norm(vf1_1);
%             rf1_2 = r_st*[-vf1_2(2); vf1_2(1)]/norm(vf1_2);
%             A = [vf1_1, -vf1_2];
%             tf1 = A\-(rf1_2+rf1_1);
%                         
%             vf2_1 = -vf1_2;
%             vf2_2 = [x4-x3, y4-y3];
%             rf2_1 = r_sf*[-vf2_1(2); vf2_1(1)]/norm(vf1_1);
%             rf2_2 = r_sf*[-vf2_2(2); vf2_2(1)]/norm(vf1_2);
%             A = [vf1_1, -vf1_2];
%             tf2 = A\-(rf2_2+rf2_1);
%             
%             f2_start = [x4;y4] + tf2(1)*vf2_1;
% %             f2_end = 
%             
%             
%             
%           
%             x_f2_arr = [xf2, xf2_c, xf2_c, xf2, xf2_c, xf2_c];
%             y_f2_arr = [yf2, yf2_c, y3, -yf2, -yf2_c, -y3];
            
            x_arr = [ x1, x1, x2, x3, x4, x5, x6, x6, x5, x4, x3, x2 ];
            y_arr = [-y1, y1, y2, y3, y4, y5, y6, -y6, -y5, -y4, -y3, -y2];
            
            for i = 1:slots
              
            [x,y] = obj.location.transformCoords(x_arr,y_arr, DimRadian((i-1)*alpha_total));
%             [x_f2, y_f2] = obj.location.transformCoords(x_f2_arr, y_f2_arr, DimRadian((i-1)*alpha_total));
            
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
                
                [f1_t_start, f1_t_stop, f1_t_center, f1_t_t] = obj.filletLineLine(p2, p3, p4, obj.dim_r_st);
                [f1_b_start, f1_b_stop, f1_b_center, f1_b_t] = obj.filletLineLine(p11, p12, p1, obj.dim_r_st);
                [f2_t_start, f2_t_stop, f2_t_center, f2_t_t] = obj.filletLineLine(p3, p4, p5, obj.dim_r_sf);
                [f2_b_start, f2_b_stop, f2_b_center, f2_b_t] = obj.filletLineLine(p10, p11, p12, obj.dim_r_sf);
                

                arc1(i) = drawer.drawArc(obj.location.anchor_xy, p1, p2);
                seg1(i) = drawer.drawLine(p2, f1_t_stop);
                f1_top(i) = drawer.drawArc(f1_t_center, f1_t_start, f1_t_stop);
                seg2(i) = drawer.drawLine(f1_t_start, f2_t_start);
                f2_top(i) = drawer.drawArc(f2_t_center, f2_t_start, f2_t_stop);
                seg3(i) = drawer.drawLine(f2_t_stop, p5);
                arc2(i) = drawer.drawArc(obj.location.anchor_xy, p5, p6);
                arc3(i) = drawer.drawArc(obj.location.anchor_xy, p8, p7);
                arc4(i) = drawer.drawArc(obj.location.anchor_xy, p9, p10);
                seg4(i) = drawer.drawLine(p10, f2_b_start);
                f2_b(i) = drawer.drawArc(f2_b_center, f2_b_start, f2_b_stop);
                seg5(i) = drawer.drawLine(f2_b_stop, f1_b_stop);
                f1_top(i) = drawer.drawArc(f1_b_center, f1_b_start, f1_b_stop);
                seg6(i) = drawer.drawLine(f1_b_start, p1);
            
            end


            %segments = [top_seg, bottom_seg, left_seg, right_seg];
        end
        
        function [start, stop, center, t] = filletLineLine(obj, p1, p2, p3, r)
            
            validateattributes(p1, {'numeric'}, {'numel',2});
            validateattributes(p2, {'numeric'}, {'numel',2});
            validateattributes(p3, {'numeric'}, {'numel',2});
            validateattributes(r, {'DimLinear'}, {'nonempty'})
       
            original_p1_dim = size(p1); 
            original_p2_dim = size(p2);
            original_p3_dim = size(p3);
            
            p1 = reshape(p1, 2,1); 
            p2 = reshape(p2, 2,1);
            p3 = reshape(p3, 2,1);
            
            v1 = p1-p2;
            v2 = p3-p2;
            r1 = r*[-v1(2); v1(1)]/norm(v1);
            r2 = r*[-v2(2); v2(1)]/norm(v2);
            
            if r1'*v2<0
                r1 = -1*r1;
            end
            if r2'*v1 <0
                r2 = -1*r2;
            end
            
            A = [v1, -v2];
            t = A\(r2 - r1);
            
            %checking to see which way the arc must be drawn
            alpha1 = mod(rad2deg( atan2(v1(2),v1(1)) ) + 720, 360);
            alpha2 = mod(rad2deg( atan2(v2(2),v2(1)) ) + 720, 360);
            delta = alpha1 - alpha2;
            if delta > 0 && delta <180 || delta <-180
                start = p2 + t(1)*v1;
                stop  = p2 + t(2)*v2;
            else
                start = p2 + t(2)*v2;
                stop  = p2 + t(1)*v1;
            end
                
            center = p2 + t(1)*v1 + r1; 
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





