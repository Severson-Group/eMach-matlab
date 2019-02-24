classdef TikZ < ToolBase & Drawer2dBase
    %TIKZ Encapsulation for TikZ graphics
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'private', SetAccess = 'private')
        file; % File to write TikZ commands
    end
    
    methods
        function obj = TikZ(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function obj = open(obj, filename)
            % OPEN Opens a TikZ drawing
            %     open('output.txt')
            %
            % NOTE: This will erase existing file contents
            %       and overwrite with new data!
            
            obj.file = fopen(filename, 'w');

            fprintf(obj.file, '\\documentclass[border=10pt]{standalone}\n');
            fprintf(obj.file, '\\usepackage{tikz}\n');
            fprintf(obj.file, '\\begin{document}\n');
            fprintf(obj.file, '\\begin{tikzpicture}\n');
        end
        
        function close(obj)
            % CLOSE Closes TikZ drawing
            
            fprintf(obj.file, '\\end{tikzpicture}\n');
            fprintf(obj.file, '\\end{document}\n');
            fclose(obj.file);
        end

        function [line] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line in the current TikZ graphic.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            fprintf(obj.file, '\\draw[black] (%12.8f,%12.8f) -- (%12.8f,%12.8f);\n', ...
                startxy(1), startxy(2), ...
                endxy(1), endxy(2) ...
            );
        
            if nargout > 0
                line = '==TikZ_Line_Object==';
            end
        end
        
        function [arc] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current TikZ graphic.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            
            % Extract and rename variables for processing
            h = centerxy(1);
            k = centerxy(2);
            x1 = startxy(1);
            y1 = startxy(2);
            x2 = endxy(1);
%            y2 = endxy(2);

            % Need to calculate: x, y, start, stop, radius...
            
            x = x1;
            y = y1;
            
            radius = sqrt((x1 - h)^2 + (y1 - k)^2);
            
            % TODO: there is a corner case here... angle sign changes
            % and using first vs. second equation changes answer...
            % Need to look into this...
            %
            % i.e., both equations should give same answer, but sign
            % changes sometimes under corner cases
            
%            start = acos((x1 - h) / radius);
            start = asin((y1 - k) / radius);
            
            stop = acos((x2 - h) / radius);
            
            fmt = '\\draw[black] (%12.8f,%12.8f) arc (%12.8f:%12.8f:%12.8f);\n';
            fprintf(obj.file, fmt, ...
                x, y, ...
                rad2deg(start), rad2deg(stop), radius ...
            );
        
            if nargout > 0
                arc = '==TikZ_Arc_Object==';
            end
        end
        
        function select(obj)
            %SELECT Selects something from canvas (?)
            %    select()
            
            % This function doesn't mean anything for TikZ...
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