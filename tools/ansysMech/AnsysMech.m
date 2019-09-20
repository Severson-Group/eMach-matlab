classdef AnsysMech < ToolBase & DrawerBase
    %AnsysMech Encapsulation for the Ansys Mechanical FEA software
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'public', SetAccess = 'private')
        iCoMapdlUnit;  %Ansys server object
    end
    
    methods
        function obj = AnsysMech(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function obj = open(obj, scratch_path)%, job_name)
            
            %scratch_path is folder where ansys writes to as well as places
            %server key

            %This code starts up the server from matlab... it is not
            %working yet and the server must be started from the mechanical
            %apdl launcher with the -aas parameter specified under the
            %additional parameters section
            
%             exec_path = '"C:\Program Files\ANSYS Inc\v190\ansys\bin\winx64\MAPDL.exe"';
%             job_flag = sprintf('-j %s', job_name);
%             misc_flags = ' -p aa_r -np 2 -lch -s read -l en-us -aas -t -d win32';
%             dir_flag = sprintf('-dir "%s"', scatch_path);
%             
%             cmd_str = sprintf('%s %s %s %s', exec_path, dir_flag, job_flag, misc_flags);
%             system(cmd_str); %start ansys in as a server (aaS) mode
            
            orb = initialize_orb(); %this function comes from ansys matlab toolbox
            load_ansys_aas; %aas stands for ansys as a server
            key_str = sprintf('"%s"\aaS_MapdlId.txt', scratch_path);
            obj.iCoMapdlUnit = actmapdlserver(orb, key_str);
            
        end
        
        function close(obj)
           % CLOSE Closes MagNet application
           %     close()
           
           % TODO:
           % Implement this...
        end

        function [tokenDraw] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line in the current MagNet document.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line
            %
            %   This is a wrapper for the Document::View::newLine function.
  
            invoke (obj.mn, 'processcommand', 'redim line(0)');
            invoke (obj.mn, 'processcommand', sprintf(...
                'call getDocument.getView.newLine( %f, %f, %f, %f, line)', ...    
                startxy(1), startxy(2), ...
                endxy(1), endxy(2)) ...
            );

            if nargout > 0
                invoke(obj.mn, 'processcommand', 'call setvariant(0, line, "matlab")')
                line = invoke(obj.mn, 'getvariant', 0, 'matlab');
                tokenDraw = TokenDraw(line, 0);
            end
        end
        
        function [tokenDraw] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current MagNet document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            %
            %   This is a wrapper for the Document::View::newArc function.

            invoke (obj.mn, 'processcommand', 'redim arc(0)')
            invoke (obj.mn, 'processcommand', sprintf(...
                'call getDocument.getView.newArc(%f, %f, %f, %f, %f, %f, arc)', ...
                centerxy(1), centerxy(2), ...
                startxy(1), startxy(2), ...
                endxy(1), endxy(2)));

            if nargout > 0
                invoke(obj.mn, 'processcommand', 'call setvariant(0, arc, "matlab")')
                arc = invoke(obj.mn, 'getvariant', 0, 'matlab');   
                tokenDraw = TokenDraw(arc, 1);
            end   
        end
        
        function select(obj)
            %SELECT Selects something from canvas (?)
            %    select()
            
            % TODO:
            % Implement this...
            %
            % This will need to take in arguments, or maybe
            % CrossSect objects which then store internally all their
            % lines and surfaces that need to be selected
        end
        
        function new = revolve(obj, name, material, center, axis, angle, token)
            %REVOLVE Revolve a cross-section along an arc    
            %new = revolve(obj, name, material, center, axis, angle)
            %   name   - name of the newly extruded component
            %   center - x,y coordinate of center point of rotation
            %   axis   - x,y coordinate on the axis of ration (negative reverses
            %             direction) (0, -1) to rotate clockwise about the y axis
            %   angle  - Angle of rotation (dimAngular) 
            
            
            validateattributes(material, {'char'}, {'nonempty'});
            validateattributes(name, {'char'}, {'nonempty'});            
            validateattributes(center, {'numeric'}, {'size',[1,2]})
            validateattributes(axis, {'numeric'}, {'size',[1,2]})
            validateattributes(angle, {'DimAngular'}, {'nonempty'});
            flags(1) = get(obj.consts, 'infoMakeComponentRemoveVertices');  
            
            %TODO: Convert center and axis to the appropriate default unit.
            
            new = mn_dv_makeComponentInAnArc(obj.mn, center, axis, ...
                    angle.toDegrees(), name, material, flags);
        end
        
        function new = extrude(obj, name, material, depth, token)
            validateattributes(depth, {'double'}, {'nonnegative', 'nonempty'});
            validateattributes(material, {'char'}, {'nonempty'});
            validateattributes(name, {'char'}, {'nonempty'});
            flags(1) = get(obj.consts, 'infoMakeComponentRemoveVertices');  
            
            %TO DO: Convert center and axis to the appropriate default unit.
            new = mn_dv_makeComponentInALine(obj.mn, depth, name, ...
                material, flags); 
        end
        
        function new = prepareSection(obj, csToken)
            
            validateattributes(csToken, {'CrossSectToken'}, {'nonempty'});
            seltype = get(obj.consts,'InfoSetSelection');
            objcode = get(obj.consts,'infoSliceSurface');
            
            %TO DO: how to deal with the units of the coordinate?? 
            mn_dv_selectat(obj.mn, csToken.innerCoord, seltype, objcode);
            new = 1;
        end
        
        function setDefaultLengthUnit(obj, userUnit, makeAppDefault)
            %SETDEFAULTLENGTHUNIT Set the default unit for length.
            %   setDefaultLengthUnit(userUnit, makeAppDefault)
            %       Sets the units for length. 

            %   userUnit can be one of these options:
            %       'kilometers'
            %       'meters'
            %       'centimeters'
            %       'millimeters'
            %		'microns'
            %		'miles'
            %		'yards'	
            %		'feet'
            %       'inches'
            %
            %   This is a wrapper for Document::setDefaultLengthUnit

            %update length unit type, this is needed for unit conversions
            %in extruding/drawing/moving/etc. (not yet implemented).
            if strcmp(userUnit, 'millimeters')
                obj.defaultLength = 'DimMillimeter';
            elseif strcmp(userUnit, 'inches')
                obj.defaultLength = 'DimInches';
            else
                error('unsupported length unit')
            end
            
            invoke(obj.doc, 'setDefaultLengthUnit', userUnit, makeAppDefault);
        end
        
        function viewAll(obj)
            %VIEWALL View the entire model
            %   viewAll()

            invoke(obj.mn, 'processcommand', 'Call getDocument().getView().viewAll()');
        end
        
        
        function setVisibility(obj, visibility)
            %SETVISIBLE Sets visibility of MagNet application
            %    setVisibility(true)
            
            set(obj.mn, 'Visible', visibility);
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