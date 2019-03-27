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
        
        function r = mtimes(lhs, rhs)
            validateattributes(lhs, {'double'}, {'nonempty'});
            validateattributes(rhs, {'DimLinear'}, {'nonempty'});

            % Convert to DimMillimeter for calculation
            product = lhs*double(rhs.toMillimeter());

            % Return object of same type as LHS
            r = feval(class(rhs), DimMillimeter(product));
        end
        
        function r = minus(lhs, rhs)
            validateattributes(lhs, {'DimLinear'}, {'nonempty'});
            validateattributes(rhs, {'DimLinear'}, {'nonempty'});

            % Convert to DimMillimeter for calculation
            sum = double(lhs.toMillimeter()) - double(rhs.toMillimeter());

            % Return object of same type as LHS
            r = feval(class(lhs), DimMillimeter(sum));
        end
        
        function r = uminus(obj)
            validateattributes(obj, {'DimLinear'}, {'nonempty'});

            % Convert to DimMillimeter for calculation
            val = -double(obj.toMillimeter());

            % Return object of same type as obj
            r = feval(class(obj), DimMillimeter(val));
        end
        
        function r = uplus(obj)
            validateattributes(obj, {'DimLinear'}, {'nonempty'});

            % Convert to DimMillimeter for calculation
            val = double(obj.toMillimeter());
            
            if (val < 0)
                val = val * -1;
            end

            % Return object of same type as obj
            r = feval(class(obj), DimMillimeter(val));
        end
    end
    
    methods(Abstract = true)
        new = toInch(obj)
        new = toMillimeter(obj)        
    end
end

