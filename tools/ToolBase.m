classdef ToolBase < handle
    %ToolBase Abstract base class for Tool implementations
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    
    methods
        function obj = ToolBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
    
    methods(Abstract = true)
        open(obj, fileName); % Open a file
        save(obj); % Save the current file
        saveAs(obj, fileName); % Save the current file with the specified name at the specified location
        close(obj); % Close the file
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
            
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