classdef dimRadian < dimAngular
    %DIMRADIAN Dimension in radians
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = dimRadian(vargin)
            obj = obj@dimAngular(vargin);
        end
        
        function new = toRadians(obj)            
            %TORADIANS Convert this dimension to degrees            
                        
            new = obj;
        end
        
        function new = toDegrees(obj) 
            %TODEGREES Convert this dimension to degrees
            
           new = dimDegree(obj*180/pi); 
        end
    end
end

