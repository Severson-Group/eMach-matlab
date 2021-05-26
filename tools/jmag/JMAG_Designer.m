classdef JMAG_Designer < ToolBase & DrawerBase & MakerExtrudeBase & MakerRevolveBase
    %JMAG_DESIGNER encapsulation for the JMAG Designer of JSOL Corporation.
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
        fileName; % fileName is a string that specifies the complete path to the file.
        studyType = 'Transient'; % The study type in JMAG Designer
        defaultLength = 'DimMeter'; % Default length unit is m
        defaultAngle = 'DimDegree'; % Default angle unit is degrees
        visible = true; % Application visibility
    end
    

    methods
        function obj = JMAG_Designer(fileName, varargin)
            %JMAG_DESIGNER constructor for JMAG designer.
            %   tooljd = JMAG_Designer(fileName) creates a new JMAG 
            %   designer application instance and opens a new document.
            %   If the JMAG file already exists it will open the file. fileName 
            %   is a string that specifies the complete path to the file.
            %
            %   tooljd = JMAG_Designer(fileName, 'studyType', 'Transient') 
            %   creates a new JMAG designer application instance and opens 
            %   a new document. If the JMAG file already exists it will open  
            %   the file. fileName is a string  that specifies the complete path   
            %   to the file. studyType specifies the type of JMAG study. This
            %   can be specified using key value pair (using varargin). Some
            %   common study types are 'Transient', 'Static'. if studyType is
            %   not provided, 'Transient' study type will be used.
           
            lenVarargin = length(varargin);
            obj = obj.createProps(lenVarargin,varargin);            
            obj.validateProps();

            % Create the absolute path
            fileName = which(fileName);
            
            % Create a instance of JMAG designer application
            jdInstance = actxserver('designerstarter.InstanceManager');
            obj.jd = jdInstance.GetNamedInstance(fileName, 0); % Creates a new instance and returns the handle
            obj.setVisibility(obj.visible)
            % Open file
            obj.open(fileName)
        end
        
        
        function open(obj, fileName)
            %OPEN opens a JMAG designer file. 
            %   open(fileName) opens an existing JMAG file. If the file 
            %   doesn't exist it will open a new document. fileName is 
            %   a string that specifies the complete path to the file.
            
            if ~exist('fileName', 'var')
                error('Please specify a filename');
            elseif ~exist(fileName, 'file')
                obj.jd.NewProject(fileName);
                obj.saveAs(fileName); % JMAG requires it to be saved before creating geometry
            else
                obj.jd.Load(fileName);
                obj.fileName = fileName;
            end
            obj.view = obj.jd.View();
            obj.jd.GetCurrentModel.RestoreCadLink(true);
            obj.geometryEditor = obj.jd.CreateGeometryEditor(true);
            obj.doc = obj.geometryEditor.GetDocument();
            obj.assembly = obj.doc.GetAssembly();
        end

        
         function saveAs(obj, fileName)
            %SAVEAS saves the JMAG designer file.
            %   saveAs(obj, fileName) saves the file in the specified path. 
            %   obj is the JMAG_Designer object. fileName is a string that
            %   specifies the complete path to the file.
            
            obj.fileName = fileName;
            obj.save();
         end
         
         
        function save(obj)
            %SAVE saves the JMAG designer file.
            %   save(fileName) saves the JMAG designer file
            
            if isempty(obj.fileName)
                error('Unable to save file. Use the saveAs( ) function');
            else
                obj.jd.SaveAs(obj.fileName);
            end        
        end
        
        
        function close(obj)
            %CLOSE closes the JMAG designer file
            %   close(obj) closes the JMAG file and quits the JMAG designer 
            %   application. It will also close the JMAG Geometry Editor
            %   application. obj is the JMAG_Designer object.

            obj.delete()
        end
        
        
        function delete(obj)
            %DELETE quits the JMAG application delete() quits the JMAG 
            %   designer application. It will also close the JMAG Geometry 
            %   Editor application. obj is the JMAG_Designer object.
            
            obj.jd.Quit();
        end
        
        
        function [tokenDraw] = drawLine(obj, startxy, endxy)
            %DRAWLINE draws a line.
            %   [tokenDraw] = drawLine(obj, [start_x, _y], [end_x, _y])
            %   draws a line. obj is the JMAG_Designer object.
            %   [start_x, _y] is the xy cordinates of the starting point.  
            %   [end_x, _y] is the xy cordinates of the ending point. 
            %
            %   This functions returns [tokenDraw], which is the data generated 
            %   upon drawing a line

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
            %DRAWARC draws an arc.
            %   [tokenDraw] = drawarc(obj, [center_x,_y], [start_x, _y], [end_x, _y])
            %   draws an arc. obj is the JMAG_Designer object.
            %   [start_x, _y] is the xy cordinates of the starting point on the arc.  
            %   [end_x, _y] is the xy cordinates of the ending point on the arc.
            %   [center_x, _y] is the xy cordinates of the center point on the arc. 
            %
            %   This functions returns [tokenDraw], which is the data generated 
            %   upon drawing a arc.
            
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
            %CREATEPART creates a new part
            %   part = createPart(obj) creates a new part in the geometry editor
            %   obj is the JMAG_Designer object.
            %   
            %   This function will return the handle to the newly created part
            
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
            %REVOLVE revolves a cross-section along an arc    
            %   new = revolve(obj, name, material, center, axis, angle)
            %   revolves a cross-section. obj is the JMAG_Designer object.
            %   name is the name of the newly revolved component.
            %   center is the x,y coordinate of center point of rotation.
            %   axis is the x,y coordinate on the axis of ration (negative 
            %   reverses direction) (0, -1) to rotate clockwise about the
            %    y axis. angle is the angle of rotation (dimAngular)
            %
            %   This function will return the handle to the new revolved
            %   part.
            
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
            obj.model = obj.createModel(modelName);
            
            % Create a study
            studyName = strcat(name,'_study');
            obj.study = obj.createStudy(studyName, obj.studyType, obj.model);
            
            % Set to default units
            obj.setDefaultLengthUnit(obj.defaultLength)
            obj.setDefaultAngleUnit(obj.defaultAngle)
            
            % Add material
            obj.study.SetMaterialByName(name, material)
        end
        
        
        function extrudePart = extrude(obj, name, material, depth, csToken)
            %EXTRUDE extrudes a cross-section    
            %   new = extrude(obj, name, material, depth, csToken).
            %   extrudes a cross-section. obj is the JMAG_Designer object.
            %   name is the name of the newly extruded component.
            %   depth is the Depth of extrusion (dimLinear).
            %
            %   This function will return the handle to the new extruded
            %   part.
            
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
            obj.model = obj.createModel(modelName);
            
            % Create a study
            studyName = strcat(name,'_study');
            obj.study = obj.createStudy(studyName, obj.studyType, obj.model);
            
            % Set to default units
            obj.setDefaultLengthUnit(obj.defaultLength)
            obj.setDefaultAngleUnit(obj.defaultAngle)
            
            % Add material
            obj.study.SetMaterialByName(name, material)
        end
        
        function model = createModel(obj, modelName)
            %CREATEMODEL creates a JMAG model.
            %   model = createModel(obj, modelName) creates a new JMAG 
            %   model or get the exixting model. obj is the JMAG_Designer
            %   object. modelName is the name of the model to be created
            %
            %   This function will return the handle to the JMAG model.
            
            numModels = obj.jd.NumModels();
            if numModels == 1
                % Obtain the current model
                model = obj.jd.GetCurrentModel();
                model.SetName(modelName)
            else
                % Delete old models
                for i=0:(numModels-1)
                    obj.jd.DeleteModel(i)
                end
                % Obtain the current model
                model = obj.jd.GetCurrentModel();
                model.SetName(modelName)
            end
        end
            
        function study = createStudy(obj, studyName, studyType, model)
            %CREATESTUDY creates a JMAG study.
            %   study = createStudy(obj, studyName studyType, model) creates 
            %   a new study or get the current study. obj is the JMAG_Designer
            %   object. studyName is the name of the study to be created. 
            %   studyType is the type of the study to be created. model is 
            %   referenced to the model where the study will be created.
            %
            %   This function will return the handle to the JMAG study.
            
            numStudies = obj.jd.NumStudies();
            if numStudies == 0
                % Create a new study
                study = model.CreateStudy(studyType, studyName);
            else
                % Delete old studies
                for i=0:(numStudies-2) % Latest study is not deleted
                    model.DeleteStudy(i)
                end
                % Obtain the current study
                study = obj.jd.GetCurrentStudy();
                study.SetName(studyName);
            end
        end
        
        function region = prepareSection(obj, csToken)
            %PREPARESECTION prepares section from drawing.
            %   sketch = prepareSection(obj, csToken) creates JMAG 
            %   geometry regions using lines and arcs. Only the 
            %   region to be obj is the JMAG_Designer is retained, 
            %   and the rest are deleted. obj is the JMAG_Designer
            %   object. csToken contains crossection data.
            %
            %   This function will return the handle to the newly 
            %   generated region
            
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
            %SETDEFAULTLENGTHUNIT sets the default unit for length.
            %   setDefaultLengthUnit(userUnit) sets the units for length. 
            %   obj is the JMAG_Designer object. userUnit can be set to 
            %   meters
  
            if strcmp(userUnit, 'DimMeter')
                obj.defaultLength = userUnit;
                obj.model.SetUnitCollection('SI_units')
            else
                error('unsupported length unit')
            end
        end
        
        function setDefaultAngleUnit(obj, userUnit)
            %SETDEFAULTANGLEUNIT sets the default unit for angle.
            %   setDefaultAngleUnit(userUnit) sets the units for angle. 
            %   obj is the JMAG_Designer object. userUnit can be set to 
            %   degrees.
  
            if strcmp(userUnit, 'DimDegree')
                obj.defaultAngle = userUnit;
                obj.model.SetUnitCollection('SI_units')
            else
                error('unsupported angle unit')
            end
        end
        
        
        function setVisibility(obj, visible)
            %SETVISIBILITY sets visibility of the JMAG application
            %   setVisibility(obj, visibile). obj is the JMAG_Designer
            %   object. visibilty is boolean variable.
            
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