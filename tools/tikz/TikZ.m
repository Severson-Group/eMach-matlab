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
                % Return value must be a single quantity, i.e. not a matrix
                % or array value. Strings cannot be returned from here!
                line = 1;
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
            y2 = endxy(2);

            % Need to calculate: x, y, start, stop, radius...
            
            x = x1;
            y = y1;
            
            radius = sqrt((x1 - h)^2 + (y1 - k)^2);
            
            % These are both "correct" ways of determining start variable,
            % but only one works depending on orientation of arc. Hacks
            % below help solve this issue.
            %
            start = acos((x1 - h) / radius); 
            start2 = asin((y1 - k) / radius);
            
            stop = acos((x2 - h) / radius);
            
            % ----------
            % HACKS START
            % ----------
            
            % The code in this "hack" section is special cases for drawing
            % an arc... This involves mostly cases where x1==x2 or
            % y1==y2. I have not proved these are the correct solutions,
            % but I have tried many arcs using various stator geometries
            % and it seems to work for all cases...  ¯\_(?)_/¯
            
            if (start > stop)
               start = -start;
               stop = -stop;
            end
            
            % Trying to check for start == stop.
            % BUT, issues with rounding and floating numbers....
            % Using this delta comparison fixes one silly case where
            % rounding causes issues for direct comparison for equality...
            % 
            % Silly!
            %
            if (abs(start - stop) < 0.0000001)
                if (y1-k < 0)
                    start = -start;
                elseif (x1-h < 0)
                    stop = start + (2 * start2);
                end
            end
            
            % --------
            % HACKS END
            % --------
            
            fmt = '\\draw[black] (%12.8f,%12.8f) arc (%12.8f:%12.8f:%12.8f);\n';
            fprintf(obj.file, fmt, ...
                x, y, ...
                rad2deg(start), rad2deg(stop), radius ...
            );
        
            if nargout > 0
                % Return value must be a single quantity, i.e. not a matrix
                % or array value. Strings cannot be returned from here!
                arc = 1;
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