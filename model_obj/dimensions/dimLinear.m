classdef dimLinear < dimBase
    %DIMLINEAR Abstract base class for linear dimensions
    %   Specifies a contract for dimension classes.
    
    methods 
        function obj = dimLinear(vargin)
            obj = obj@dimBase(vargin);
        end
    end
    
    methods(Abstract = true)
        new = toInch(obj)
        new = toMillimeter(obj)        
    end
end

