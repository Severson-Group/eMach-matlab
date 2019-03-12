classdef CrossSectInnerRotorPMRotor < CrossSectBase
    %CrossSectInnerRotorPMRotor Describes the inner rotor PM rotor.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the rotor,
    %   with the x-axis directed along the center of one of the rotor poles
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_alpha_rm; %angular span of the pole: class type DimAngular
        dim_alpha_rp; %pole pitch: class type DimAngular
        dim_alpha_rs; %segment span: class type DimAngular
        dim_r_ri; %inner radius of rotor: class type DimLinear
        dim_d_ri; %rotor iron thickness: class type DimLinear
        dim_d_rp; %interpolar iron thickness: class type DimLinear
        dim_d_rs; %inter segment iron thickness: class type DimLinear
        num_pole; %number of poles
        num_seg; %number of segments  
        dim_t_i; %inner thickness: class type DimLinear
    end
    
    methods
        function obj = CrossSectInnerRotorPMRotor(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            alpha_rm=obj.dim_alpha_rm.toRadians();
            alpha_rp = obj.dim_alpha_rp.toRadians();
            alpha_rs = obj.dim_alpha_rs.toRadians();
            r_ri = obj.dim_r_ri;
            d_ri = obj.dim_d_ri;
            d_rp = obj.dim_d_rp;
            d_rs=obj.dim_d_rs;
            p = obj.num_pole;
            s = obj.num_seg;                              
            alpha_k = (alpha_rm-s*(alpha_rs))/(s-1);
             
%%Compute angles of various rotor segment start and end points           
            if mod(s,2) == 1
                prev_theta_m = -alpha_rs/2;
                prev_theta_ms = 0;
                angle = zeros(1,s+1);
                    for i=1:s+1
                        if mod(i,2)==1
                            theta_m= prev_theta_m + alpha_rs;
                            prev_theta_m = theta_m; 
                        else
                            theta_ms = prev_theta_ms + alpha_k;
                            prev_theta_ms = theta_ms;
                        end
                            angle(i) = prev_theta_m + prev_theta_ms; 
        
                    end
    
            else
                 prev_theta_ms = -0.5*alpha_k;
                 prev_theta_m = 0;
                 angle = zeros(1,s+1);
                          for i=1:s+1
                              if mod(i,2)==0
                                 theta_m= prev_theta_m + alpha_rs;
                                 prev_theta_m = theta_m; 
                               else
                                  theta_ms = prev_theta_ms + alpha_k;
                                  prev_theta_ms = theta_ms;
                               end
                              angle(i) = prev_theta_m + prev_theta_ms; 
                          end
            end
            
%%Assign angle for the end point of the interpolar segment            
            angle(end)=angle(end-1)+(alpha_rp-alpha_rm);
            
%Generate coordinates based on the points angles            
            for i=1:s+1
                if (i<=s-1)
                    a(i) = r_ri+d_ri+d_rs;
                else
                    a(i) = r_ri+d_ri+d_rp;
                end
                    y(i) = a(i)*sin(angle(i));
                    x(i) = a(i)*cos(angle(i));
                    zx(i) = (r_ri+d_ri)*cos((angle(i)));
                    zy(i) = (r_ri + d_ri)*sin((angle(i)));
            end
    
%%Reshape the coordinates for drawing    
            x_array = cat(2,fliplr(x(1:end-1)),x);
            y_array = cat(2,fliplr(-y(1:end-1)),y);
            zx_array = cat(2,fliplr(zx(1:end-1)),zx);
            zy_array = cat(2,fliplr(-zy(1:end-1)),zy);
        
            for l=1:length(x_array)
                points(l,1)=x_array(l);
                points(l,2)=y_array(l);
                inner_points(l,1)=zx_array(l);
                inner_points(l,2)=zy_array(l);
            end
            
%%Draw p poles with s segments per pole            
            for i = 1:p
                [points] = obj.location.transformCoords(points, DimRadian(2*pi/p));
                [inner_points]=obj.location.transformCoords(inner_points, DimRadian(2*pi/p));
                for j=1:2*s+1
                    if mod(j,2)==0
                     arc_c(j) = drawer.drawArc(obj.location.anchor_xy, points(j,:),...
                                points(j+1,:));
                      lines(j)= drawer.drawLine(points(j,:), inner_points(j,:)); 
                     end
                    if (mod(j,2)==1 && j<(2*s+1))
                        arc(j) = drawer.drawArc(obj.location.anchor_xy,inner_points(j,:),...
                                inner_points(j+1,:));
                        lines(j)= drawer.drawLine(points(j,:), inner_points(j,:));    
                       
                end           
                end
            end
%%Draw inner surface          
         point_i = [r_ri,0]+obj.location.anchor_xy;
         point_i2 = [-r_ri,0]+obj.location.anchor_xy;
         point_i3 = [r_ri-obj.dim_t_i,0]+obj.location.anchor_xy;
         point_i4 = [-(r_ri-obj.dim_t_i),0]+obj.location.anchor_xy;
         arc_i1 = drawer.drawArc(obj.location.anchor_xy, point_i,point_i2);
         arc_i2 = drawer.drawArc(obj.location.anchor_xy, point_i2,point_i);
         arc_i3 = drawer.drawArc(obj.location.anchor_xy, point_i3,point_i4);
         arc_i4 = drawer.drawArc(obj.location.anchor_xy, point_i4,point_i3);
         rad = r_ri+d_ri;
         innerCoord = obj.location.transformCoords([rad, 0]);
         segments = [arc_c,arc_i1,arc_i2,arc_i3,arc_i4];
         csToken = CrossSectToken(innerCoord, segments);
                     
        end
        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   
            
            %2. validate the new properties that have been added here
             validateattributes(obj.dim_alpha_rm,{'DimAngular'},{'nonnegative', 'nonempty'});
             validateattributes(obj.dim_alpha_rp,{'DimAngular'},{'nonempty'});
             validateattributes(obj.dim_alpha_rs,{'DimAngular'},{'nonempty'}); 
             validateattributes(obj.dim_r_ri,{'DimLinear'},{'nonnegative','nonempty'});
             validateattributes(obj.dim_t_i,{'DimLinear'},{'nonnegative','nonempty'});
             validateattributes(obj.dim_d_ri,{'DimLinear'},{'nonnegative','nonempty'});
             validateattributes(obj.dim_d_rp,{'DimLinear'},{'nonnegative','nonempty'});
             validateattributes(obj.dim_d_rs,{'DimLinear'},{'nonnegative','nonempty'});
             validateattributes(obj.num_seg,{'double'},{'nonnegative','nonempty'});
             validateattributes(obj.num_pole,{'double'},{'nonnegative','nonempty'});
            
            
            
         
            
            
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





