classdef compBreadloaf < compBase
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
        
    end
    
    methods
        function obj = compArc(varargin)
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
            validateattributes(obj.dim_w,{'dimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_l,{'dimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r,{'dimLinear'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'dimAngular'},{'nonnegative', 'nonempty', '<', pi})
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
