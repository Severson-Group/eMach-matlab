classdef compArc < compBase
    %COMPARC Describes an arc of a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle that this arc
    %   lies upon, with the x axis pointing toward the arc center.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;     %Thickness of the arc: class type dimLinear. If 
        dim_r_o;     %Outer radius of the arc: class type dimLinear
        dim_alpha;  %Angular span of the arc: class type dimAngular
        dim_depth;  %Axial depth of the arc: class type dimLinear
    end
    
    methods
        function obj = compArc(varargin)
            obj = obj.create_props(nargin,varargin);            
            obj.validate_props();            
        end
                

    end
    
     methods(Access = protected)
         function validate_props(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validate_props@compBase(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_th,{'dimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_ro,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'dimLinear'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'dimAngular'},{'nonnegative', 'nonempty', '<', 2*pi})
         end
                  
         function obj = create_props(obj, len, args)
             %CREATE_PROPS Add support for value pair constructor
             
             validateattributes(len, {'numeric'}, {'even'});
             for i = 1:2:len 
                 obj.(args{i}) = args{i+1};
             end
         end
     end
end

