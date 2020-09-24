classdef CrossSectParallelogram  < CrossSectBase
    %   CrossSectParallelogram Describes a solid parallelogram.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the lower left corner of the parallelogram.
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_l; %length of the parallelogram; class type dimLinear
        dim_t; %thickness of the parallelogram: class type dimLinear
        dim_theta;  %angle of the parallelogram: class type dimAngular
    end
    
  methods
        function obj = CrossSectParallelogram(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            
            %calculate points of parallelogram
            % starts from the bottom left, goes clockwise
            l = obj.dim_l;
            t = obj.dim_t;
            theta = obj.dim_theta.toRadians();
            
            %%Create points
            x = [0, l*cos(theta), l*cos(theta)+ t/sin(theta), t/sin(theta) ];
            y = [0, l*sin(theta), l*sin(theta), 0];
            
            %%Transform Coordinates
            [points] = obj.location.transformCoords([x',y']);
            
            %% Draw Parallelogram
            [l_1] = drawer.drawLine(points(1,:),points(2,:));
            [l_2] = drawer.drawLine(points(2,:),points(3,:));
            [l_3] = drawer.drawLine(points(3,:),points(4,:));
            [l_4] = drawer.drawLine(points(4,:),points(1,:));
            
            %compute coordinate inside the surface to extrude
            x_coord = (l*cos(theta)+ t/sin(theta))/2;
            y_coord = l*sin(theta)/2;
            
            innerCoord = obj.location.transformCoords([x_coord, y_coord]);
            segments = [l_1,l_2,l_3,l_4];  
            csToken = CrossSectToken(innerCoord, segments);
            
        end
    end
    
  methods(Access = protected)
     function validateProps(obj)
       %VALIDATE_PROPS Validate the properties of this component
             
       %1. use the superclass method to validate the properties 
        validateProps@CrossSectBase(obj);   
            
        %2. valudate the new properties that have been added here
        validateattributes(obj.dim_l,{'DimLinear'},{'positive','nonempty'});
        validateattributes(obj.dim_t,{'DimLinear'},{'positive','nonempty'});
        validateattributes(obj.dim_theta,{'DimAngular'},{'positive','nonempty'});
      end
                  
         function obj = createProps(obj, len, args)
             %CREATE_PROPS Add support for value pair constructor
             
             validateattributes(len, {'numeric'}, {'even'});
             for i = 1:2:len 
                 obj.(args{i}) = args{i+1};
             end
         end
     end
end

