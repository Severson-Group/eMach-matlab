classdef MakeSimpleExtrude < MakeSolidBase
    %MAKESIMPLEEXTRUDE Extrude a cross-section along a straight path
    %   Make a cross-section solid through simple extrusion
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        dim_depth;  %Length to extrude: class type dimLinear.                 
    end    
    
    methods
        function obj = MakeSimpleExtrude(varargin)
            %MAKESIMPLEEXTRUDE Construct an instance of this class
            
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
                
        function run(obj, name, material, csToken, maker)
            %RUN Make the cross-section solid
            
            %1. Prepare to extrude
            for i = 1:length(csToken)
                maker.prepareSection(csToken);
            end
            
            %2. Make via extrusion
            maker.extrude(name, material, obj.dim_depth);
            
            %3. TO DO: Move to final location
            %maker.Move(name, obj.location);
            
        end
    end
    
    
    methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            %1. use the superclass method to validate the properties 
            validateProps@MakeSolidBase(obj);   
            
            %2. valudate the new properties that have been added here
            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative','nonempty'})                        
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

