classdef CrossSectBreadloaf < CrossSectBase
    %COMPBREADLOAF Describes an a breadloaf profile (trapezoid with round top).
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is center of the arc'd edge, with the 
    %   x-axis pointing toward the center of the arc'd edge.    
    %   There still needs to be a check to make sure the geometry is valid
    %   (i.e. the radius is not too small)
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_w;     %width of the base: class type dimLinear. If 
        dim_l;     %length of sides: class type dimLinear
        dim_r;  %radius of top of breadloaf: class type dimLinear
        dim_alpha;  %angle between base and sides: class type dimAngular
        dim_depth; %depth of breadloaf: class type dimLinear
        
    end
    
    methods
        function obj = CrossSectBreadloaf(varargin)
            obj = obj.createProps(nargin, varargin);            
            obj.validateProps();            
        end
        
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            w = obj.dim_w;
            l = obj.dim_l;
            r = obj.dim_r;
            alpha = obj.dim_alpha.toRadians();
            
            y_out = w/2 - l*cos(alpha);
            y_in = w/2;
            beta = asin(y_out/r);
            x_out = r*cos(beta);
            x_in = x_out - l*sin(alpha);
            
            x = [ x_out, x_out, x_in, x_in ];
            y = [-y_out, y_out, y_in, -y_in];
            
            [x_trans, y_trans] = obj.location.transformCoords(x,y);

            p1 = [x_trans(1), y_trans(1)];
            p2 = [x_trans(2), y_trans(2)];
            p3 = [x_trans(3), y_trans(3)];
            p4 = [x_trans(4), y_trans(4)];

            % Draw segments
            [arc]    = drawer.drawArc(obj.location.anchor_xy, p1, p2);
            [top_seg] = drawer.drawLine(p2,p3);
            [base]   = drawer.drawLine(p3, p4);
            [bottom_seg]  = drawer.drawLine(p4, p1);

            %segments = [arc, top_seg, base, bottom_seg];
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
            validateattributes(obj.dim_w,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_l,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r,{'DimLinear'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'DimAngular'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative', 'nonempty'})
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
