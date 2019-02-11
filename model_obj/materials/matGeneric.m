classdef matGeneric
    %MATERIAL Material of a component. Place holder for now
    
    properties (GetAccess = 'public', SetAccess = 'protected') 
        name
    end
    
    methods
        function obj = matGeneric(varargin)
            %MATERIAL Create a material object using key value pairs
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
    
    methods(Access = protected)
        function validateProps(obj)            
            %VALIDATE_PROPS Validate the object properties
            validateattributes(obj.name,{'char'},{'nonempty'})                         
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

