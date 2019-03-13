classdef CrossSectBreadloaf < CrossSectBase
    %COMPBREADLOAF Describes an a breadloaf profile (trapezoid with round top).
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is center of the arc'd edge, with the 
    %   x-axis pointing toward the center of the arc'd edge.    
    %   There still needs to be a check to make sure the geometry is valid
    %   (i.e. the radius is not too small)
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_w;     %width of the base: class type dimLinear.
        dim_l;     %length of sides: class type dimLinear
        dim_r;  %radius of top of breadloaf: class type dimLinear
        dim_alpha;  %angle between base and sides: class type dimAngular        
    end
    
    methods
        function obj = CrossSectBreadloaf(varargin)
            obj = obj.createProps(nargin, varargin);            
            obj.validateProps();            
        end
        
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            %create local variables for more readable code
            w = obj.dim_w;
            l = obj.dim_l;
            r = obj.dim_r;
            alpha = obj.dim_alpha.toRadians();
            
            %calculate coordinates each point starting in bottom right
            %corner and moving counterclockwise around the breadloaf
            
            p1 = [ w/2, 0 ];
            p2 = [ w/2 - l*cos(alpha),  l*sin(alpha) ];
            p3 = [-w/2 + l*cos(alpha),  l*sin(alpha) ];
            p4 = [-w/2, 0 ];
            
            beta = asin(p2(1)/r);
            base = r*cos(beta);
            arcCenter = [0, -(base - p2(2))];
            
            %transform coords
            p1 = obj.location.transformCoords(p1);
            p2 = obj.location.transformCoords(p2);
            p3 = obj.location.transformCoords(p3);
            p4 = obj.location.transformCoords(p4);
            arcCenter = obj.location.transformCoords(arcCenter);

            % Draw segments
            [rightSeg] = drawer.drawLine(p1,p2);
            [arc] = drawer.drawArc(arcCenter, p2, p3);
            [leftSeg]   = drawer.drawLine(p3, p4);
            [baseSeg]  = drawer.drawLine(p4, p1);
            
            innerCoord = obj.location.transformCoords( [0, l*sin(alpha)/2] );

            segments = [rightSeg, arc, leftSeg, baseSeg];
            csToken = CrossSectToken(innerCoord, segments);
        end
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_w,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_l,{'DimLinear'},{'nonnegative','nonempty'})
            validateattributes(obj.dim_r,{'DimLinear'},{'nonnegative', 'nonempty'})
            validateattributes(obj.dim_alpha,{'DimAngular'},{'nonnegative', 'nonempty'})
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
