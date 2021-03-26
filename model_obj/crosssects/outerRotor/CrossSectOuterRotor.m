classdef CrossSectOuterRotor < CrossSectBase
    %CrossSectOuterRotor Describes the outer rotor.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the rotor,
    %   with the x-axis directed down the center of one of the slots.
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_alpha_rs; % span angle of magnet segment: class type DimAngular
        dim_alpha_rm; % span angle of entire magnet: class type DimAngular
        dim_r_ro;     % outer radius of rotor: class type DimLinear.
        dim_d_rp;     % between pole depth: class type DimLinear
        dim_d_ri;     % back iron depth: class type DimLinear
        dim_d_rs;     % segment divider depth: class type DimLinear
        dim_p;        % number of pole pairs (integer)
        dim_S;        % number of segments / pole (integer)
        
    end
    
    methods
        function obj = CrossSectOuterRotor(varargin)
            obj = obj.createProps(nargin,varargin);
            obj.validateProps();            
        end
        
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'DrawerBase'}, {'nonempty'});
            
            % create local variables of all of the attributes
            % for more readable code
            alpha_rs = obj.dim_alpha_rs.toRadians();
            alpha_rm = obj.dim_alpha_rm.toRadians();
            r_ro = obj.dim_r_ro;
            d_rp = obj.dim_d_rp;
            d_ri = obj.dim_d_ri;
            d_rs = obj.dim_d_rs;
            p = obj.dim_p;
            S = obj.dim_S;
                   
            alpha_total = DimDegree(180/p).toRadians();
            
            % outer arc
            r = r_ro;
            x1 = r * cos(alpha_total / 2);
            y1 = r * sin(alpha_total / 2);
            
            % inner arc between poles
            r = r_ro - d_ri - d_rp;
            x2 = r * cos(alpha_rm / 2);
            y2 = r * sin(alpha_rm / 2);
            x3 = r * cos(alpha_total / 2);
            y3 = r * sin(alpha_total / 2);
            
            % line containing region between poles
            r = r_ro - d_ri;
            x4 = r * cos(alpha_rm / 2);
            y4 = r * sin(alpha_rm / 2);
            
            x_arr = [x1,  x1, x2, x3,  x2,  x3, x4,  x4];
            y_arr = [y1, -y1, y2, y3, -y2, -y3, y4, -y4];

            % TODO: please add support for S > 1
            if S > 1
               error("S>1 not supported!"); 
            end
            
            for i = 1 : (2*p)
                p = obj.location.transformCoords([x_arr',y_arr'], DimRadian((i-1)*alpha_total));
                
                x = p(:,1);
                y = p(:,2);

                p1 = [x(1), y(1)];
                p2 = [x(2), y(2)];
                
                p3 = [x(3), y(3)];
                p4 = [x(4), y(4)];
                
                p5 = [x(5), y(5)];
                p6 = [x(6), y(6)];
                
                p7 = [x(7), y(7)];
                p8 = [x(8), y(8)];

                arc1(i) = drawer.drawArc(obj.location.anchor_xy, p2, p1);
                arc2(i) = drawer.drawArc(obj.location.anchor_xy, p3, p4);
                arc3(i) = drawer.drawArc(obj.location.anchor_xy, p6, p5);
                
                seg1(i) = drawer.drawLine(p3, p7);
                seg2(i) = drawer.drawLine(p5, p8);
                
                arc4(i) = drawer.drawArc(obj.location.anchor_xy, p8, p7);
            end
            
            rad = r_ro - (d_ri / 2);
            innerCoord = obj.location.transformCoords([rad, 0]); 
            segments = [arc1];%[arc1, seg1, seg2, seg3, arc2, arc3, arc4, seg4, seg5, seg6];
            csToken = CrossSectToken(innerCoord, segments);
        end
        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. Use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj);   
            
            %2. Validate the new properties that have been added here
            validateattributes(obj.dim_alpha_rs,{'DimAngular'},{'nonnegative', 'nonempty'});
            validateattributes(obj.dim_alpha_rm,{'DimAngular'},{'nonnegative', 'nonempty'});
            validateattributes(obj.dim_r_ro,{'DimLinear'},{'nonnegative','nonempty'})  ;          
            validateattributes(obj.dim_d_rp,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_d_ri,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_d_rs,{'DimLinear'},{'nonnegative','nonempty'});
            validateattributes(obj.dim_p,{'double'},{'nonnegative','nonempty','integer'});
            validateattributes(obj.dim_S,{'double'},{'nonnegative','nonempty','integer'});
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
