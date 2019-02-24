classdef DimRadian < DimAngular
    %DIMRADIAN Dimension in radians
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimRadian(vargin)
            obj = obj@DimAngular(vargin);
        end
        
        function new = toRadians(obj)            
            %TORADIANS Convert this dimension to degrees            
                        
            new = obj;
        end
        
        function new = toDegrees(obj) 
            %TODEGREES Convert this dimension to degrees
            
           new = DimDegree(obj*180/pi); 
        end
    end
end

