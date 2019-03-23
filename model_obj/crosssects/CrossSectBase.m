classdef CrossSectBase < matlab.mixin.Heterogeneous & matlab.mixin.Copyable
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

            % Take a record of created objects
            obj.setGetNumObjects(obj);        
        end
        
        function obj = createProperties(obj, len, args)
            validateattributes(len, {'numeric'}, {'even'});
            for i = 1:2:len 
                obj.(args{i}) = args{i+1};
            end
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

    methods(Static)
        function out = setGetNumObjects(obj)
            persistent counter;
            if isempty(counter)
                counter = 0;
            end
            if nargin
                obj.setGetObjectPool(counter, obj);
                counter = counter + 1;
            end
            out = counter;
        end
        
        function out = setGetObjectPool(counter, obj)
            persistent objectPool;
            if nargin
                if counter == 0
                    % Initialize the object array
                    objectPool = [obj, ];
                else
                    objectPool(end+1) = obj;
                end
            end
            out = objectPool;
        end
    end    
    
    methods
        function newObject = clone(oldObject, varargin)
            % Utilize the copy method of a Copyable object
            newObject = copy(oldObject);
            
            % Add cloned object to pool
            %newObject.setGetNumObjects(newObject);

            % Call the class constructor for newObject Here
            newObject.createProps(length(varargin), varargin);
            newObject.validateProps();

            % Compare new name with old name and throw error if neccessary.
            if strcmp(newObject.name, oldObject.name)
                error('Error: method clone must be called with a new name.')
            end
            
            % Compare new name with the names from object pool.
            listOfNames = {newObject.setGetObjectPool.name};
            len = length(listOfNames);
            for i = 1:len
                for j = i+1:len
                    if strcmp(listOfNames(i), listOfNames(j))
                        error('Error: There is already an object of this class named %s.', char(listOfNames(i)))
                    end
                end
            end
        end    
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

