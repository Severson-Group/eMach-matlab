classdef MakeSolidBase
    %MakeSolidBase Abstract base class for making solid components
    %   TODO: what is this?
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        location;       % 3D location of this component
    end
    
    methods(Access = protected)
        function validateProps(obj)
            % Validate the global properties            
            validateattributes(obj.location, {'Location3D'}, {'nonempty'});
        end
    end
    
    methods(Abstract = true, Access = protected)
        obj = createProps(obj, len, args)
            %All child classes must implement this function to support
            %contruction based on value pairs
        
    end
    
    methods(Abstract = true)
        run(obj, name, material, csToken, maker)
    end
end

