classdef MakerExtrudeBase < MakerBase
    %Drawer2dBase Abstract base class for software which can draw in 2D
    %   Requires subclass to implement:
    %   - drawLine()
    %   - drawArc()
    %   - select()
    
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
