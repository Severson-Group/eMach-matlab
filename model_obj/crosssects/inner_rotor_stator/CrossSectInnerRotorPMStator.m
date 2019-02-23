classdef CrossSectInnerRotorPMStator < CrossSectBase
    %CrossSectInnerRotorPMStator Describes the inner rotor PM stator.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the stator,
    %   with the x-axis directed down the center of one of the stator teeth.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_h;      %Height length: class type dimLinear
        dim_w;      %Bottom edge length: class type dimLinear
        dim_theta;  %Angular span of lower corner: class type dimAngular
    end
    
    methods
        function obj = CrossSectInnerRotorPMStator(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            % Calculate points of trapezoid
            % Bottom left is 1, rotating clockwise for 2, 3, 4

            h = obj.dim_h;
            w = obj.dim_w;
            theta = obj.dim_theta;
            
            x = [-(w/2), -(w/2) + (h/tan(theta)), ...
                  (w/2) - (h/tan(theta)), (w/2)];
            
            y = [0, h, h, 0];
            
            [x_trans, y_trans] = obj.location.transformCoords(x,y);

            point1 = [x_trans(1), y_trans(1)];
            point2 = [x_trans(2), y_trans(2)];
            point3 = [x_trans(3), y_trans(3)];
            point4 = [x_trans(4), y_trans(4)];

            % Draw segments
            [top_seg]    = drawer.drawLine(point2, point3);
            [bottom_seg] = drawer.drawLine(point1, point4);
            [left_seg]   = drawer.drawLine(point1, point2);
            [right_seg]  = drawer.drawLine(point3, point4);

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





