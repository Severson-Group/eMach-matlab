classdef MakerSweepBase < MakerBase
    %MakerSweepBase Abstract base class for software which can sweep 
    
    methods
        function obj = MakerSweepBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
   
    methods(Abstract = true)
        new = sweep(obj, name, material, segments)
        %SWEEP Sweep a cross-section along a multi-vectored path.        
        
    end
        
end
