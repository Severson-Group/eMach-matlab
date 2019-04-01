classdef CrossSectSolidRect  < CrossSectBase
    %COMPSOLIDRECT Describes a solid rectangle.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the lower left corner of the rectangle.
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_w; %Width of the rectangle: class type dimLinear
        dim_h; %Height of the rectangle: class type dimLinear        
    end
    
  methods
        function obj = CrossSectSolidRect(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            axis = [0,0];
            w=obj.dim_w;
            h=obj.dim_h;
            
%%Create points
            points = [  axis(1),    axis(2); 
                        axis(1),    axis(2)+h; 
                        axis(1)+w,  axis(2)+h; 
                        axis(1)+w,  axis(2)];
        
%%Transform Coordinates
            [points] = obj.location.transformCoords(points);
            
%% Draw Rectangle
            [l_1] = drawer.drawLine(points(1,:),points(2,:));
            [l_2] = drawer.drawLine(points(2,:),points(3,:));
            [l_3] = drawer.drawLine(points(3,:),points(4,:));
            [l_4] = drawer.drawLine(points(4,:),points(1,:));
            
%compute coordinate inside the surface to extrude
            x_coord = w/2;
            y_coord = h/2;
            innerCoord = obj.location.transformCoords([x_coord, y_coord]);             
            segments = [l_1,l_2,l_3,l_4];  
            csToken = CrossSectToken(innerCoord, segments);
            
        end
    end
    
  methods(Access = protected)
     function validateProps(obj)
       %VALIDATE_PROPS Validate the properties of this component
             
       %1. use the superclass method to validate the properties 
        validateProps@CrossSectBase(obj);   
            
        %2. valudate the new properties that have been added here
        validateattributes(obj.dim_w,{'DimLinear'},{'positive','nonempty'});
        validateattributes(obj.dim_h,{'DimLinear'},{'positive','nonempty'});
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

