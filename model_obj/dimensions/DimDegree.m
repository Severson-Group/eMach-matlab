classdef DimDegree < DimAngular
    %DIMDEGREE Dimension in degrees
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimDegree(vargin)
            obj = obj@DimAngular(vargin);
        end
        
        function new = toRadians(obj)
            %TORADIANS Convert this dimension to degrees
            
            new = DimRadian(obj*pi/180);
        end
        
        function new = toDegrees(obj) 
            %TODEGREES Convert this dimension to degrees
            
           new = obj; 
        end
    end
end

