classdef CrossSectNotchedRectangle < CrossSectBase
    %CROSSSECTNOTCHEDRECTANGLE Describes a notched rectangle.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the lower left corner of the rectangle,
    %   with the x-axis directed to the right.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_w;  %Length of rectangle: class type DimLinear
        dim_w_n; %Length of notch: class type DimLinear
        dim_d; %Height of notched part of rectangle: class type DimLinear
        dim_d_n; %Height of notch: class type DimLinear     
    end
    
    methods
        function obj = CrossSectNotchedRectangle(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            
            % notched retangle parameters
            w = obj.dim_w;
            w_n = obj.dim_w_n;
            d = obj.dim_d;
            d_n = obj.dim_d_n;
            
            % x-axis coordinates of notched rectangle points
            x1 = 0;
            x2 = w_n;
            x3 = w - w_n;
            x4 = w;
            
            % y-axis coordinates of notched rectangle points
            y1 = 0;
            y2 = d;
            y3 = d + d_n;
            
            % build x and y coordinates of notched rectangle points as 
            % arrays based on the order how these points are connected
            % between each other
            x = [ x1, x4, x4, x3, x3, x2, x2, x1];
            y = [ y1, y1, y3, y3, y2, y2, y3, y3];      
            
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
            [seg8] = drawer.drawLine(p(8,:), p(1,:));
            
            % calculate xy coordinates of the point inside the notched
            % rectangle
            innerX = obj.dim_w/2;
            innerY = obj.dim_d/2;
            innerCoord = obj.location.transformCoords([innerX, innerY]); 
            
            segments = [seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8];
            csToken = CrossSectToken(innerCoord, segments);
            
        end
        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj); 
            
            %2. valudate the new properties that have been added here        
            validateattributes(obj.dim_w,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_w_n,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_d_n,{'DimLinear'},{'nonnegative','nonempty'})
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
