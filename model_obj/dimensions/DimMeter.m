classdef DimMeter < DimLinear
    %DimMeter Dimension in meters
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimMeter(vargin)
            % Allow constructor to take in a DimLinear
            if (isa(vargin, 'DimLinear'))
                vargin = DimMeter(double(vargin.toMillimeter() * 1e-3));
            end

            obj = obj@DimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = DimMillimeter(1.0e3 * double(obj));
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = DimInch(1.0e3 * double(obj) / 25.4); 
        end
        
        function new = toMeter(obj) 
            %TOMETER Convert this dimension to meters
            
           new = obj; 
        end
    end
end

