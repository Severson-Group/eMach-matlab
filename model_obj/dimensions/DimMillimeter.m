classdef DimMillimeter < DimLinear
    %DIMMILLIMETER Dimension in millimeters
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = DimMillimeter(vargin)
            obj = obj@DimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = obj;
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = DimInch(obj/25.4); 
        end
    end
end

