classdef XFEMM < ToolBase & Drawer2dBase
    %XFEMM Encapsulation for the XFEMM FEA software
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'private', SetAccess = 'private')
        FemmProblem;  % XFEMM FemmProblem struct
        doc; % Document object
    end
    
    methods
        function obj = XFEMM(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function obj = open(obj)
            
        end
        
        function obj = close(obj)
            
        end
        
        function obj = newFemmProblem(obj, freq, type, units)
            obj.FemmProblem = newproblem_mfemm(type, ...
                'Frequency', freq, ...
                'LengthUnits', units);
        end
        
        function FemmProblem = returnFemmProblem(obj)
            FemmProblem = obj.FemmProblem;
        end
        
        function [line] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            [obj.FemmProblem, nodeinds, nodeids] = addnodes_mfemm(...
                obj.FemmProblem, [startxy(1); endxy(1)],...
                [startxy(2); endxy(2)]);
            
            [obj.FemmProblem, seginds] = addsegments_mfemm(obj.FemmProblem,...
                nodeids(1), nodeids(2));
            
            line = seginds;
        end
        
        function [arc] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current MagNet document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            
            R = sqrt((centerxy(1) - startxy(1))^2 + ...
                (centerxy(2) - startxy(2))^2);
            L = sqrt((endxy(1) - startxy(1))^2 + ...
                (endxy(2) - startxy(2))^2);
            angle = 2*asin(L/2/R)*180/pi;
            
            [obj.FemmProblem, nodeinds, nodeids] = addnodes_mfemm(...
                obj.FemmProblem, [startxy(1); endxy(1)],...
                [startxy(2); endxy(2)]);
            
            [obj.FemmProblem, arcseginds] = addarcsegments_mfemm(...
                obj.FemmProblem, nodeids(1), nodeids(2), angle);
            
            arc = arcseginds;   
        end
        
        function select(obj)

        end
        
        function extrude(obj, name, material, depth)

        end
        
        function prepareSection(obj, csToken)
            
        end        
        
        function setDefaultLengthUnit(obj, userUnit, makeAppDefault)

        end
        
        function viewAll(obj)

        end
        
        
        function setVisibility(obj, visibility)

        end
    end
    
    methods(Access = protected)
         function validateProps(obj)
            %VALIDATE_PROPS Validate the properties of this component
             
            % Use the superclass method to validate the properties 
            validateProps@ToolBase(obj);   
            validateProps@Drawer2dBase(obj);
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