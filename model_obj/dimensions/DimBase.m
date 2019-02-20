classdef DimBase < double
    %DIMBASE Abstract base class for dimensions
    %   Specifies a contract for dimensions
    
    methods
        function obj = DimBase(vargin)
            obj = obj@double(vargin);
        end
    end
end

