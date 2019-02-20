classdef DimInch < DimLinear
    %DimInches Dimension in inches
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimInch(vargin)
            obj = obj@DimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = DimMillimeter(obj*25.4);
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = obj; 
        end
    end
end

