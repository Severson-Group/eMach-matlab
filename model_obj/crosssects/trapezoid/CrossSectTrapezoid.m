classdef CrossSectTrapezoid < CrossSectBase
    %CrossSectTrapezoid Describes a trapezoid.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the midpoint of the bottom edge,
    %   with the y axis pointing toward the top edge.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_h;      %Height length: class type dimLinear
        dim_w;      %Bottom edge length: class type dimLinear
        dim_depth;  %Depth of trapezoid: class type dimLinear
        dim_theta;  %Angular span of lower corner: class type dimAngular
    end
    
    methods
        function obj = CrossSectTrapezoid(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            % Calculate points of trapezoid
            % Bottom left is 1, rotating clockwise for 2, 3, 4

            h = obj.dim_h;
            w = obj.dim_w;
            theta = obj.dim_theta;

            point1 = [-(w/2), 0];
            point2 = [-(w/2) + (h/tan(theta)), h];
            point3 = [ (w/2) - (h/tan(theta)), h];
            point4 = [ (w/2), 0];

            % Draw segments
            [top_seg]    = drawer.drawLine(point2, point3);
            [bottom_seg] = drawer.drawLine(point1, point4);
            [left_seg]   = drawer.drawLine(point1, point2);
            [right_seg]  = drawer.drawLine(point3, point4);

            %calculate a coordinate inside the surface
            innerCoord = ((point1 + point2) / 2); %PLACE HOLDER CALCULATION. 
            %TO DO: REPLACE WITH REAL CALCULATION USING NEW LOCATION2D
            %note: this will be much, much improved by using Nick's new
            %Location2D class.....
            
            segments = [top_seg, bottom_seg, left_seg, right_seg];            
            csToken = CrossSectToken(innerCoord, segments);
        end
        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_h,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_theta,{'DimAngular'},{'nonnegative', 'nonempty', '<', pi})
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





