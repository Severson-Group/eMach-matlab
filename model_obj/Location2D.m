classdef Location2D
    %LOCATION2D Indicates a cross section's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xy = [DimMillimeter(0),DimMillimeter(0)];   %Distance from 
        %global origin xy coordinate to component's origin xy coordinate
        
<<<<<<< HEAD
        rotate_xy = DimRadian(0);  %Angles about global xy axes to 
=======
        theta = DimRadian(0);  %Angles about global xy axes to 
>>>>>>> develop
                                     %rotate component's xy axes in radians
        R; %Rotation transformation matrix
    end
    
    methods
        function obj = Location2D(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xy,{'DimLinear'}, {'size', [1,2]})
<<<<<<< HEAD
            validateattributes(obj.rotate_xy,{'DimAngular'},{'size', [1,1]})
            theta = obj.rotate_xy.toRadians();
            obj.R = [ cos(theta), -sin(theta); ...
                      sin(theta),  cos(theta) ];
        end
        
        function [x,y] = transformCoords(obj, x, y, theta)
            
            %This function takes in x and y coordinate vectors and 
            %returns transformed x and y coordinate vectors of the same
            %shape as the input vectors
            
            if exist('theta','var')
                validateattributes(theta, {'DimAngular'}, {'size',[1,1]})
                theta = theta.toRadians() + obj.rotate_xy.toRadians();
                R = [ cos(theta), -sin(theta); ...
                      sin(theta),  cos(theta) ];
            else
                R = obj.R;
            end
               
            
            %grabbing orginal dimensions of x and y
            original_x_dim = size(x); 
            original_y_dim = size(y);
            
            %converting to x and y to 1xn column vectors
            x = reshape(x, 1, []); 
            y = reshape(y, 1, []);
           
            coords = [x;y];
            rotated_coords = R*coords;
            
            x = reshape(rotated_coords(1,1:end), original_x_dim) + ...
                obj.anchor_xy(1);
            y = reshape(rotated_coords(2,1:end), original_y_dim) + ...
                obj.anchor_xy(2);
            
=======
            validateattributes(obj.theta,{'DimAngular'},{'size', [1,1]})
            theta = obj.theta.toRadians();
            obj.R = [ cos(theta), -sin(theta); ...
                      sin(theta),  cos(theta) ];
>>>>>>> develop
        end
        
        function rotated_coords = transformCoords(obj, coords, add_theta)
            
            %This function takes in an nx2 array of coordinates of the form
            %[x,y] and returns rotated and translated coordinates. The
            %translation and rotation are described by obj.anchor_xy and
            %obj.theta. The optional "add_theta" argument adds an
            %additional angle of "add_theta" to the obj.theta attribute.
            
            if exist('add_theta','var')
                validateattributes(add_theta, {'DimAngular'}, {'size',[1,1]})
                add_theta = add_theta.toRadians() + obj.theta.toRadians();
                T = [ cos(add_theta), -sin(add_theta); ...
                      sin(add_theta),  cos(add_theta) ];
            else
                T = obj.R;
            end
               
            rotated_coords = transpose(T*coords');
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

