classdef JMAG < ToolBase & Drawer2dBase & MakerExtrudeBase & MakerRevolveBase
    %JMAG Encapsulation for the JMAG Designer of JSOL Corporation.
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    %   TODO: add more description
    
    properties (GetAccess = 'public', SetAccess = 'public')        
        jd;  % The activexserver object for JMAG Designer
        app=0; % app = jd
        projName=0; % The name of JMAG Designer project (a string)
        geomApp=0; % The Geometry Editor object
        doc=0; % The document object in Geometry Editor
        ass=0; % The assemble object in Geometry Editor
        sketch=0; % The sketch object in Geometry Editor
        model=0; % The model object in JMAG Designer
        study=0; % The study object in JMAG Designer
        view;  % The view object in JMAG Designer
        consts; % Program constants (not used)
        defaultLength = 'dimMillimeter'; % Default length unit is mm (not used)
        workDir = './';
        sketchList;
    end
    
    methods (Access = 'private')
        function c = almostEqual(~,a,b)
            tol = 0.00001;
            c = abs(a - b) < tol;
        end
    end
    
    methods
        function obj = JMAG(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        function obj = open(obj, iFilename, iJd, iVisible)
            %OPEN Open JMAG Designer or a specific file.
            %   open() opens a new instance of JMAG Designer with a new document.
            %
            %   open('filename') opens the file in a new instance of MagNet.
            %
            %   open('filename', jd) opens the file in the MN MagNet instance
            %
            %   open('filename', jd, VISIBLE) opens the file in the jd JMAG
            %   Designer instance with customizable visibility (true for visible)
            %
            %   iMn and iFilename can be set to 0 to allow setting
            %   the visibility of a new instance.

            if nargin <= 1
                obj.jd = actxserver('designer.Application.171'); %JMAG version 17
            end
            
            % obj.jd now exists at this point
            if nargin > 2
                if isnumeric(iJd)
                    obj.jd = actxserver('designer.Application.171');
                end

                if iVisible
                    obj.jd.Show();
                else
                    obj.jd.Hide();
                end
            end
            
            obj.workDir = './';
            obj.projName = 'temp';
            if nargin >= 1 && ~isnumeric(iFilename)
                obj.jd.Open(strcat(obj.workDir, iFilename, '.jproj'));
            else
                obj.jd.SaveAs(strcat(obj.workDir, obj.projName, '.jproj'));
            end
            
            obj.view = obj.jd.View();
            obj.consts = [];
            obj.app = obj.jd;
        end
        
        function obj = close(obj)
            obj.jd.Quit();
        end
        
        function [line] = drawLine(obj, startxy, endxy)
            %DRAWLINE Draw a line.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            if isnumeric(obj.sketch)
                obj.sketch = obj.getSketch(0);
                obj.sketch.OpenSketch();
            end
            
            % Convert DimMillimeter to double
            startxy = double(startxy);
            endxy = double(endxy);
            
            line = obj.sketch.CreateLine(startxy(1),startxy(2),endxy(1),endxy(2));
        end
        
        function [arc] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current XFEMM document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            
            if isnumeric(obj.sketch)
                obj.sketch = obj.getSketch(0);
                obj.sketch.OpenSketch();
            end
            
            % Convert DimMillimeter to double
            centerxy = double(centerxy);
            startxy = double(startxy);
            endxy = double(endxy);
            
            obj.sketch.CreateVertex(startxy(1), startxy(2));
            obj.sketch.CreateVertex(endxy(1), endxy(2));
            obj.sketch.CreateVertex(centerxy(1), centerxy(2));
            arc = obj.sketch.CreateArc(centerxy(1), centerxy(2), ...
                                        startxy(1), startxy(2), ...
                                        endxy(1), endxy(2));
        end
        
        function geomApp = checkGeomApp(obj)
            if ~isnumeric(obj.geomApp)
                ;
            else
                obj.app.LaunchGeometryEditor();
                obj.geomApp = obj.app.CreateGeometryEditor(true);
                obj.doc = obj.geomApp.NewDocument();                
            end
            geomApp = obj.geomApp;
        end
        
        function sketch = getSketch(obj, iSketch, varargin)
            if isnumeric(iSketch)
                sketchName = strcat('mySketch', num2str(iSketch));
            else
                sketchName = iSketch;
            end

            for i = 1:length(obj.sketchList)
                if obj.sketchList(i) == sketchName
                    obj.sketch = obj.ass.GetItem(sketchName);
                    % open sketch for drawing (must be closed before switch to another sketch)
                    obj.sketch.OpenSketch();
                    sketch = obj.sketch;
                    return
                end
            end
            if i == length(obj.sketchList)
                obj.sketchList(end) = sketchName;
            end
            
            obj.geomApp = obj.checkGeomApp();
            obj.doc = obj.geomApp.GetDocument();
            obj.ass = obj.doc.GetAssembly();
            ref1 = obj.ass.GetItem('XY Plane');
            ref2 = obj.doc.CreateReferenceFromItem(ref1);
            obj.sketch = obj.ass.CreateSketch(ref2);
            obj.sketch.SetProperty('Name', sketchName)
            if nargin>2
                obj.sketch.SetProperty('Color', varargin);
            end
            
            % open sketch for drawing (must be closed before switch to another sketch)
            obj.sketch.OpenSketch();
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
        
        function new = revolve(obj, name, material, center, axis, angle)
            %REVOLVE Revolve a cross-section along an arc    
            %new = revolve(obj, name, material, center, axis, angle)
            %   name   - name of the newly extruded component
            %   center - x,y coordinate of center point of rotation
            %   axis   - x,y coordinate on the axis of ration (negative reverses
            %             direction) (0, -1) to rotate clockwise about the y axis
            %   angle  - Angle of rotation (dimAngular) 
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
        
        function new_region = regionMirrorCopy(obj, region, edge4ref, symmetry_type, bMerge)
            % Default: edge4ref=None, symmetry_type=None, bMerge=True

            mirror = obj.sketch.CreateRegionMirrorCopy();
            mirror.SetProperty('Merge', bMerge)
            ref2 = obj.doc.CreateReferenceFromItem(region);
            mirror.SetPropertyByReference('Region', ref2)
            
            if isempty(edge4ref)
                if isempty(symmetry_type)
                    error('At least give one of edge4ref and symmetry_type')
                else
                    mirror.SetProperty('SymmetryType', symmetry_type)
                end
            else
                ref1 = obj.sketch.GetItem(edge4ref.GetName()); % e.g., u"Line"
                ref2 = obj.doc.CreateReferenceFromItem(ref1);
                mirror.SetPropertyByReference('Symmetry', ref2);
            end
            
            if bMerge == false && strcmp(region.GetName(), 'Region')
                new_region = obj.ass.GetItem('Region.1');
            end 
        end

        function regionCircularPattern360Origin(obj, region, Q_float, bMerge, do_you_have_region_in_the_mirror)
            % default: bMerge=True, do_you_have_region_in_the_mirror=False
            circular_pattern = obj.sketch.CreateRegionCircularPattern();
            circular_pattern.SetProperty('Merge', bMerge);

            ref2 = obj.doc.CreateReferenceFromItem(region);
            circular_pattern.SetPropertyByReference('Region', ref2);
            face_region_string = circular_pattern.GetProperty('Region');
            %face_region_string = face_region_string[0];
            
            if do_you_have_region_in_the_mirror == true
                % Those are python codes for plotting stator coils. The problem occurs
                % because the left layer and right layer are not merged. The
                % generation of face-reference in JMAG is crazy.
                %             if do_you_have_region_in_the_mirror == true
                %                 # 这里假设face_region_string最后两位是数字
                %                 if face_region_string[-7:-3] == 'Item'
                %                     number_plus_1 = str(int(face_region_string[-3:-1]) + 1)
                %                     refarray = [0 for i in range(2)]
                %                     refarray[0] = u"faceregion(TRegionMirrorPattern%s+%s_2)" % (number_plus_1, face_region_string)
                %                     refarray[1] = face_region_string
                %                     circular_pattern.SetProperty(u"Region", refarray)
                %                     # print refarray[0]
                %                     # print refarray[1]
                %                 elif face_region_string[-6:-2] == 'Item'
                %                     # 这里假设face_region_string最后一位是数字
                %                     number_plus_1 = str(int(face_region_string[-2:-1]) + 1)
                %                     refarray = [0 for i in range(2)]
                %                     refarray[0] = u"faceregion(TRegionMirrorPattern%s+%s_2)" % (number_plus_1, face_region_string)
                %                     refarray[1] = face_region_string
                %                     circular_pattern.SetProperty(u"Region", refarray)
                %                 elif face_region_string[-8:-4] == 'Item'
                %                     # 这里假设face_region_string最后三位是数字
                %                     number_plus_1 = str(int(face_region_string[-4:-1]) + 1)
                %                     refarray = [0 for i in range(2)]
                %                     refarray[0] = u"faceregion(TRegionMirrorPattern%s+%s_2)" % (number_plus_1, face_region_string)
                %                     refarray[1] = face_region_string
                %                     circular_pattern.SetProperty(u"Region", refarray)
                %             end
            end
            
            if true
                origin = obj.sketch.CreateVertex(0,0);
                origin_is = origin.GetName()
                ref1 = obj.ass.GetItem(obj.sketch.GetName()).GetItem(origin.GetName());
                ref1 = obj.ass.GetItem(obj.sketch.GetName()).GetItem('Vertex.3');
                ref2 = obj.doc.CreateReferenceFromItem(ref1);
                circular_pattern.SetPropertyByReference('Center', ref2)
            elseif true
                % Matlab's actxserver cannot pass integer to JMAG (the following 1)
                circular_pattern.SetProperty('CenterType', 1);
                circular_pattern.SetProperty('CenterPosX', 2.0);
                circular_pattern.SetProperty('CenterPosY', 5.0);
            else
                % Matlab's actxserver cannot pass integer to JMAG (the following 2)
                circular_pattern.SetProperty('CenterType', 2);
            end
            circular_pattern.SetProperty('Angle', sprintf('360/%d', Q_float));
            circular_pattern.SetProperty('Instance', num2str(Q_float));
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