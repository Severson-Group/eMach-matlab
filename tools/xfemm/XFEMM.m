classdef XFEMM < ToolBase & DrawerBase & MakerExtrudeBase & MakerRevolveBase
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
        lineTokenIndex = 0;
        arcTokenIndex = 0;
        innerCoord;
        token;
        lineToken;
        arcToken;
        
        
    end
    
    methods (Access = 'private')
        function c = almostEqual(obj,a,b)
            tol = 0.00001;
            c = abs(a - b) < tol;
        end
        
        function FemmProblem = removeExtraNodes(obj)
            FemmProblem = obj.FemmProblem;
            % Remove one of the two overlapping nodes
            i = 2;
            while (i <= numel(FemmProblem.Nodes))
                h = 0;
                for j = 1:(i-1)
                    % x coordinates of two nodes:
                    xi = FemmProblem.Nodes(i).Coords(1);
                    xj = FemmProblem.Nodes(j).Coords(1);
                    % y coordinates of two nodes:
                    yi = FemmProblem.Nodes(i).Coords(2);
                    yj = FemmProblem.Nodes(j).Coords(2);
                    % Compare whether two nodes have the same coordinates                   
                    if (obj.almostEqual(xi, xj) && obj.almostEqual(yi, yj))
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
                                FemmProblem.Segments(k).n0 = ...
                                    FemmProblem.Segments(k).n0 - 1;         
                            end
                            if FemmProblem.Segments(k).n1 > (i-1)
                                FemmProblem.Segments(k).n1 = ...
                                    FemmProblem.Segments(k).n1 - 1;
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
                                FemmProblem.ArcSegments(k).n0 = ...
                                    FemmProblem.ArcSegments(k).n0 - 1;
                            end
                            if FemmProblem.ArcSegments(k).n1 > (i-1)
                                FemmProblem.ArcSegments(k).n1 = ...
                                    FemmProblem.ArcSegments(k).n1 - 1;
                            end
                        end
                        break
                    else
                        h = h + 1;
                    end
                end
                if h == i - 1
                    i = i + 1; % move to the next node  
                end
            end
        end
        
        function FemmProblem = removeExtraOverlappingSegments(obj)
            FemmProblem = obj.FemmProblem;
            % Remove one of the two ideally overlapping segments
            i = 2; 
            q = numel(FemmProblem.Segments);
            while (i <= q)
                h = 0;
                for j = 1:(i-1)
                    % Start and end node ids of the segment i 
                    n10 = FemmProblem.Segments(i).n0;
                    n11 = FemmProblem.Segments(i).n1;
                    % Start and end node ids of the segment j 
                    n20 = FemmProblem.Segments(j).n0;
                    n21 = FemmProblem.Segments(j).n1;     
                    % Compare whether two segments overlap
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
        end
        
        function FemmProblem = removeExtraOverlappingArcSegments(obj)
            FemmProblem = obj.FemmProblem;
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
                    if (n10 == n20 && n11 == n21 && ArcLength1 == ArcLength2)                      
                        FemmProblem.ArcSegments(i) = [];  
                        obj.arcInfo(i,:) = [];
                        q = q - 1;
                        break
                    else
                        h = h + 1;
                    end
                end
                if h == i - 1
                    i = i + 1; % move to the next segment
                end
            end            
        end
        
        function FemmProblem = removePartiallyOverlappingSegments(obj)
            del = 0.00001;
            FemmProblem = obj.FemmProblem;
            % Identify partially overlapping segments
            % Delete old segments
            % Make reconnections by adding new segments
            i = 2;
            q = numel(FemmProblem.Segments);
            while (i <= q)
                h = 0;
                for j = 1:(i-1)
                    % Find (x, y) coordinates of end nodes of segment i
                    p1 = FemmProblem.Segments(i).n0 + 1;
                    p2 = FemmProblem.Segments(i).n1 + 1;
                    x1 = FemmProblem.Nodes(p1).Coords(1);
                    y1 = FemmProblem.Nodes(p1).Coords(2);
                    x2 = FemmProblem.Nodes(p2).Coords(1);
                    y2 = FemmProblem.Nodes(p2).Coords(2);                    
                    % Find (x, y) coordinates of end nodes of segment j
                    p3 = FemmProblem.Segments(j).n0 + 1;
                    p4 = FemmProblem.Segments(j).n1 + 1; 
                    x3 = FemmProblem.Nodes(p3).Coords(1);
                    y3 = FemmProblem.Nodes(p3).Coords(2);
                    x4 = FemmProblem.Nodes(p4).Coords(1);
                    y4 = FemmProblem.Nodes(p4).Coords(2);
                    % Calculate k and b of each segment based on y = kx + b
                    k1 = (y2 - y1)/(x2 - x1);
                    k2 = (y4 - y3)/(x4 - x3);
                    b1 = y1 - k1*x1;
                    b2 = y3 - k2*x3;
                    p = [x1 y1 p1 - 1; x2 y2 p2 - 1; x3 y3 p3 - 1; x4 y4 p4 - 1];
                    
                    % Check if two segments partially overlap
                    % If lines are vertical, compare based on y coordinates
                    % of segments. If lines are other than vertical,
                    % compare based on the x coordinates of segments
                    if ((~((y3 <= y2 + del && y4 <= y2 + del && y3 <= y1 + del && y4 <= y1 + del) || ...
                            (y3 >= y2 - del && y4 >= y2 - del && y3 >= y1 - del && y4 >= y1 - del))) && ...
                            ((abs(k1) > 1e+9 && abs(k2) > 1e+9 && abs(x1 - x3) < del))) ||...
                            ((~((x3 <= x2 + del && x4 <= x2 + del && x3 <= x1 + del && x4 <= x1 + del) || ...
                            (x3 >= x2 - del && x4 >= x2 - del && x3 >= x1 - del && x4 >= x1 - del))) && ...
                            ((obj.almostEqual(k1,k2) && obj.almostEqual(b1,b2)) && abs(k1) < 1e+9 && abs(k2) < 1e+9))
                        
                        % Sort coordinates for new segments...
                        if (obj.almostEqual(x1,x2) && obj.almostEqual(x3,x4) ...
                                && obj.almostEqual(x1,x3))
                            p = sortrows(p,2); % ...based on y coordinates
                        else
                            p = sortrows(p,1); % ...based on x coordinates
                        end
                        % Delete old segments and make reconnections
                        % Add new three segments
                        FemmProblem.Segments(end+1) = FemmProblem.Segments(i);
                        FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
                        FemmProblem.Segments(end+1) = FemmProblem.Segments(j);
                        % Delete old two segments
                        FemmProblem.Segments(i) = [];
                        FemmProblem.Segments(j) = [];
                        % Specify end node coordinates for new segments:
                        % New segment 1:
                        FemmProblem.Segments(end-2).n0 = p(1,3);
                        FemmProblem.Segments(end-2).n1 = p(2,3);
                        % New segment 2:
                        FemmProblem.Segments(end-1).n0 = p(2,3);
                        FemmProblem.Segments(end-1).n1 = p(3,3);  
                        % New segment 3:
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
                    i = i + 1; % move to the next segment  
                end
            end
        end
        
        function FemmProblem = removePartiallyOverlappingArcSegments(obj)
            del = 0.00001;
            FemmProblem = obj.FemmProblem;
            % Identify partially overlapping arc segments
            % Delete old arc segments
            % Make reconnections by adding new arc segments
            i = 2;
            q = numel(FemmProblem.ArcSegments);
            while (i <= q)
                h = 0;
                for j = 1:(i-1)
                    % Find (x, y) coordinates of start node of arc i
                    p1 = FemmProblem.ArcSegments(i).n0 + 1;
                    p2 = FemmProblem.ArcSegments(i).n1 + 1;
                    x1 = FemmProblem.Nodes(p1).Coords(1);
                    y1 = FemmProblem.Nodes(p1).Coords(2);                    
                    % Find (x, y) coordinates of start node of arc j
                    p3 = FemmProblem.ArcSegments(j).n0 + 1;
                    p4 = FemmProblem.ArcSegments(j).n1 + 1; 
                    x3 = FemmProblem.Nodes(p3).Coords(1);
                    y3 = FemmProblem.Nodes(p3).Coords(2);
                    
                    % Extract radii and center coordinates of arcs i and j
                    R1 = obj.arcInfo(i,3);
                    R2 = obj.arcInfo(j,3);
                    centerxy1 = obj.arcInfo(i,1:2);
                    centerxy2 = obj.arcInfo(j,1:2);
                    % Find angle of start node of arc i wrt arc center
                    angle1 = angle((x1 - centerxy1(1)) + ...
                        1i*(y1 - centerxy1(2)))*180/pi;
                    % Find angle of start node of arc j wrt arc center
                    angle3 = angle((x3 - centerxy2(1)) + ...
                        1i*(y3 - centerxy2(2)))*180/pi;
                    
                    % If start node of one of the arcs is in the 3rd and 
                    % another is in the 4th quadrant, then make
                    % modifications so that the node in the 4th quadrant
                    % has larger angle (origin is arc center)
                    if (angle1 >= 90 && angle1 <= 180) && ...
                            (angle3 >= - 180 && angle3 <= - 90)
                        angle3 = angle3 + 360;
                    elseif (angle3 >= 90 && angle3 <= 180) && ...
                            (angle1 >= - 180 && angle1 <= - 90)
                        angle1 = angle1 + 360;
                    end
                    
                    % Find end node angle of arc i wrt arc center
                    angle2 = angle1 + FemmProblem.ArcSegments(i).ArcLength;
                    % Find end node angle of arc j wrt arc center
                    angle4 = angle3 + FemmProblem.ArcSegments(j).ArcLength;
                    
                    p = [angle1 p1 - 1; angle2 p2 - 1; angle3 p3 - 1; angle4 p4 - 1];
                    
                    % Check if two arc segments partially overlap
                    if (~((abs(angle3 <= angle2 + del && angle4 <= angle2 + del && ...
                            angle3 <= angle1 + del && angle4 <= angle1 + del) || ...
                            (angle3 >= angle2 - del && angle4 >= angle2 - del && ...
                            angle3 >= angle1 - del && angle4 >= angle1 - del))) && ...
                            ((obj.almostEqual(R1,R2) && ...
                            obj.almostEqual(centerxy1(1),centerxy2(1)) && ...
                            obj.almostEqual(centerxy1(2),centerxy2(2)))))
                        % Sort angles for new arc segments based on the
                        % angles of end nodes of arcs wrt arc center
                        p = sortrows(p,1);
                        
                        % Delete old arc segments and make reconnections
                        % Add three new arcs
                        FemmProblem.ArcSegments(end+1) = FemmProblem.ArcSegments(i);
                        FemmProblem.ArcSegments(end+1) = FemmProblem.ArcSegments(j);
                        FemmProblem.ArcSegments(end+1) = FemmProblem.ArcSegments(j);
                        obj.arcInfo(end+1,:) = obj.arcInfo(i,:);
                        obj.arcInfo(end+1,:) = obj.arcInfo(j,:);
                        obj.arcInfo(end+1,:) = obj.arcInfo(j,:);
                        % Remove two old arcs:
                        FemmProblem.ArcSegments(i) = [];
                        FemmProblem.ArcSegments(j) = [];
                        obj.arcInfo(i,:) = [];
                        obj.arcInfo(j,:) = [];
                        
                        % Specify end node coordinates and angles for new arcs:
                        % New arc 1:
                        FemmProblem.ArcSegments(end-2).n0 = p(1,2);
                        FemmProblem.ArcSegments(end-2).n1 = p(2,2);
                        FemmProblem.ArcSegments(end-2).ArcLength = p(2,1) - p(1,1);
                        % New arc 2:
                        FemmProblem.ArcSegments(end-1).n0 = p(2,2);
                        FemmProblem.ArcSegments(end-1).n1 = p(3,2);  
                        FemmProblem.ArcSegments(end-1).ArcLength = p(3,1) - p(2,1);
                        % New arc 3:
                        FemmProblem.ArcSegments(end).n0 = p(3,2);
                        FemmProblem.ArcSegments(end).n1 = p(4,2);
                        FemmProblem.ArcSegments(end).ArcLength = p(4,1) - p(3,1);
                        
                        q = numel(FemmProblem.ArcSegments);
                        
                        % Delete "zero" arc segments connecting the node to itself
                        r = 1;
                        while (r <= q)
                            n0 = FemmProblem.ArcSegments(r).n0;
                            n1 = FemmProblem.ArcSegments(r).n1;
                            if (n0 == n1)                        
                                FemmProblem.ArcSegments(r) = [];  
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
                    i = i + 1; % move to the next segment   
                end
            end
        end
        
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
        
        function plot(obj)
            plotfemmproblem(obj.FemmProblem);
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
            obj.lineTokenIndex = obj.lineTokenIndex + 1;
            obj.lineToken(obj.lineTokenIndex) = seginds;
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
            
            obj.arcTokenIndex = obj.arcTokenIndex + 1;
            obj.arcToken(obj.arcTokenIndex) = arcseginds;
        end
        
        function FemmProblem = removeOverlaps(obj)
            
            % Change each coordinate from being object to double
            for ii = 1:length(obj.FemmProblem.Nodes)
                obj.FemmProblem.Nodes(ii).Coords = double(obj.FemmProblem.Nodes(ii).Coords);
            end
            
            % Remove one of the overlapping nodes
            obj.FemmProblem = removeExtraNodes(obj);
            
            % Remove one of the two ideally overlapping segments
            obj.FemmProblem = removeExtraOverlappingSegments(obj);
            
            % Remove one of the two ideally overlapping arcs
            obj.FemmProblem = removeExtraOverlappingArcSegments(obj);
            
            % Remove partially overlapping segments and make reconnections
            obj.FemmProblem = removePartiallyOverlappingSegments(obj);
            
            % Remove partially overlapping arcs and make reconnections
            obj.FemmProblem = removePartiallyOverlappingArcSegments(obj);

            % Return modified FemmProblem struct
            FemmProblem = obj.FemmProblem;
        end
        
        
        function select(obj)

        end
        % Add block label and assign material
        function new = revolve(obj, name, material, center, axis, angle)
            validateattributes(depth, {'double'}, {'nonnegative', 'nonempty'});
            validateattributes(material, {'char'}, {'nonempty'});
            validateattributes(name, {'char'}, {'nonempty'}); 
            
            obj.FemmProblem = addmaterials_mfemm(obj.FemmProblem, material);
            obj.FemmProblem = addblocklabel_mfemm(obj.FemmProblem, ...
                obj.innerCoord(1), obj.innerCoord(2), ...
                                   'BlockType', material); 
        end
        % Add block label and assign material
        function extrude(obj, name, material, depth, tok)
            validateattributes(depth, {'double'}, {'nonnegative', 'nonempty'});
            validateattributes(material, {'char'}, {'nonempty'});
            validateattributes(name, {'char'}, {'nonempty'}); 
            
            obj.FemmProblem = addmaterials_mfemm(obj.FemmProblem, material);
            obj.FemmProblem = addblocklabel_mfemm(obj.FemmProblem, ...
                obj.innerCoord(1), obj.innerCoord(2), ...
                                   'BlockType', material);          
        end
        % Save information about inner coordinates of the cross-section
        function prepareSection(obj, csToken)
            validateattributes(csToken, {'CrossSectToken'}, {'nonempty'});
            obj.innerCoord = double(csToken.innerCoord);
        end
        
        % Set group number to nodes and block label
        function setGroupNumber(obj, groupNumber)
            % Set group number to nodes
            for i = 1:length(obj.lineToken)
                n0 = obj.FemmProblem.Segments(obj.lineToken(i)).n0 + 1;
                obj.FemmProblem.Nodes(n0).InGroup = groupNumber;
                n1 = obj.FemmProblem.Segments(obj.lineToken(i)).n1 + 1;
                obj.FemmProblem.Nodes(n1).InGroup = groupNumber;
            end
            
            for i = 1:length(obj.arcToken)
                n0 = obj.FemmProblem.ArcSegments(obj.arcToken(i)).n0 + 1;
                obj.FemmProblem.Nodes(n0).InGroup = groupNumber;
                n1 = obj.FemmProblem.ArcSegments(obj.arcToken(i)).n1 + 1;
                obj.FemmProblem.Nodes(n1).InGroup = groupNumber;
            end        
            obj.lineToken = [];
            obj.arcToken = [];
            obj.lineTokenIndex = 0;
            obj.arcTokenIndex = 0;
            
            % Set group number to block labels
            for i = 1:length(obj.FemmProblem.BlockLabels)
                innerCoords(i) = obj.FemmProblem.BlockLabels(i).Coords(1) + ...
                    1i*obj.FemmProblem.BlockLabels(i).Coords(2);
            end
            givenCoord = obj.innerCoord(1) + 1i*obj.innerCoord(2);
            [x, n] = min(abs(givenCoord - innerCoords));
            obj.FemmProblem.BlockLabels(n).InGroup = groupNumber;
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
            validateProps@DrawerBase(obj);
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