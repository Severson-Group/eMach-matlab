classdef DimLinear < DimBase
    %DIMLINEAR Abstract base class for linear dimensions
    %   Specifies a contract for dimension classes.
    
    methods 
        function obj = DimLinear(vargin)
            obj = obj@DimBase(vargin);
        end
    end
    
    methods(Abstract = true)
        new = toInch(obj)
        new = toMillimeter(obj)        
    end
end

