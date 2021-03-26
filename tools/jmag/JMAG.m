classdef JMAG < ToolBase & DrawerBase & MakerExtrudeBase & MakerRevolveBase
    %JMAG Encapsulation for the JMAG Designer of JSOL Corporation.
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'public', SetAccess = 'public')        
        jd;  % The activexserver object for JMAG Designer
        projName = 'proj'; % The name of JMAG Designer project (a string)
        geometryEditor; % The Geometry Editor object
        doc; % The document object in Geometry Editor
        assembly; % The assembly object in Geometry Editor
        sketch; % The sketch object in Geometry Editor
        part; % The part object in Geometry Editor
        model; % The model object in JMAG Designer
        study; % The study object in JMAG Designer
        view;  % The view object in JMAG Designer
        defaultLength = 'DimMeter'; % Default length unit is m
        defaultAngle = 'DimDegree'; % Default angle unit is degrees
        visible = true; % Visibility
        workDirectory = pwd;
        fileName;
        sketchList;
    end
    

    methods
        function obj = JMAG(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();
            obj.jd = actxserver('designer.Application');
            if obj.visible
                obj.jd.Show();
            else
                obj.jd.Hide();
            end
        end
        
        
        function obj = open(obj, fileName)
            %OPEN Open JMAG Designer or a specific file.
            %   open() opens a new instance of JMAG Designer with a new document.
            %   open(fileName) opens an existing JMAG document. 
            %   fileName is a string that specifies the complete path to the file.          
            if ~exist('fileName', 'var')
                obj.jd.NewProject(obj.projName);
                obj.saveAs(strcat(obj.workDirectory, '\temp.jproj'));
            else
                obj.jd.Open(fileName);
            end
            obj.view = obj.jd.View();
        end

        
         function saveAs(obj, fileName)
            % SAVEAS Save the JMAG document.
            % fileName is a string that specifies the complete path to the file.
            obj.fileName = fileName;
            obj.save();
         end
         
         
        function save(obj)
            % SAVE Saves the JMAG document in the specified path
            if isempty(obj.fileName)
                error('Unable to save file. Use the saveAs( ) function');
            else
                obj.jd.SaveAs(obj.fileName);
            end        
        end
        
        
        function obj = close(obj)
            % CLOSE Closes the JMAG document
            % close()
        end
        
        
        function obj = delete(obj)
            % DELETE Closes the JMAG application
            % delete()
            obj.jd.Quit();
        end
        
        
        function [tokenDraw] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            if isnumeric(obj.sketch)
                obj.sketch = obj.getSketch(0);
                obj.sketch.OpenSketch();
            end
            
            % Convert to default units
            startxy = double(feval(obj.defaultLength, startxy));
            endxy = double(feval(obj.defaultLength, endxy));             
            
            line = obj.sketch.CreateLine(startxy(1),startxy(2),endxy(1),endxy(2));
            tokenDraw = TokenDraw(line, 0);
        end
        
        
        function [tokenDraw] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current JMAG document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            
            if isnumeric(obj.sketch)
                obj.sketch = obj.getSketch(0);
                obj.sketch.OpenSketch();
            end
            
            % Convert to default units
            centerxy = double(feval(obj.defaultLength, centerxy));
            startxy = double(feval(obj.defaultLength, startxy));
            endxy = double(feval(obj.defaultLength, endxy));     
            
            obj.sketch.CreateVertex(startxy(1), startxy(2));
            obj.sketch.CreateVertex(endxy(1), endxy(2));
            obj.sketch.CreateVertex(centerxy(1), centerxy(2));
            arc = obj.sketch.CreateArc(centerxy(1), centerxy(2), ...
                                        startxy(1), startxy(2), ...
                                        endxy(1), endxy(2));
            tokenDraw = TokenDraw(arc, 1);
        end
        
        
        function geometryEditor = checkGeomEditor(obj)
            if ~isnumeric(obj.geometryEditor)
            else
                obj.jd.LaunchGeometryEditor();
                obj.geometryEditor = obj.jd.CreateGeometryEditor(true);
                obj.doc = obj.geometryEditor.NewDocument();                
            end
            geometryEditor = obj.geometryEditor;
        end
        
        
        function sketch = getSketch(obj, Sketch, varargin)
            if isnumeric(Sketch)
                sketchName = strcat('mySketch', num2str(Sketch));
            else
                sketchName = Sketch;
            end

            for i = 1:length(obj.sketchList)
                if obj.sketchList(i) == sketchName
                    obj.sketch = obj.assembly.GetItem(sketchName);
                    % open sketch for drawing (must be closed before switch to another sketch)
                    obj.sketch.OpenSketch();
                    sketch = obj.sketch;
                    return
                end
            end
            if i == length(obj.sketchList)
                obj.sketchList(end) = sketchName;
            end
            
            obj.geometryEditor = obj.checkGeomEditor();
            obj.doc = obj.geometryEditor.GetDocument();
            obj.assembly = obj.doc.GetAssembly();
            ref1 = obj.assembly.GetItem('XY Plane');
            ref2 = obj.doc.CreateReferenceFromItem(ref1);
            obj.sketch = obj.assembly.CreateSketch(ref2);
            obj.sketch.SetProperty('Name', sketchName)
            if nargin>2
                obj.sketch.SetProperty('Color', varargin);
            end         
            % Creating part from sketch
            obj.sketch.OpenSketch();
            ref1 = obj.assembly.GetItem(sketchName);
            ref2 = obj.doc.CreateReferenceFromItem(ref1);
            obj.assembly.MoveToPart(ref2);
            obj.part = obj.assembly.GetItem(sketchName);
            sketch = obj.sketch;
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
        
        
        function revolvePart = revolve(obj, name, material, center, axis, angle, csToken)
            %REVOLVE Revolve a cross-section along an arc    
            %new = revolve(obj, name, material, center, axis, angle)
            %   name  - name of the newly revolved component
            %   center - x,y coordinate of center point of rotation
            %   axis   - x,y coordinate on the axis of ration (negative reverses
            %             direction) (0, -1) to rotate clockwise about the y axis
            %   angle  - Angle of rotation (dimAngular) 
            
            % Convert to default units
            center = double(feval(obj.defaultLength, center));
            axis = double(feval(obj.defaultLength, axis));
            angle = double(feval(obj.defaultAngle, angle));
            
            % Revolve
            ref1 = obj.sketch;
            revolvePart = obj.part.CreateRevolveSolid(ref1);
            obj.part.GetItem('Revolve').SetProperty('SpecifiedRatio', 1);
            obj.part.GetItem('Revolve').SetProperty('AxisType','1');
            obj.part.GetItem('Revolve').SetProperty('AxisPosX',center(1));
            obj.part.GetItem('Revolve').SetProperty('AxisPosY',center(2));
            obj.part.GetItem('Revolve').SetProperty('AxisVecX',axis(1));
            obj.part.GetItem('Revolve').SetProperty('AxisVecY',axis(2));
            obj.part.GetItem('Revolve').SetProperty('AxisVecZ',0);
            obj.part.GetItem('Revolve').SetProperty('Angle',angle);
            obj.part.SetProperty('Name', name)
            sketchName = strcat(name,'Sketch');
            obj.sketch.SetProperty('Name', sketchName)

            % Import Model into Designer
            obj.sketch = 0;
            obj.doc.SaveModel(true)
            
            if obj.study == 0
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(obj.projName)
                % Create study
                obj.study = obj.model.CreateStudy('Transient', obj.projName);
            else
                % Delete old model
                obj.jd.DeleteModel(obj.projName)
                % Setup the new model
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(obj.projName)
                obj.study = obj.model.GetStudy(obj.projName);
            end
            
            % Set to default units
            obj.setDefaultLengthUnit(obj.defaultLength)
            obj.setDefaultAngleUnit(obj.defaultAngle)
            
            % Add material
            obj.study.SetMaterialByName(name, material)
        end
        
        
        function extrudePart = extrude(obj, name, material, depth, csToken)
            %EXTRUDE Extrude a cross-section    
            %new = extrude(obj, name, material, depth, csToken)
            %   name  - name of the newly extruded component
            %   depth  - Depth of extrusion (dimLinear) 
            
           % Convert to default units
           depth = feval(obj.defaultLength, depth);
           
           % Extrude
            ref1 = obj.sketch;
            extrudePart = obj.part.CreateExtrudeSolid(ref1,double(depth));
            obj.part.SetProperty('Name', name)
            sketchName = strcat(name,'Sketch');
            obj.sketch.SetProperty('Name', sketchName)
            
            % Import Model into Designer
            obj.sketch = 0;
            obj.doc.SaveModel(true)
            
            if obj.study == 0
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(obj.projName)
                % Create study
                obj.study = obj.model.CreateStudy('Transient', obj.projName);
            else
                % Delete old model
                obj.jd.DeleteModel(obj.projName)
                % Setup the new model
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(obj.projName)
                obj.study = obj.model.GetStudy(obj.projName);
            end
            
            % Set to default units
            obj.setDefaultLengthUnit(obj.defaultLength)
            obj.setDefaultAngleUnit(obj.defaultAngle)
            
            % Add material
            obj.study.SetMaterialByName(name, material)
        end
        
        
        function sketch = prepareSection(obj, csToken)
            % PREPARESECTION Prepares section from drawing for extrude / revolve.
            % sketch = prepareSection(obj, csToken)
            % PREPARESECTION creates JMAG geometry regions using lines and arcs.
            % Only the region to be extruded / revolved is retained, and the rest are deleted.
            validateattributes(csToken, {'CrossSectToken'}, {'nonempty'});
            obj.doc.GetSelection().Clear();
            for i = 1:length(csToken.token)
                obj.doc.GetSelection().Add(obj.sketch.GetItem(csToken.token(i).drawToken.GetName()));
            end
            id = obj.sketch.NumItems();
            obj.sketch.CreateRegions();
            id2 = obj.sketch.NumItems();
            visItem = 1; % Set 1 to select only the visible (top layer) item
            itemType = 64; % Set 64 for region.
            innerCoord1 = csToken.innerCoord(1);
            innerCoord2 = csToken.innerCoord(2);
            innerCoord1 = feval(obj.defaultLength, innerCoord1);
            innerCoord2 = feval(obj.defaultLength, innerCoord2);
            obj.geometryEditor.View.SelectAtCoordinateDlg(double(innerCoord1), ...
                double(innerCoord2), 0, visItem, itemType);
            region = obj.doc.GetSelection.Item([0]);
            regionName = region.GetName;            
            
            regionList{1} = 'Region';
            for idx = 2:id2-id
                regionList{idx} = sprintf('Region.%d',idx);
            end
            
            for idx = 1:id2-id
                if ~strcmp(regionList{idx}, regionName)
                    obj.doc.GetSelection().Clear();
                    obj.doc.GetSelection().Add(obj.sketch.GetItem(regionList{idx}));
                    obj.doc.GetSelection().Delete();
                end
            end          
            obj.sketch.CloseSketch();
            sketch = 1;
        end        
        
        
        function setDefaultLengthUnit(obj, userUnit)
            %SETDEFAULTLENGTHUNIT Set the default unit for length.
            %   setDefaultLengthUnit(userUnit)
            %       Sets the units for length. 
            %   userUnit can be set to meters
  
            if strcmp(userUnit, 'DimMeter')
                obj.defaultLength = userUnit;
                obj.model.SetUnitCollection('SI_units')
            else
                error('unsupported length unit')
            end
        end
        
        function setDefaultAngleUnit(obj, userUnit)
            %SETDEFAULTANGLEUNIT Set the default unit for angle.
            %   setDefaultAngleUnit(userUnit)
            %       Sets the units for angle. 
            %   userUnit can be set to degrees
  
            if strcmp(userUnit, 'DimDegree')
                obj.defaultAngle = userUnit;
                obj.model.SetUnitCollection('SI_units')
            else
                error('unsupported angle unit')
            end
        end
        
        
        function setVisibility(obj, visibile)
            % SETVISIBILITY Set visibility of the JMAG application
            % setVisibility(obj, visibile)
            obj.visible = visibile;
            if obj.visible
                obj.jd.Show();
            else
                obj.jd.Hide();
            end
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