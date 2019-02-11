classdef clocation
    %CLOCATION Indicates a component's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xyz = [dimMillimeter(0),dimMillimeter(0),dimMillimeter(0)];   %Distance from global origin xyz coordinate to component's origin xyz coordinate
        rotate_xyz = [dimRadian(0),dimRadian(0),dimRadian(0)];   %Angles about global xyz axes to rotate component's xyz axes in radians        
    end
    
    methods
        function obj = clocation(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xyz,{'dimLinear'}, {'size', [1,3]})
            validateattributes(obj.rotate_xyz,{'dimAngular'}, {'size', [1,3]})            
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

