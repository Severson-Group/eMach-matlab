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
            % lhs and rhs have to be at least doubles, non-empty
            validateattributes(lhs, {'double'}, {'nonempty'});
            validateattributes(rhs, {'double'}, {'nonempty'});
            
            % Check that both lhs and rhs aren't BOTH DimLinear
            if (isa(lhs, 'DimLinear') && isa(rhs, 'DimLinear'))
                error('Both lhs and rhs are DimLinear.');
            end
            
            % At this point, we have confirmed that EITHER lhs is scalar,
            % or rhs, but NOT BOTH!
                        
            % Convert to DimMillimeter for calculation
            if (isa(lhs, 'DimLinear'))
                product = double(rhs) * double(lhs.toMillimeter());
                retclass = class(lhs);
            elseif (isa(rhs, 'DimLinear'))
                product = double(lhs) * double(rhs.toMillimeter());
                retclass = class(rhs);
            else
               % ERROR, this should never happen 
               error('This should never happen due to checks above...');
            end
            
            
            % Return object of same type as LHS
            r = feval(retclass, DimMillimeter(product));
        end
        
        function r = mrdivide(lhs, rhs)
            % lhs must be DimLinear
            % rhs must be double only
            validateattributes(lhs, {'DimLinear'}, {'nonempty'});
            validateattributes(rhs, {'double'}, {'nonempty'});
            
            % Check that both lhs and rhs aren't BOTH DimLinear
            if (isa(lhs, 'DimLinear') && isa(rhs, 'DimLinear'))
                error('Both lhs and rhs are DimLinear.');
            end
            
            % At this point, we have confirmed that lhs is DimLinear,
            % and rhs is double, but NOT BOTH DimLinear!
                        
            % Convert to DimMillimeter for calculation
            result = double(lhs.toMillimeter()) / double(rhs);

            % Return object of same type as LHS
            r = feval(class(lhs), DimMillimeter(result));
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

