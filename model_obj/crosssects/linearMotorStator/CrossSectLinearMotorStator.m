classdef CrossSectLinearMotorStator < CrossSectBase
    %CROSSSECTLINEARMOTORSTATOR Describes linear motor stator.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the lower right point of the motor,
    %   with the x-axis directed to the top.
    
    
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
    end
    
    methods
        function obj = CrossSectLinearMotorStator(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            
            % linear motor stator parameters
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
            
            % x-axis coordinates of stator points
            x1 = r_si;
            x2 = r_si + d_so;
            x3 = r_si + d_sp;
            x4 = r_so - d_sy;
            x5 = r_so;
            
            % y-axis coordinates of stator points
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
            
            % build x and y coordinates of stator points as arrays based on
            % the order how these points are connected between each other
            x = [ x1, x5, x5,  x1,  x1, x2, x3, x4, x4, x3, x2, x1...
                  x1, x2, x3, x4, x4, x3, x2, x1];
            y = [ y1, y1, y10, y10, y8, y8, y9, y9, y6, y6, y7, y7...
                  y4, y4, y5, y5, y2, y2, y3, y3];
            
            % p contains transformed xy coordinates of all points   
            [p] = obj.location.transformCoords([x' y']);  
      
            % add lines between particular points
            [seg1] = drawer.drawLine(p(1,:), p(2,:));
            [seg2] = drawer.drawLine(p(2,:), p(3,:));
            [seg3] = drawer.drawLine(p(3,:), p(4,:));
            [seg4] = drawer.drawLine(p(4,:), p(5,:));
            [seg5] = drawer.drawLine(p(5,:), p(6,:));
            [seg6] = drawer.drawLine(p(6,:), p(7,:));
            [seg7] = drawer.drawLine(p(7,:), p(8,:));
            [seg8] = drawer.drawLine(p(8,:), p(9,:));
            [seg9] = drawer.drawLine(p(9,:), p(10,:));
            [seg10] = drawer.drawLine(p(10,:), p(11,:));
            [seg11] = drawer.drawLine(p(11,:), p(12,:));
            [seg12] = drawer.drawLine(p(12,:), p(13,:));
            [seg13] = drawer.drawLine(p(13,:), p(14,:));
            [seg14] = drawer.drawLine(p(14,:), p(15,:));
            [seg15] = drawer.drawLine(p(15,:), p(16,:));
            [seg16] = drawer.drawLine(p(16,:), p(17,:));
            [seg17] = drawer.drawLine(p(17,:), p(18,:));
            [seg18] = drawer.drawLine(p(18,:), p(19,:));
            [seg19] = drawer.drawLine(p(19,:), p(20,:));
            [seg20] = drawer.drawLine(p(20,:), p(1,:));
            
            % calculate xy coordinates of the point inside the stator which
            % is the center of the central stator teeth 
            innerX = x3;
            innerY = (y5 + y6)/2;
            innerCoord = obj.location.transformCoords([innerX, innerY]);            
            
            segments = [seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,...
                seg9, seg10, seg11, seg12, seg13, seg14, seg15, seg16,...
                seg17, seg18, seg19, seg20];
            csToken = CrossSectToken(innerCoord, segments);
      
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
