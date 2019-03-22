classdef CrossSectHollowCylinder < CrossSectBase
    %CROSSSECTHOLLOWCYLINDER Describes a hollow cylinder.
    %   Properties are set upon class creation and cannot be modified.
    %   The anchor point for this is the center of the circle
    
    
    properties (GetAccess = 'public', SetAccess = 'protected')
        dim_d_a;     %Thickness of the cylinder: class type dimLinear.
        dim_r_o;     %Outer radius of the cylinder: class type dimLinear    
    end

    methods(Static)
        function out = setGetNumObjects(obj)
            persistent counter;
            if isempty(counter)
                counter = 0;
            end
            if nargin
                obj.setGetObjectPool(counter, obj);
                counter = counter + 1;
            end
            out = counter;
        end
        
        function out = setGetObjectPool(counter, obj)
            persistent objectPool;
            if nargin
                if counter == 0
                    % Initialize the object array
                    objectPool = [obj, ];
                else
                    objectPool(end+1) = obj;
                end
            end
            out = objectPool;
        end
    end    
    
    methods
        function obj = CrossSectHollowCylinder(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();
            
            % Take a record of created objects (this should not be executed
            % if called by a child class, but how...)
            obj.setGetNumObjects(obj);
        end
                
        function [csToken] = draw(obj, drawer)
            validateattributes(drawer, {'Drawer2dBase'}, {'nonempty'});
            
            r = obj.dim_r_o;
            t = obj.dim_d_a;                  
            
            x_out = 0;
            x_in = 0;
            x = [x_out, x_out, x_in, x_in];
            
            y_out = r;
            y_in = r-t;
            y = [-y_out, y_out, -y_in, y_in];
            
            [p] = obj.location.transformCoords([x' y']);
            
            [arc_out1] = drawer.drawArc(obj.location.anchor_xy, p(1,:), p(2,:));
            [arc_out2] = drawer.drawArc(obj.location.anchor_xy, p(2,:), p(1,:));
            [arc_in1] = drawer.drawArc(obj.location.anchor_xy, p(3,:), p(4,:));
            [arc_in2] = drawer.drawArc(obj.location.anchor_xy, p(4,:), p(3,:));
            
            %calculate a coordinate inside the surface
            rad = obj.dim_r_o - obj.dim_d_a/2;
            innerCoord = obj.location.transformCoords([rad, 0]);             
            
            segments = [arc_out1, arc_out2, arc_in1, arc_in2];  
            csToken = CrossSectToken(innerCoord, segments);
        end

        function newObject = clone(obj, varargin)
            % Utilize the copy method of a Copyable object
            newObject = copy(obj);
            newObject.setGetNumObjects(newObject);

            % Call the class constructor for newObject Here
            newObject.createProps(length(varargin), varargin);
            newObject.validateProps();

            % Compare new name with old name and throw error if neccessary.
            if strcmp(newObject.name, obj.name)
                error('Error: method clone must be called with name property overridden.')
            end
            
            % Compare new name with the names from object pool.
            listOfNames = {CrossSectHollowCylinder.setGetObjectPool.name};
            %listOfNames
            len = length(listOfNames);
            for i = 1:len
                for j = i+1:len
                    if strcmp(listOfNames(i), listOfNames(j))
                        error('Error: There is already an object of this class named %s.', char(listOfNames(i)))
                    end
                end
            end
        end       
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@CrossSectBase(obj); 
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_d_a,{'DimLinear'},{'nonnegative','nonempty'})            
            validateattributes(obj.dim_r_o,{'DimLinear'},{'nonnegative','nonempty'})
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
