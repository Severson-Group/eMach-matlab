classdef dimMillimeter < dimLinear
    %dimMillimeter Dimension in millimeters
    %   based off of the double class, this class implements required
    %   conversion methods.
     
   
    methods
        function obj = dimMillimeter(vargin)
            obj = obj@dimLinear(vargin);
        end
        
        function new = toMillimeter(obj)            
            %TOMILLIMETER Convert this dimension to mm
                        
            new = obj;
        end
        
        function new = toInch(obj) 
            %TOINCHES Convert this dimension to inches
            
           new = dimInch(obj/25.4); 
        end
    end
end

