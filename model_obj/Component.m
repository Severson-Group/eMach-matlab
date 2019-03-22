classdef Component < matlab.mixin.Copyable
    %COMPONENT A logical group of cross sections which make up a component
    %   Detailed explanation goes here
       
    properties(GetAccess = 'public', SetAccess = 'protected')
        name;           % Name of component
        crossSections;  % List of cross sections in this component
        material;       % Material component is made of
        makeSolid;      % How the cross sections will be made into a solid        
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
        function obj = Component(varargin)
            obj = createProperties(obj,nargin,varargin);
            validateattributes(obj.name, {'char'}, {'nonempty'});
            validateattributes(obj.crossSections, {'CrossSectBase'}, {'nonempty'});
            validateattributes(obj.material, {'MaterialGeneric'}, {'nonempty'});
            validateattributes(obj.makeSolid, {'MakeSolidBase'}, {'nonempty'});            
            obj.setGetNumObjects(obj);
        end
        
        function make(obj, drawer, maker)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            for i = 1:length(obj.crossSections)
                cs(i) = obj.crossSections(i).draw(drawer);                
            end
            
            obj.makeSolid.run(obj.name, obj.material.name, cs, maker)
        end
        
        function newObject = clone(obj, varargin)
            % Utilize the copy method of a Copyable object
            newObject = copy(obj);
            % Call the class constructor for newObject
            newObject.createProperties(length(varargin),varargin);
            validateattributes(newObject.name, {'char'}, {'nonempty'});
            validateattributes(newObject.crossSections, {'CrossSectBase'}, {'nonempty'});
            validateattributes(newObject.material, {'MaterialGeneric'}, {'nonempty'});
            validateattributes(newObject.makeSolid, {'MakeSolidBase'}, {'nonempty'});            
            newObject.setGetNumObjects(newObject);

            % Compare new name with old name and throw error if neccessary.
            if strcmp(newObject.name, obj.name)
                error('Error: method clone must be called with name property overridden.')
            end
            
            % Compare new name with the names from object pool.
            listOfNames = {Component.setGetObjectPool.name};
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
    
     methods(Access = protected)
         function obj = createProperties(obj, len, args)
             validateattributes(len, {'numeric'}, {'even'});
             for i = 1:2:len 
                 obj.(args{i}) = args{i+1};
             end
         end
     end
end

