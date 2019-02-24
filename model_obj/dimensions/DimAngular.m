classdef DimAngular < DimBase
    %DIMANGULAR Abstract base class for angular dimensions
    %   Specifies a contract for dimension classes.
     
    methods 
        function obj = DimAngular(vargin)
            obj = obj@DimBase(vargin);
        end
    end
   
    methods(Abstract = true)
        new = toRadians(obj)
        new = toDegrees(obj)        
    end
end

