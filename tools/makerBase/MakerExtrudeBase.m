classdef MakerExtrudeBase < MakerBase
    %MakerExtrudeBase Abstract base class for software which can extrude    
    
    methods
        function obj = MakerExtrudeBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
   
    methods(Abstract = true)
        new = extrude(obj, name, material, depth)           
    end
        
end
