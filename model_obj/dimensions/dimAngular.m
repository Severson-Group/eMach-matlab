classdef dimAngular < dimBase
    %DANGULAR Abstract base class for angular dimensions
    %   Specifies a contract for dimension classes.
     
   
    methods(Abstract = true)
        new = toRadians(obj)
        new = toDegrees(obj)        
    end
end

