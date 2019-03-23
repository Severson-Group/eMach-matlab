classdef CrossSectHollowCylinder < CrossSectBase
    %CROSSSECTHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;     %Thickness of the cylinder: class type dimLinear.
        dim_r_o;     %Outer radius of the cylinder: class type dimLinear    
    end

    methods
        function obj = CrossSectHollowCylinder(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();

            % Take a record of created objects
            obj.setGetNumObjects(obj);        
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            r = obj.dim_r_o;
            t = obj.dim_d_a;                  
            
            x_out = 0;
            x_in = 0;
            x = [x_out, x_out, x_in, x_in];
            
            y_out = r;
            y_in = r-t;
            y = [-y_out, y_out, -y_in, y_in];
            
            [p] = obj.location.transformCoords([x' y']);
            
            [arc_out1] = drawer.drawArc(obj.location.anchor_xy, p(1,:), p(2,:));
            [arc_out2] = drawer.drawArc(obj.location.anchor_xy, p(2,:), p(1,:));
            [arc_in1] = drawer.drawArc(obj.location.anchor_xy, p(3,:), p(4,:));
            [arc_in2] = drawer.drawArc(obj.location.anchor_xy, p(4,:), p(3,:));
            
            %calculate a coordinate inside the surface
            rad = obj.dim_r_o - obj.dim_d_a/2;
            innerCoord = obj.location.transformCoords([rad, 0]);             
            
            segments = [arc_out1, arc_out2, arc_in1, arc_in2];  
            csToken = CrossSectToken(innerCoord, segments);
        end 
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj); 
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_d_a,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_o,{'DimLinear'},{'nonnegative','nonempty'})
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
