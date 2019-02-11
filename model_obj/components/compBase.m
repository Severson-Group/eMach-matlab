classdef compBase
    %COMPBASE Abstract base class for components
    %   Sets up and validates universial properties
    
    properties (GetAccess = 'public', SetAccess = 'protected') 
        name;     %Name of the component
        material;   %Arc material, a material object                     
        location = clocation();   %The location of the arc, a clocation object.        
    end
    
    methods(Access = protected)
        function validateProps(obj)            
            
            %validate the global properties
            validateattributes(obj.name,{'char'},{'nonempty'})             
            validateattributes(obj.location, {'clocation'}, {'nonempty'})
            validateattributes(obj.material, {'matGeneric'}, {'nonempty'})
        end
    end
    
    methods(Abstract = true, Access = protected)
        obj = createProps(obj, len, args)
            %All child classes must implement this function to support
            %contruction based on value pairs
    end
     
%% Example implementation:
%     methods
%         function obj = comp(varargin)
%             obj = createProperties(obj,nargin,varargin);
%             
%             %validate the properties:
%             validateattributes(obj.c_name,{'char'},{'nonempty'})
%         end
%         
%     end
%
%     methods(Access = protected)
%         function obj = createProperties(obj, len, args)
%             validateattributes(len, {'numeric'}, {'even'});
%             for i = 1:2:len 
%                 obj.(args{i}) = args{i+1};
%             end
%         end
%     end
end

