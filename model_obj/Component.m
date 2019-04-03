classdef Component
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
            obj = createProps(obj,nargin,varargin);
            obj.validateProps();
        end
        
        function make(obj, drawer, maker)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            validateattributes(maker,  {'MakerBase'},  {'nonempty'});
            
            for i = 1:length(obj.crossSections)
                cs(i) = obj.crossSections(i).draw(drawer);                
            end
            
            obj.makeSolid.run(obj.name, obj.material.name, cs, maker)
        end

        function draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});

            for i = 1:length(obj.crossSections)
                obj.crossSections(i).draw(drawer);
            end
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

    methods(Access = protected)
        function obj = createProps(obj, len, args)
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
        end
    end
     
end

