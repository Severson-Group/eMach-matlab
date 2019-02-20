classdef CrossSectBase < matlab.mixin.Heterogeneous
    %CROSSSECTBASE Abstract base class for cross sections
    %   Sets up and validates universial properties
    
    properties (GetAccess = 'public', SetAccess = 'protected') 
        name; % Name of the component
        location; % The location of the arc, a location2D object.
    end
    
    methods(Access = protected)
        function validateProps(obj)
            % Validate the global properties
            validateattributes(obj.name,     {'char'},            {'nonempty'})             
            validateattributes(obj.location, {'Location2D'},      {'nonempty'})
        end
    end
    
    methods(Abstract = true)
        draw(obj, drawer);
        select(obj);
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

