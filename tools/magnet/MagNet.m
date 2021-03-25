classdef MagNet < ToolBase & DrawerBase & MakerExtrudeBase & MakerRevolveBase
    %MAGNET Encapsulation for the MagNet FEA software
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'public', SetAccess = 'private')
        mn;  % MagNet activexserver object
        doc; % Document object
        view; % View object
        consts; %Program constants
        defaultLength = 'DimMillimeter';
        defaultAngle  = 'DimDegree';
        visible = 0;% visibility
        fileName; % Name of the MagNet document
    end

    
    methods
        function obj = MagNet(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();        
            obj.mn = actxserver('MagNet.Application');
            set(obj.mn, 'Visible', obj.visible);
        end
                
         function open(obj, fileName)
            %OPEN Open MagNet
            %   open() opens a new instance of MagNet with a new document.
            %   open(fileName) opens an existing MagNet document. 
            %   fileName is a string that specifies the complete path to the file.  
            if ~exist('fileName', 'var')
                obj.doc = invoke(obj.mn, 'newDocument');
            else
                obj.doc = invoke(obj.mn, 'openDocument', fileName);
                obj.fileName = fileName;
            end
                obj.view = invoke(obj.doc, 'getview');
                obj.consts = invoke(obj.mn, 'getConstants');
                obj.setDefaultLengthUnit(obj.defaultLength, false);
         end
        
         function saveas(obj, fileName)
            % SAVEAS Save the MagNet document.
            % fileName is a string that specifies the complete path to the file.
            invoke(obj.mn, 'processcommand',...
                     sprintf('Call getDocument().save("%s")',fileName));
            obj.fileName = fileName;
         end
         
         function save(obj)
            % SAVE Save the MagNet document.
            invoke(obj.mn, 'processcommand',...
                     sprintf('Call getDocument().save("%s")',obj.fileName));
         end
         
         
        function close(obj)
           % CLOSE Closes the MagNet document
           invoke (obj.mn, 'processcommand','Call getDocument().close(False)');
        end
        
        function delete(obj)
           % DELETE Closes the MagNet application
            invoke(obj.mn, 'processcommand','call close(False)');
        end
        
        function setCores(obj, numCores)
            %SETCORES Sets the number of cores
            %setCores(numCores) sets the numCores number of cores
            
            cores = sprintf('Call getDocument().setNumberOfMultiCoreSolveThreads(%i)',numCores);           
            invoke(obj.mn, 'processcommand', cores);
        end

        function [tokenDraw] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line in the current MagNet document.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line
            %
            %   This is a wrapper for the Document::View::newLine function.
            startxy = feval(obj.defaultLength, startxy);
            endxy = feval(obj.defaultLength, endxy);     
            invoke (obj.mn, 'processcommand', 'redim line(0)');
            invoke (obj.mn, 'processcommand', sprintf(...
                'call getDocument.getView.newLine( %f, %f, %f, %f, line)', ...    
                startxy(1), startxy(2), ...
                endxy(1), endxy(2)) ...
            );

            if nargout > 0
                invoke(obj.mn, 'processcommand', 'call setvariant(0, line, "matlab")');
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
            centerxy = feval(obj.defaultLength, centerxy);
            startxy = feval(obj.defaultLength, startxy);
            endxy = feval(obj.defaultLength, endxy);
            endxy = feval(obj.defaultLength, endxy);     
            invoke (obj.mn, 'processcommand', 'redim arc(0)');
            invoke (obj.mn, 'processcommand', sprintf(...
                'call getDocument.getView.newArc(%f, %f, %f, %f, %f, %f, arc)', ...
                centerxy(1), centerxy(2), ...
                startxy(1), startxy(2), ...
                endxy(1), endxy(2)));

            if nargout > 0
                invoke(obj.mn, 'processcommand', 'call setvariant(0, arc, "matlab")');
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
            validateattributes(center, {'numeric'}, {'size',[1,2]});
            validateattributes(axis, {'numeric'}, {'size',[1,2]});
            validateattributes(angle, {'DimAngular'}, {'nonempty'});
            flags(1) = get(obj.consts, 'infoMakeComponentRemoveVertices');  
            axis = feval(obj.defaultLength, axis);
            center = feval(obj.defaultLength, center);
            angle = feval(obj.defaultAngle, angle);
            new = mn_dv_makeComponentInAnArc(obj.mn, center, axis, ...
                    angle, name, material, flags);
        end
        
        function new = extrude(obj, name, material, depth, token)
            validateattributes(depth, {'double'}, {'nonnegative', 'nonempty'});
            validateattributes(material, {'char'}, {'nonempty'});
            validateattributes(name, {'char'}, {'nonempty'});
            flags(1) = get(obj.consts, 'infoMakeComponentRemoveVertices');  
            depth = feval(obj.defaultLength, depth);
            new = mn_dv_makeComponentInALine(obj.mn, depth, name, ...
                material, flags); 
        end
        
        function new = prepareSection(obj, csToken)
            
            validateattributes(csToken, {'CrossSectToken'}, {'nonempty'});
            seltype = get(obj.consts,'InfoSetSelection');
            objcode = get(obj.consts,'infoSliceSurface');
            innerCoord = csToken.innerCoord;
            innerCoord = feval(obj.defaultLength, innerCoord);
            mn_dv_selectat(obj.mn, innerCoord, seltype, objcode);
            new = 1;
        end
        
        function setDefaultLengthUnit(obj, userUnit, makeAppDefault)
            %SETDEFAULTLENGTHUNIT Set the default unit for length.
            %   setDefaultLengthUnit(userUnit, makeAppDefault)
            %       Sets the units for length. 
            %   userUnit can be one of these options:
            %       'DimMillimeter'
            %       'DimInch'
            %
            %   This is a wrapper for Document::setDefaultLengthUnit

            %update length unit type, this is needed for unit conversions
            %in extruding/drawing/moving/etc. (not yet implemented).
            if strcmp(userUnit,'DimMillimeter')
                appUnit = 'millimeters';
            elseif strcmp(userUnit, 'DimInches')
                appUnit = 'inches';
            else
                error('unsupported length unit')
            end
            
            invoke(obj.doc, 'setDefaultLengthUnit', appUnit, makeAppDefault);
        end
        
        function viewAll(obj)
            %VIEWALL View the entire model
            %   viewAll()

            invoke(obj.mn, 'processcommand', 'Call getDocument().getView().viewAll()');
        end
        
        
        function setVisibility(obj, visible)
            %SETVISIBLE Sets visibility of MagNet application
            %    Set visible= 'true' or visible = 1 to make the MagNet
            %    session visible. Set visible= 'false' or visible = 0 to 
            %    make the MagNet session invisible.  
            set(obj.mn, 'Visible', visible);
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