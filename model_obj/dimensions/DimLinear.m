classdef DimLinear < DimBase
    %DIMLINEAR Abstract base class for linear dimensions
    %   Specifies a contract for dimension classes.
    
    methods 
        function obj = DimLinear(vargin)
            obj = obj@DimBase(vargin);
        end

        function r = plus(lhs, rhs)
            validateattributes(lhs, {'DimLinear'}, {'nonempty'});
            validateattributes(rhs, {'DimLinear'}, {'nonempty'});

            % Convert to DimMillimeter for calculation
            sum = double(lhs.toMillimeter()) + double(rhs.toMillimeter());

            % Return object of same type as LHS
            r = feval(class(lhs), DimMillimeter(sum));
        end
    end
    
    methods(Abstract = true)
        new = toInch(obj)
        new = toMillimeter(obj)        
    end
end

