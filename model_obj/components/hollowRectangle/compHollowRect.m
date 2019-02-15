classdef compHollowRect < compBase
    %COMPHOLLOWRECT Describes a hollow rectangle.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the rectangle
    %   with the x axis horizontal and y axis vertical.
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_t;     %Thickness of the rectangle: class type dimLinear.
        dim_l_i;    %Length of inner rectangle: class type dimLinear
    end
    
    methods
        function obj = compHollowRect(varargin)
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
            validateattributes(obj.dim_t,{'dimLinear'},{'nonnegative','nonempty'});          
            validateattributes(obj.dim_l_i,{'dimLinear'},{'nonnegative','nonempty'});
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
    