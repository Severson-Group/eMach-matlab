classdef JMAG_Designer < ToolBase & DrawerBase & MakerExtrudeBase & MakerRevolveBase
    %JMAG Encapsulation for the JMAG Designer of JSOL Corporation.
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'public', SetAccess = 'public')        
        jd;  % The activexserver object for JMAG Designer
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
        fileName;
    end
    

    methods
        function obj = JMAG_Designer(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();
            % Keep track of number of instance called
            persistent numInstance
            if isempty(numInstance)
                numInstance = 1;
            end
            % Obtain instance of JMAG designer application
            jdInstance = actxserver('designerstarter.InstanceManager');
            obj.jd = jdInstance.GetNamedInstance(string(numInstance), 0); % Creates a new instance and returns the handle
            numInstance = numInstance + 1;
            obj.setVisibility(obj.visible)
        end
        
        
        function obj = open(obj, fileName)
            %OPEN Open JMAG Designer or a specific file.
            %   open(fileName) opens an JMAG document. 
            %   fileName is a string that specifies the complete path to the file.
            if ~exist('fileName', 'var')
                obj.jd.NewProject('untitled');
                obj.saveAs('untitled'); % JMAG requires it to be saved before creating geometry 
            elseif ~exist(fileName, 'file')
                obj.jd.NewProject(fileName);
                obj.saveAs(fileName);
                obj.fileName = fileName;
            else
                obj.jd.Load(fileName);
                obj.fileName = fileName;
            end
            obj.view = obj.jd.View();
            obj.geometryEditor = obj.jd.CreateGeometryEditor(true);
            obj.doc = obj.geometryEditor.NewDocument();
            obj.assembly = obj.doc.GetAssembly();
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
            % JMAG doesn't have the notion of document close()
            % So close() prevents edits by any future function calls,
            % so it opens a new untitled document.
            %
            % close() 
            obj.open()
        end
        
        
        function obj = delete(obj)
            % DELETE Closes the JMAG application
            % delete()
            obj.jd.Quit();
        end
        
        
        function [tokenDraw] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            if isempty(obj.part)
                obj.part = obj.createPart();
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
            
            if isempty(obj.part)
                obj.part = obj.createPart();
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
        
        
        function part = createPart(obj)
            %CREATEPART Creates a new part in geometry editor
            %part = createPart()
            
            % Creating a new sketch
            ref1 = obj.assembly.GetItem('XY Plane');
            ref2 = obj.doc.CreateReferenceFromItem(ref1);
            obj.sketch = obj.assembly.CreateSketch(ref2);
            partName = 'partDrawing';
            obj.sketch.SetProperty('Name', partName)
            
            % Creating part from sketch
            obj.sketch.OpenSketch();
            ref1 = obj.assembly.GetItem(partName);
            ref2 = obj.doc.CreateReferenceFromItem(ref1);
            obj.assembly.MoveToPart(ref2);
            part = obj.assembly.GetItem(partName);
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
            sketchName = strcat(name,'_sketch');
            obj.sketch.SetProperty('Name', sketchName)

            % Making part property empty after creating component
            obj.part = [];
            % Import Model into Designer
            obj.doc.SaveModel(true)
            modelName = strcat(name,'_model');
            studyName = strcat(name,'_study');
            
            % Create a study
            obj.study = obj.createStudy(studyName, modelName);
            
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
            sketchName = strcat(name,'_sketch');
            obj.sketch.SetProperty('Name', sketchName)
            
            % Making part property empty after creating component
            obj.part = [];   
            % Import Model into Designer
            obj.doc.SaveModel(true)
            modelName = strcat(name,'_model');
            studyName = strcat(name,'_study');
            
            % Create a study
            obj.study = obj.createStudy(studyName, modelName);
            
            % Set to default units
            obj.setDefaultLengthUnit(obj.defaultLength)
            obj.setDefaultAngleUnit(obj.defaultAngle)
            
            % Add material
            obj.study.SetMaterialByName(name, material)
        end
        
        function study = createStudy(obj, studyName, modelName)
            % CREATESTUDY Creates a new study
            % study = createStudy(studyName, modelName)
            % studyName - Name of the study to be created
            % modelName - Model where the study will be created
            if isempty(obj.study)
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(modelName)
                % Create study
                study = obj.model.CreateStudy('Transient', studyName);
            else
                % Delete old model
                obj.jd.DeleteModel(modelName)
                % Setup the new model
                obj.model = obj.jd.GetCurrentModel();
                obj.model.SetName(modelName)
                study = obj.model.GetStudy(studyName);
            end
        end
            
        function region = prepareSection(obj, csToken)
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
        
        
        function setVisibility(obj, visible)
            % SETVISIBILITY Set visibility of the JMAG application
            % setVisibility(obj, visibile)
            obj.visible = visible;
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