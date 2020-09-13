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
    
    methods(Access = public)
        function [obj] = clone(obj, name, varargin)
            %CLONE Clone an object
            %[obj] = clone(obj, name, varargin)
            %A new name is required along with a list of key-value pairs 
            %indicating which parameters should be changed.
            if strcmp(obj.name, name)
                error ('A new name must be specified for the cloned object')
            end
            
            obj.name = name;
            obj = obj.createProps(nargin-2,varargin);          
            obj.validateProps();            
        end
    end
    
    methods(Abstract = true)
        [csToken] = draw(obj, drawer);        
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

