classdef XFEMM < ToolBase & Drawer2dBase & MakerExtrudeBase & MakerRevolveBase
    %XFEMM Encapsulation for the XFEMM FEA software
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'private', SetAccess = 'private')
        FemmProblem;  % XFEMM FemmProblem struct
        doc; % Document object
        arcInfo;
        arcIndex = 0;
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
        
        function [FemmProblem, arcInfo] = returnFemmProblem(obj)
            FemmProblem = obj.FemmProblem;
            arcInfo = obj.arcInfo;
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
            %DRAWARC Draw an arc in the current XFEMM document.
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
            obj.arcIndex = obj.arcIndex + 1;
            obj.arcInfo(obj.arcIndex,1:2) = [centerxy(1), centerxy(2)];
            obj.arcInfo(obj.arcIndex,3) = R;
        end
        
        function FemmProblem = removeOverlaps(obj)
            FemmProblem = obj.FemmProblem;
            %% Overlapping nodes, ideally overlapping segments and arc segments

% Remove one of the two overlapping nodes
i = 2;
while (i <= numel(FemmProblem.Nodes))
    h = 0;
    for j = 1:(i-1)
        if abs(FemmProblem.Nodes(i).Coords(1) - FemmProblem.Nodes(j).Coords(1)) < 0.001 && ...
           abs(FemmProblem.Nodes(i).Coords(2) - FemmProblem.Nodes(j).Coords(2)) < 0.001
            % Remove one of the two overlapping nodes
            FemmProblem.Nodes(i) = [];
            % Renumber any remaining segments
            for k = 1:numel(FemmProblem.Segments)
                if (FemmProblem.Segments(k).n0 == i - 1)
                    FemmProblem.Segments(k).n0 = j - 1;
                end
                if (FemmProblem.Segments(k).n1 == i - 1)
                    FemmProblem.Segments(k).n1 = j - 1;
                end                
                if FemmProblem.Segments(k).n0 > (i-1)        
                    FemmProblem.Segments(k).n0 = FemmProblem.Segments(k).n0 - 1;         
                end
                if FemmProblem.Segments(k).n1 > (i-1)
                    FemmProblem.Segments(k).n1 = FemmProblem.Segments(k).n1 - 1;
                end
            end
            % Renumber any remaining arc segments
            for k = 1:numel(FemmProblem.ArcSegments)
                if (FemmProblem.ArcSegments(k).n0 == i - 1)
                    FemmProblem.ArcSegments(k).n0 = j - 1;
                end
                if (FemmProblem.ArcSegments(k).n1 == i - 1)
                    FemmProblem.ArcSegments(k).n1 = j - 1;
                end                  
                if FemmProblem.ArcSegments(k).n0 > (i-1)           
                    FemmProblem.ArcSegments(k).n0 = FemmProblem.ArcSegments(k).n0 - 1;
                end
                if FemmProblem.ArcSegments(k).n1 > (i-1)
                    FemmProblem.ArcSegments(k).n1 = FemmProblem.ArcSegments(k).n1 - 1;
                end
            end
            break
        else
            h = h + 1;
        end    
    end
    if h == i - 1
        i = i + 1;  
    end
end

% Remove one of the two ideally overlapping segments
i = 2; 
q = numel(FemmProblem.Segments);
while (i <= q)
    h = 0;
    for j = 1:(i-1)
        n10 = FemmProblem.Segments(i).n0;
        n11 = FemmProblem.Segments(i).n1;
        n20 = FemmProblem.Segments(j).n0;
        n21 = FemmProblem.Segments(j).n1;       
        if (n10 == n20 && n11 == n21) || (n10 == n21 && n11 == n20)                        
            FemmProblem.Segments(i) = [];  
            q = q - 1;
            break
        else
            h = h + 1;
        end    
    end
    if h == i - 1
        i = i + 1;  
    end
