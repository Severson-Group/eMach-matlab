classdef DimMillimeter < DimLinear
    %DIMMILLIMETER Dimension in millimeters
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimMillimeter(vargin)
            % Allow constructor to take in a DimLinear
            if (isa(vargin, 'DimLinear'))
                vargin = vargin.toMillimeter();
            end

            obj = obj@DimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = obj;
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = DimInch(double(obj) / 25.4); 
        end
        
        function new = toMeter(obj) 
            %TOMETER Convert this dimension to meters
            
           new = DimMeter(double(obj) / 1e3); 
        end
    end
end

