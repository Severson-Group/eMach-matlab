classdef MakerRevolveBase < MakerBase
    %MakerRevolveBase Abstract base class for software which can revolve
    %parts    
    
    methods
        function obj = MakerRevolveBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
   
    methods(Abstract = true)
        new = revolve(obj, name, material, center, axis, angle)
        %REVOLVE Extrude a cross-section along an arc    
        %   name        - name of the newly extruded component
        %   center      - x,y coordinate of center point of rotation
        %   axis        - x,y coordinate on the axis of ration (negative reverses
        %               direction) (0, -1) to rotate clockwise about the y axis
        %   angle       - Angle of rotation (dimAngular)

        
    end
        
end
