classdef dimBase < double
    %D_BASE Abstract base class for dimensions
    %   Specifies a contract for dimensions
    
    methods
        function obj = dimBase(vargin)
            obj = obj@double(vargin);
        end
    end
end

