classdef CrossSectInnerRotorPMRotor < CrossSectBase
    %CrossSectInnerRotorPMRotor Describes the inner rotor PM rotor.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the rotor,
    %   with the x-axis directed along the center of one of the rotor poles
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_alpha_rm; %angular span of the pole: class type DimAngular
        dim_alpha_rp; %pole pitch: class type DimAngular
        dim_r_ri; %inner radius of rotor: class type DimLinear
        dim_r_ro; %outer radius of rotor: class type DimLinear
        dim_d_ri; %rotor iron thickness: class type DimLinear
        dim_d_rm; %magnet thickness: class type DimLinear
        dim_m_r; %iron thickness between magnet segments: class type DimLinear
        dim_l_r; %iron thickness between poles: class type DimLinear
        dim_alpha_ms; %angular width of each magnet segment: class type DimAngular
        num_pole; %number of poles
        num_seg; %number of segments
        
    end
    
    methods
        function obj = CrossSectInnerRotorPMRotor(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            alpha_rm=obj.dim_alpha_rm.toRadians();
            alpha_rp = obj.dim_alpha_rp.toRadians();
            alpha_ms = obj.dim_alpha_ms.toRadians();
            r_ri = obj.dim_r_ri;
            r_ro = obj.dim_r_ro;
            d_ri = obj.dim_d_ri;
            d_rm=obj.dim_d_rm;
            m_r = obj.dim_m_r;
            l_r = obj.dim_l_r;
            p = obj.num_pole;
            s = obj.num_seg;
            
            alpha_ip = alpha_rp-alpha_rm;
            alpha_seg = (alpha_rm-(s-1)*alpha_ms)/(2*s);
            
            if mod(p,2) == 1
                prev_theta_m = -1*alpha_seg;
                prev_theta_ms = 0;
                angle = zeros(1,p);
                    for i=1:p
                        if mod(i,2)==1
                            theta_m= prev_theta_m + 2*alpha_seg;
                            prev_theta_m = theta_m; 
                        else
                            theta_ms = prev_theta_ms + alpha_ms;
                            prev_theta_ms = theta_ms;
                        end
                            angle(i) = prev_theta_m + prev_theta_ms; 
        
                    end
    
            else
                 prev_theta_ms = -0.5*alpha_ms;
                 prev_theta_m = 0;
                 angle = zeros(1,p);
                          for i=1:p
                              if mod(i,2)==0
                                 theta_m= prev_theta_m + 2*alpha_seg;
                                 prev_theta_m = theta_m; 
                               else
                                  theta_ms = prev_theta_ms + alpha_ms;
                                  prev_theta_ms = theta_ms;
                               end
                               angle(i) = prev_theta_m + prev_theta_ms; 
        
                          end
            end
       


        y(1) = (r_ro-d_rm)*sin(angle(1));
        y(2) = (r_ro)*sin(angle(1));
        y(3) = (r_ro-d_rm)*sin(angle(2));
        y(4) = (r_ro)*sin(angle(2));
        y(5) = (r_ro-d_rm)*sin(angle(3));
        y(6) = (r_ro)*sin(angle(3));


        x(1) = (r_ro-d_rm)*cos(angle(1));
        x(2) = (r_ro)*cos(angle(1));
        x(3) = (r_ro-d_rm)*cos(angle(2));
        x(4) = (r_ro)*cos(angle(2));
        x(5) = (r_ro-d_rm)*cos(angle(3));
        x(6) = (r_ro)*cos(angle(3));
        
        for j= 1:s-1
            px(j)=(r_ro-m_r)*cos(angle(j));
            py(j)=(r_ro-m_r)*sin(angle(j));
        end
        j=length(px);
        px(j+1) = (r_ro-l_r)*cos(angle(j+1));
        py(j+1) = (r_ro-l_r)*sin(angle(j+1));
        px(j+2) = (r_ro-l_r)*cos(angle(j+1)+(0.5*alpha_ip));
        py(j+2) = (r_ro-l_r)*sin(angle(j+1)+(0.5*alpha_ip));   
            
        
        x_1 = cat(2,x,px);
        x_array = cat(2,fliplr(x_1),x_1);
        y_1 = cat(2,y,py);
        y_array = cat(2,fliplr(-y_1),y_1);
        x=x_array;
        y=y_array;
         for i = 1:p
          [x,y] = obj.location.transformCoords(x_array,y_array, DimRadian((i-1)*alpha_rp));
            p1 = [x(1),y(1)];
            p2 = [x(2),y(2)];
            p3 = [x(3),y(3)];
            p4 = [x(4), y(4)];
            p5 = [x(5),y(5)];
            p6 = [x(6),y(6)];
            p7 = [x(7),y(7)];
            p8 = [x(8), y(8)];
            p9 = [x(9), y(9)];
            p10 = [x(10), y(10)];
            p11 = [x(11), y(11)];
            p12 = [x(12), y(12)];
            p13 = [x(13), y(13)];
            p14 = [x(14), y(14)];
            p15 = [x(15), y(15)];
            p16 = [x(16), y(16)];
            p17 = [x(17),y(17)]
            p18 = [x(18),y(18)];
            p19 = [x(19),y(19)];
            p20 = [x(20),y(20)];
%       
            arc1 = drawer.drawArc(obj.location.anchor_xy, p1, p2);
            arc2= drawer.drawArc(obj.location.anchor_xy, p3, p4);
            arc8= drawer.drawArc(obj.location.anchor_xy, p5, p7);
            arc9= drawer.drawArc(obj.location.anchor_xy, p6, p8);
            arc19= drawer.drawArc(obj.location.anchor_xy, p10, p11);
            arc29= drawer.drawArc(obj.location.anchor_xy, p9, p12);
            arc9= drawer.drawArc(obj.location.anchor_xy, p13, p15);
            arc9= drawer.drawArc(obj.location.anchor_xy, p14, p16);
            seg1 = drawer.drawLine(p5, p6);
            seg2 = drawer.drawLine(p7, p8);
            seg3 = drawer.drawLine(p9, p10);
            arc3 = drawer.drawArc(obj.location.anchor_xy, p17, p18);
            arc4 = drawer.drawArc(obj.location.anchor_xy, p19, p20);
            seg4 = drawer.drawLine(p11, p12);
            seg5 = drawer.drawLine(p13, p14);
            seg6 = drawer.drawLine(p15, p16);      
%             
%             
         end
         p_inner = [r_ri,0]+obj.location.anchor_xy;
         p_inner2 = [-r_ri,0]+obj.location.anchor_xy;
        
         arc17 = drawer.drawArc(obj.location.anchor_xy, p_inner,p_inner2);
         arc18 = drawer.drawArc(obj.location.anchor_xy, p_inner2,p_inner);
            
    
%             
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
            validateattributes(obj.dim_alpha_rm,{'DimAngular'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha_rp,{'DimAngular'},{'nonempty'})
            validateattributes(obj.dim_r_ro,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_ri,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_ri,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_m_r,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_l_r,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_alpha_ms,{'DimAngular'},{'nonnegative','nonempty'})
            validateattributes(obj.num_seg,{'double'},{'nonnegative','nonempty'})
            validateattributes(obj.num_pole,{'double'},{'nonnegative','nonempty'})
            
            
            
         
            
            
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