end
% Remove one of the two ideally overlapping arc segments
i = 2; 
q = numel(FemmProblem.ArcSegments);
while (i <= q)
    h = 0;
    for j = 1:(i-1)
        n10 = FemmProblem.ArcSegments(i).n0;
        n11 = FemmProblem.ArcSegments(i).n1;
        n20 = FemmProblem.ArcSegments(j).n0;
        n21 = FemmProblem.ArcSegments(j).n1; 
        ArcLength1 = FemmProblem.ArcSegments(i).ArcLength;
        ArcLength2 = FemmProblem.ArcSegments(j).ArcLength;      
        if (n10 == n20 && n11 == n21 && ArcLength1 == ArcLength2) % ...
                %|| (n10 == n21 && n11 == n20 && ArcLength1 == -ArcLength2)                        
            FemmProblem.ArcSegments(i) = [];  
            q = q - 1;
            break
        else
            h = h + 1;
        end    
    end
    if h == i - 1
        i = i + 1;  
    end
end

%% Partially overlapping segments (at least one node not overlapping)

% Identify partially overlapping segments
% Delete old segments
% Make reconnections by adding new segments
i = 2;
q = numel(FemmProblem.Segments);
while (i <= q)
    h = 0;
    for j = 1:(i-1)
        p1 = FemmProblem.Segments(i).n0 + 1;
        p2 = FemmProblem.Segments(i).n1 + 1;
        p3 = FemmProblem.Segments(j).n0 + 1;
        p4 = FemmProblem.Segments(j).n1 + 1; 
        x1 = FemmProblem.Nodes(p1).Coords(1);
        y1 = FemmProblem.Nodes(p1).Coords(2);
        x2 = FemmProblem.Nodes(p2).Coords(1);
        y2 = FemmProblem.Nodes(p2).Coords(2);
        x3 = FemmProblem.Nodes(p3).Coords(1);
        y3 = FemmProblem.Nodes(p3).Coords(2);
        x4 = FemmProblem.Nodes(p4).Coords(1);
        y4 = FemmProblem.Nodes(p4).Coords(2);
        k1 = (y2 - y1)/(x2 - x1);
        k2 = (y4 - y3)/(x4 - x3);
        b1 = y1 - k1*x1;
        b2 = y3 - k2*x3;
        p = [x1 y1 p1 - 1; x2 y2 p2 - 1; x3 y3 p3 - 1; x4 y4 p4 - 1];
        
        % Check if two segments partially overlap
        if ((~((x3 <= x2 && x4 <= x2 && x3 <= x1 && x4 <= x1) || ...
                (x3 >= x2 && x4 >= x2 && x3 >= x1 && x4 >= x1))) || ...
            (~((y3 <= y2 && y4 <= y2 && y3 <= y1 && y4 <= y1) || ...
                (y3 >= y2 && y4 >= y2 && y3 >= y1 && y4 >= y1)))) && ...
                 (((abs(k1 - k2) < 0.001 && abs(b1 - b2) < 0.001)) || ...
                 (abs(x1 - x2) < 0.001 && abs(x3 - x4) < 0.001 && abs(x1 - x3) < 0.001))
            % Sort coordinates for new segments
            if (abs(x1 - x2) < 0.001 && abs(x3 - x4) < 0.001 && abs(x1 - x3) < 0.001)
                p = sortrows(p,2);
            else
                p = sortrows(p,1);
            end
            % Delete old segments and make reconnections              
            FemmProblem.Segments(end+1) = FemmProblem.Segments(i);
            FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
            FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
            FemmProblem.Segments(i) = [];
            FemmProblem.Segments(j) = [];
            FemmProblem.Segments(end-2).n0 = p(1,3);
            FemmProblem.Segments(end-2).n1 = p(2,3);
            FemmProblem.Segments(end-1).n0 = p(2,3);
            FemmProblem.Segments(end-1).n1 = p(3,3);  
            FemmProblem.Segments(end).n0 = p(3,3);
            FemmProblem.Segments(end).n1 = p(4,3);   
            q = numel(FemmProblem.Segments);
            
            % Delete "zero" segments connecting the node to itself
