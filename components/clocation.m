classdef clocation
    %CLOCATION Indicates a component's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xyz = [0,0,0];   %Distance from global origin xyz coordinate to component's origin xyz coordinate
        rotate_xyz = [0,0,0];      %Angles from global xyz axes to component's xyz axes in radians        
    end
    
    methods
        function obj = clocation(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xyz,{'numeric'}, {'size', [1,3]})
            validateattributes(obj.rotate_xyz,{'numeric'}, {'size', [1,3]})            
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

