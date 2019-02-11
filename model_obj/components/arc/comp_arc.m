classdef comp_arc < comp_base
    %ARC_COMPONENT Describes an arc magnet
    %   properties are set upon class creation, cannot be modified
    %   The anchor point for this is the center of the circle that this arc
    %   lies upon, with the x axis pointing toward the arc center.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_th;     %Thickness of the arc
        dim_ro;     %Outer radius of the arc
        dim_alpha;  %Angular span of the arc in radains
        dim_depth;  %Axial depth of the arc    
    end
    
    methods
        function obj = comp_arc(varargin)
            obj = obj.create_props(nargin,varargin);            
            obj.validate_props();            
        end
                

    end
    
     methods(Access = protected)
         function validate_props(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validate_props@comp_base(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_th,{'numeric'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_ro,{'numeric'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'numeric'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'numeric'},{'nonnegative', 'nonempty', '<', 2*pi})
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