r = 1;
while (r <= q)
    n0 = FemmProblem.Segments(r).n0;
    n1 = FemmProblem.Segments(r).n1;
    if (n0 == n1)                        
        FemmProblem.Segments(r) = [];  
        q = q - 1;
    else
        r = r + 1;
    end    
end
            i=i-1;
            break
        else
            h = h + 1;
        end    
    end
    if h == i - 1
        i = i + 1;  
    end
end

%% Partially overlapping arc segments (at least one node not overlapping)

% Identify partially overlapping arc segments
% Delete old arc segments
% Make reconnections by adding new arc segments
i = 2;
q = numel(FemmProblem.Segments);
while (i <= q)
    h = 0;
    for j = 1:(i-1)
        p1 = FemmProblem.ArcSegments(i).n0 + 1;
        p2 = FemmProblem.ArcSegments(i).n1 + 1;
        p3 = FemmProblem.ArcSegments(j).n0 + 1;
        p4 = FemmProblem.ArcSegments(j).n1 + 1; 
        x1 = FemmProblem.Nodes(p1).Coords(1);
        y1 = FemmProblem.Nodes(p1).Coords(2);
        x2 = FemmProblem.Nodes(p2).Coords(1);
        y2 = FemmProblem.Nodes(p2).Coords(2);
        x3 = FemmProblem.Nodes(p3).Coords(1);
        y3 = FemmProblem.Nodes(p3).Coords(2);
        x4 = FemmProblem.Nodes(p4).Coords(1);
        y4 = FemmProblem.Nodes(p4).Coords(2);
        % different based on the quadrant
        angle1 = atan;
        
        R1 = obj.arcInfo(i,3);
        R2 = obj.arcInfo(j,3);
        centerxy1 = obj.arcInfo(i,1:2);
        centerxy2 = obj.arcInfo(j,1:2);
        p = [angle1 p1 - 1; angle2 p2 - 1; angle3 p3 - 1; angle4 p4 - 1];
        
        % Check if two segments partially overlap
        if (~((angle3 <= angle2 && angle4 <= angle2 && ...
               angle3 <= angle1 && angle4 <= angle1) || ...
              (angle3 >= angle2 && angle4 >= angle2 && ...
               angle3 >= angle1 && angle4 >= angle1))) && ...
              (((abs(R1 - R2) < 0.001 && ...
               abs(centerxy1(1) - centerxy2(1)) < 0.001) &&...
               abs(centerxy1(2) - centerxy2(2)) < 0.001))
            % Sort coordinates for new arc segments
                p = sortrows(p,1);

            % Delete old segments and make reconnections              
            FemmProblem.Segments(end+1) = FemmProblem.Segments(i);
            FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
            FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
            FemmProblem.Segments(i) = [];
            FemmProblem.Segments(j) = [];
            FemmProblem.Segments(end-2).n0 = p(1,3);
            FemmProblem.Segments(end-2).n1 = p(2,3);
            FemmProblem.Segments(end-1).n0 = p(2,3);
            FemmProblem.Segments(end-1).n1 = p(3,3);  
            FemmProblem.Segments(end).n0 = p(3,3);
            FemmProblem.Segments(end).n1 = p(4,3);   
            q = numel(FemmProblem.Segments);
            
            % Delete "zero" segments connecting the node to itself
r = 1;
while (r <= q)
    n0 = FemmProblem.Segments(r).n0;
    n1 = FemmProblem.Segments(r).n1;
    if (n0 == n1)                        
        FemmProblem.Segments(r) = [];  
        q = q - 1;
    else
        r = r + 1;
    end    
end
            i=i-1;
            break
        else
            h = h + 1;
        end    
    end
    if h == i - 1
        i = i + 1;  
    end
end
        end
        
        %%
        function select(obj)

        end
        
        function new = revolve(obj, name, material, center, axis, angle)

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