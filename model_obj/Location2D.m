classdef Location2D
    %LOCATION2D Indicates a cross section's location
    %   Detailed explanation goes here
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        anchor_xy = [DimMillimeter(0),DimMillimeter(0)];   %Distance from 
        %global origin xy coordinate to component's origin xy coordinate
        
        theta = DimRadian(0);  %Angles about global xy axes to 
                                     %rotate component's xy axes in radians
        R; %Rotation transformation matrix
    end
    
    methods
        function obj = Location2D(varargin)
            obj = createProperties(obj,nargin,varargin);            
            validateattributes(obj.anchor_xy,{'DimLinear'}, {'size', [1,2]})
            validateattributes(obj.theta,{'DimAngular'},{'size', [1,1]})
            theta = obj.theta.toRadians();
            obj.R = [ cos(theta), -sin(theta); ...
                      sin(theta),  cos(theta) ];
        end
        
        function rotatedCoords = transformCoords(obj, coords, addTheta)
            
            %This function takes in an nx2 array of coordinates of the form
            %[x,y] and returns rotated and translated coordinates. The
            %translation and rotation are described by obj.anchor_xy and
            %obj.theta. The optional "add_theta" argument adds an
            %additional angle of "add_theta" to the obj.theta attribute.
            
            if exist('add_theta','var')
                validateattributes(addTheta, {'DimAngular'}, {'size',[1,1]})
                add_theta = addTheta.toRadians() + obj.theta.toRadians();
                T = [ cos(add_theta), -sin(add_theta); ...
                      sin(add_theta),  cos(add_theta) ];
            else
                T = obj.R;
            end
               
            rotatedCoords = transpose(T*coords');
        end
        
        function locObj = relative(obj, relLinear, relAngular)
            

            validateattributes(relLinear, {'DimLinear'}, {'size',[1,2]})
            validateattributes(relAngular, {'DimAngular'}, {'size',[1,1]})
            
            anchor = obj.anchor_xy + relLinear;
            angle = obj.theta + relAngular;
            
            %NOTE, once operator overloading is created, there will be no
            %need to create dimension objects over again. The above code is
            %assuming the two quantities being added are of the same units
            %and the code below assumes what the dimensions were which is
            %clearly wrong
            
            anchor = DimMillimeter(anchor);
            angle = DimDegree(angle);
            
            locObj = Location2D('anchor_xy', anchor, ...
                                'theta', angle );
      
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

