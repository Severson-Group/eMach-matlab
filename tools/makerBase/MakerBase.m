classdef MakerBase < handle
    %Drawer2dBase Abstract base class for software which can draw in 2D
    %   Requires subclass to implement:
    %   - drawLine()
    %   - drawArc()
    %   - select()
    
    methods
        function obj = MakerBase(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
    end
   
    methods(Abstract = true)        
        new = prepareSection(obj, csToken)        
    end
    
     methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
         end
                  
         function obj = createProps(obj, len, args)
             %CREATE_PROPS Add support for value pair constructor
             
             validateattributes(len, {'numeric'}, {'even'});
             for i = 1:2:len 
                 obj.(args{i}) = args{i+1};
             end
         end
     end
end
