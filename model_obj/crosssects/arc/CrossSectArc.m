classdef CrossSectArc < CrossSectBase
    %CROSSSECTARC Describes an arc of a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle that this arc
    %   lies upon, with the x axis pointing toward the arc center.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;    %Thickness of the arc: class type dimLinear. If 
        dim_r_o;    %Outer radius of the arc: class type dimLinear
        dim_alpha;  %Angular span of the arc: class type dimAngular
        dim_depth;  %Axial depth of the arc: class type dimLinear
    end
    
    methods
        function obj = CrossSectArc(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            shift_xy = obj.location.anchor_xy(1:2);
            %rotate_xy = obj.location.rotate_xyz(3).toRadians;
            rotate_xy = 0;
            
            center = [0,0] + shift_xy(1:2); 

            % Outer arc segment
            startxy_out = obj.dim_r_o * ...
                        [   cos(-obj.dim_alpha.toRadians/2 + rotate_xy), ...
                            sin(-obj.dim_alpha.toRadians/2 + rotate_xy)] ...
                            + shift_xy;
            endxy_out = obj.dim_r_o * ...
                        [   cos(obj.dim_alpha.toRadians/2 + rotate_xy), ...
                            sin(obj.dim_alpha.toRadians/2 + rotate_xy)] ...
                            + shift_xy;        

            [arc_out] = drawer.drawArc(center, startxy_out, endxy_out);

            % Inner arc segment
            startxy_in = (obj.dim_r_o - obj.dim_d_a) * ...
                        [   cos(-obj.dim_alpha.toRadians/2 + rotate_xy), ...
                            sin(-obj.dim_alpha.toRadians/2 + rotate_xy)] ...
                            + shift_xy;

            endxy_in = (obj.dim_r_o - obj.dim_d_a) * ...
                        [   cos(obj.dim_alpha.toRadians/2 + rotate_xy), ...
                            sin(obj.dim_alpha.toRadians/2 + rotate_xy)] ...
                            + shift_xy;

            [arc_in] = drawer.drawArc(center, startxy_in, endxy_in);

            % Side segments
            [line_cc] = drawer.drawLine(endxy_in, endxy_out);
            [line_cw] = drawer.drawLine(startxy_in, startxy_out);

            %segments = [arc_out, arc_in, line_cc, line_cw];
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
            validateattributes(obj.dim_d_a,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_o,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'DimAngular'},{'nonnegative', 'nonempty', '<', 2*pi})
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

