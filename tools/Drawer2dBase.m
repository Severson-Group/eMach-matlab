classdef Drawer2dBase < handle
    %Drawer2dBase Abstract base class for Drawer2d implementations
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    
    properties (GetAccess = 'public', SetAccess = 'protected')
%        attr1; % Describe this attribute
%        attr2; % Describe this attribute
    end
    
    methods
        function obj = Drawer2dBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
   
    methods(Abstract = true)
        new = drawLine(obj)
        new = drawArc(obj)
        new = select(obj)
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
%            validateProps@Tool(obj);   
%            validateProps@Drawer2D(obj);   
%            validateProps@MakeSolid(obj);   
            
            %2. valudate the new properties that have been added here
%            validateattributes(obj.dim_d_a,{'DimLinear'},{'nonnegative','nonempty'})            
%            validateattributes(obj.dim_r_o,{'DimLinear'},{'nonnegative','nonempty'})
%            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative', 'nonempty'})
%            validateattributes(obj.dim_alpha,{'DimAngular'},{'nonnegative', 'nonempty', '<', 2*pi})
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