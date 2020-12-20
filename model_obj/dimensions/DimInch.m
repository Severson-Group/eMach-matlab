classdef DimInch < DimLinear
    %DimInches Dimension in inches
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimInch(vargin)
            % Allow constructor to take in a DimLinear
            if (isa(vargin, 'DimLinear'))
                vargin = vargin.toInch();
            end

            obj = obj@DimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = DimMillimeter(25.4 * double(obj));
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = obj; 
        end          
    end
end

