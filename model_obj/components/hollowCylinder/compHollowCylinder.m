classdef compHollowCylinder < compBase
    %COMPHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;     %Thickness of the cylinder: class type dimLinear.
        dim_r_o;     %Outer radius of the cylinder: class type dimLinear
        dim_depth;   %Axial depth of the cylinder: class type dimLinear
    end
    
    methods
        function obj = compHollowCylinder(varargin)
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
            validateattributes(obj.dim_d_a,{'dimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_o,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_depth,{'dimLinear'},{'nonnegative', 'nonempty'})            
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

