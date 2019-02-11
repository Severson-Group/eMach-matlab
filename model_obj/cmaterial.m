classdef cmaterial
    %MATERIAL Material of a component
    
    properties (GetAccess = 'public', SetAccess = 'protected') 
        name
    end
    
    methods
        function obj = cmaterial(varargin)
            %MATERIAL Create a material object using key value pairs
            obj = obj.create_props(nargin,varargin);            
            obj.validate_props();            
        end
    end
    
    methods(Access = protected)
        function validate_props(obj)            
            %VALIDATE_PROPS Validate the object properties
            validateattributes(obj.name,{'char'},{'nonempty'})                         
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

