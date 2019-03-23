classdef Component < CloneBase
    %COMPONENT A logical group of cross sections which make up a component
    %   Detailed explanation goes here
       
    properties(GetAccess = 'public', SetAccess = 'protected')
        name;           % Name of component
        crossSections;  % List of cross sections in this component
        material;       % Material component is made of
        makeSolid;      % How the cross sections will be made into a solid        
    end
    
    methods
        function obj = Component(varargin)
            obj = createProperties(obj,nargin,varargin);
            obj.validateProps();
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
        end
    end
    
    methods(Access = protected)
        function obj = createProperties(obj, len, args)
            validateattributes(len, {'numeric'}, {'even'});
            for i = 1:2:len 
                obj.(args{i}) = args{i+1};
            end
        end

        function validateProps(obj)            
            % Validate the global properties
            validateattributes(obj.name, {'char'}, {'nonempty'});
            validateattributes(obj.crossSections, {'CrossSectBase'}, {'nonempty'});
            validateattributes(obj.material, {'MaterialGeneric'}, {'nonempty'});
            validateattributes(obj.makeSolid, {'MakeSolidBase'}, {'nonempty'});            

            % Take a record of created objects
            obj.setGetNumObjects(obj);        
        end

    end
end

