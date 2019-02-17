classdef Component
    %COMPONENT A logical group of cross sections which make up a component
    %   Detailed explanation goes here
       
    properties(GetAccess = 'public', SetAccess = 'protected')
        name;           % Name of component
        cross_sections; % List of cross sections in this component
        material;       % Material component is made of
        make_solid;     % How the cross sections will be made into a solid
        location;       % 3D location of this component
    end
    
    methods
        function obj = Component(varargin)
            obj = createProperties(obj,nargin,varargin);
            validateattributes(obj.name, {'char'}, {'nonempty'});
            validateattributes(obj.cross_sections, {'CrossSectBase'}, {'nonempty'});
            validateattributes(obj.material, {'MaterialGeneric'}, {'nonempty'});
            validateattributes(obj.make_solid, {'MakeSolidBase'}, {'nonempty'});
            validateattributes(obj.location, {'Location3D'}, {'nonempty'});
        end
        
        function make(obj)
            for i = 1:length(obj.cross_sections)
                obj.cross_sections(i).draw();
                obj.cross_sections(i).select();
            end
            
            obj.make_solid.run();
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

