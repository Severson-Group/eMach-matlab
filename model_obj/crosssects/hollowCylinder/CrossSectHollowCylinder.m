classdef CrossSectHollowCylinder < CrossSectBase
    %CROSSSECTHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;     %Thickness of the cylinder: class type dimLinear.
        dim_r_o;     %Outer radius of the cylinder: class type dimLinear
        dim_depth;   %Axial Depth of cylinder: class type dimLinear        
    end
    
    methods
        function obj = CrossSectHollowCylinder(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            outer_radius = obj.dim_r_o;
            thickness = obj.dim_d_a;            
            center = [0,0];
            
            % Outer circle
            outer_radius = compHollowCylinderObj.dim_r_o;
            startxy_out = outer_radius*[0, -1]; % + shift_xy;
            endxy_out = outer_radius*[0, 1]; % + shift_xy;
            [arc_out1] = drawer.drawArc(mn, center, startxy_out, endxy_out);
            [arc_out2] = drawer.drawArc(mn, center, endxy_out, startxy_out);
            
            % inner circle
            inner_radius = outer_radius - thickness;
            startxy_in = inner_radius*[0, -1]; % + shift_xy;
            endxy_in = inner_radius*[0, 1]; % + shift_xy;
            [arc_in1] = drawer.drawArc(mn, center, startxy_in, endxy_in);
            [arc_in2] = drawer.drawArc(mn, center, endxy_in, startxy_in);
            segments = [arc_out1, arc_out2, arc_in1, arc_in2];       
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
            validateattributes(obj.dim_d_a,{'dimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_o,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative','nonempty'})
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
