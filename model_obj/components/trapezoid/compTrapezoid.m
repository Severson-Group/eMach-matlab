classdef compTrapezoid < compBase
    %COMPTRAPEZOID Describes a trapezoid.
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
        function obj = compTrapezoid(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@compBase(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_h,{'dimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_theta,{'dimAngular'},{'nonnegative', 'nonempty', '<', pi})
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





