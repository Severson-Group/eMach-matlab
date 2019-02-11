classdef dimLinear < dimBase
    %DIMLINEAR Abstract base class for linear dimensions
    %   Specifies a contract for dimension classes.
        
    methods(Abstract = true)
        new = toInch(obj)
        new = toMillimeter(obj)        
    end
end

