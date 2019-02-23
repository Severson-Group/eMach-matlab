classdef Location2D
    %LOCATION2D Indicates a cross section's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xy = [DimMillimeter(0),DimMillimeter(0)];   %Distance from 
        %global origin xy coordinate to component's origin xy coordinate
        
        rotate_xy = DimRadian(0);  %Angles about global xy axes to 
                                     %rotate component's xy axes in radians
        R; %Rotation transformation matrix
    end
    
    methods
        function obj = Location2D(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xy,{'DimLinear'}, {'size', [1,2]})
            validateattributes(obj.rotate_xy,{'DimAngular'},{'size', [1,1]})
            theta = obj.rotate_xy.toRadians();
            obj.R = [ cos(theta), -sin(theta); ...
                      sin(theta),  cos(theta) ];
        end
        
        function [x,y] = transformCoords(obj, x, y)
            
            %This function takes in x and y coordinate vectors and 
            %returns transformed x and y coordinate vectors of the same
            %shape as the input vectors
            
            %grabbing orginal dimensions of x and y
            original_x_dim = size(x); 
            original_y_dim = size(y);
            
            %converting to x and y to 1xn column vectors
            x = reshape(x, 1, []); 
            y = reshape(y, 1, []);
           
            coords = [x;y];
            rotated_coords = obj.R*coords;
            
            x = reshape(rotated_coords(1,1:end), original_x_dim) + ...
                obj.anchor_xy(1);
            y = reshape(rotated_coords(2,1:end), original_y_dim) + ...
                obj.anchor_xy(2);
            
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

