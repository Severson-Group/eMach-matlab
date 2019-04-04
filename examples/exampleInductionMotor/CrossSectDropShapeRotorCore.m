classdef CrossSectDropShapeRotorCore < CrossSectBase
    % Don't read me. Look at codes.
    %CrossSectDropShapeRotorCore Describes an rotor iron core that fits to
    %a drop shape rotor slot.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point is the center of the outer circle of rotor slot.
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_rs;
        dim_d_ro;
        dim_w_ro;
        dim_w_rs1;
        dim_w_rs2;
        dim_D_or;
        dim_D_ir;
        Qr;
        listKeyPoints;
        bMirrored=false;
        mySgments={};
    end
    
    methods
        function obj = CrossSectDropShapeRotorCore(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function [csToken] = draw(self, drawer)
            disp('Draw Rotor Core...')
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});

            d_rs  = double(self.dim_d_rs);
            d_ro  = double(self.dim_d_ro);
            w_ro  = double(self.dim_w_ro);
            w_rs1 = double(self.dim_w_rs1);
            w_rs2 = double(self.dim_w_rs2);
            R_or  = double(0.5*self.dim_D_or);
            R_ir  = double(0.5*self.dim_D_ir);
            
            angleRotorSector = 2*pi/self.Qr*0.5;
            
            P1 = [-R_ir, 0];
            P2 = [-R_ir*cos(angleRotorSector), R_ir*sin(angleRotorSector)];
            P3 = [-R_or*cos(angleRotorSector), R_or*sin(angleRotorSector)];
            [x,y] = linecirc(0, 0.5*w_ro, 0, 0, R_or);
            if isnan(y) 
                error('Error: provided line and circle have no intersection.')
            elseif x(1)<0
                P4 = [x(1),y(1)];
            else
                P4 = [x(2),y(2)];
            end
            CenterP5P6 = [-(R_or - d_ro - w_rs1), 0];
            [x,y] = linecirc(0, 0.5*w_ro, CenterP5P6(1), CenterP5P6(2), w_rs1);
            if isnan(y) 
                error('Error: provided line and circle have no intersection.')
            elseif x(1)<0
                P5 = [x(1),y(1)];
            else
                P5 = [x(2),y(2)];
            end
            CenterP7P8 = [-(R_or - d_ro - w_rs1 - d_rs), 0];
            [P6, P7] = self.utilityTangentPointsOfTwoCircles(CenterP5P6, CenterP7P8, w_rs1, w_rs2);
            if P6(2) < 0
                P6(2) = -1*P6(2);
                P7(2) = -1*P7(2);
            end
            if P6(1) > P7(1)
                temp = P7;
                P7 = P6;
                P6 = temp;
            end
            P8 = [-(R_or - d_ro - w_rs1 - d_rs - w_rs2), 0];
            self.listKeyPoints = [P1, P2, P3, P4, P5, P6, P7, P8];
            
            arc21 = drawer.drawArc([0,0],P2,P1);
            line23 = drawer.drawLine(P2,P3);
            arc34 = drawer.drawArc([0,0],P3,P4);
            line45 = drawer.drawLine(P4,P5);
            arc65 = drawer.drawArc(CenterP5P6,P6,P5);
            line67 = drawer.drawLine(P6,P7);
            arc87 = drawer.drawArc(CenterP7P8,P8,P7);
            line81 = drawer.drawLine(P8,P1);
            
            % Calculate a coordinate inside the surface
            innerCoord = self.location.transformCoords( DimMillimeter([ 0.5*(P1(1)+P8(1)), 0.5*P2(2)]));
            
            segments = [arc21 ,line23,arc34 ,line45,arc65 ,line67,arc87 ,line81];
            csToken = CrossSectToken(innerCoord, segments);
            
            % Preseved for mirror and region
            for i = 1:length(segments)
                self.mySgments(end+1) = {segments(i).GetName()};
            end
        end
        
        function [coord3, coord4] = utilityTangentPointsOfTwoCircles(~, C1, C2, r, R)
            x1 = C1(1); y1 = C1(2);
            x2 = C2(1); y2 = C2(2);
            gamma = -atan((y2-y1)/(x2-x1));
            distance = sqrt((x2-x1)^2+(y2-y1)^2);
            beta = asin((R-r)/distance);
            alpha = gamma - beta;
            x3 = x1 + r*cos(0.5*pi - alpha);
            y3 = y1 + r*sin(0.5*pi - alpha);
            x4 = x2 + R*cos(0.5*pi - alpha);
            y4 = y2 + R*sin(0.5*pi - alpha); 
            % (x3,y3) and (x4,y4) are outer tangent points on one side.
            coord3 = [x3, y3];
            coord4 = [x4, y4];
        end
    end
    
    methods(Access = protected)
        function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component

            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   

            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_d_rs,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_d_ro,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w_ro,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w_rs1,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_w_rs2,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_D_or,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_D_ir,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.Qr,{'double'},{'nonnegative','nonempty'})            
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

