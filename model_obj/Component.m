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
            obj = createProperties(obj,nargin,varargin);
            validateattributes(obj.name, {'char'}, {'nonempty'});
            validateattributes(obj.crossSections, {'CrossSectBase'}, {'nonempty'});
            validateattributes(obj.material, {'MaterialGeneric'}, {'nonempty'});
            validateattributes(obj.makeSolid, {'MakeSolidBase'}, {'nonempty'});            
        end
        
        function make(obj, drawer, maker)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            for i = 1:length(obj.crossSections)
                cs(i) = obj.crossSections(i).draw(drawer);                
            end
            
            obj.makeSolid.run(obj.name, obj.material.name, cs, maker)
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

