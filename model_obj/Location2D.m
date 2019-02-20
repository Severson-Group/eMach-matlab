classdef Location2D
    %LOCATION2D Indicates a cross section's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xy = [DimMillimeter(0),DimMillimeter(0)];   %Distance from global origin xy coordinate to component's origin xy coordinate
        rotate_xy = [DimRadian(0),DimRadian(0)];   %Angles about global xy axes to rotate component's xy axes in radians        
    end
    
    methods
        function obj = Location2D(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xy,{'DimLinear'}, {'size', [1,2]})
            validateattributes(obj.rotate_xy,{'DimAngular'}, {'size', [1,2]})            
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

