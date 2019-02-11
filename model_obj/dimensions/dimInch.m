classdef dimInch < dimLinear
    %dimInches Dimension in inches
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = dimInch(vargin)
            obj = obj@dimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = dimMillimeter(obj*25.4);
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = obj; 
        end
    end
end

