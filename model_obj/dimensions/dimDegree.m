classdef dimDegree < dimAngular
    %DIMDEGREE Dimension in degrees
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function new = toRadians(obj)
            %TORADIANS Convert this dimension to degrees
            
            new = dimRadian(obj*pi/180);
        end
        
        function new = toDegrees(obj) 
            %TODEGREES Convert this dimension to degrees
            
           new = obj; 
        end
    end
end

