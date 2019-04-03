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
    end
    
    methods (Access = 'private')
        function c = almostEqual(obj,a,b)
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
                obj.jd = actxserver('designer.Application.171'); % Note: version 18 is available now
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

            obj.checkGeomApp();
            if isnumeric(obj.sketch)
                obj.sketch = obj.getSketch(0);
            end
        end
        
        function obj = close(obj)
            obj.jd.Quit();
        end
        
        function [line] = drawLine(self, startxy, endxy)
            %DRAWLINE Draw a line.
            %   drawLine([start_x, _y], [end_x, _y]) draws a line

            self.checkGeomApp();
            if isnumeric(self.sketch)
                self.sketch = self.getSketch(0);
            end
            
            % Convert DimMillimeter to double
            startxy = double(startxy);
            endxy = double(endxy);
            
            line = self.sketch.CreateLine(startxy(1),startxy(2),endxy(1),endxy(2));
        end
        
        function [arc] = drawArc(self, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current XFEMM document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y])
            %       draws an arc
            
            self.checkGeomApp();
            if isnumeric(self.sketch)
                self.sketch = self.getSketch(0);
            end
            self.sketch.OpenSketch();
            
            % Convert DimMillimeter to double
            centerxy = double(centerxy);
            startxy = double(startxy);
            endxy = double(endxy);
            
            self.sketch.CreateVertex(startxy(1), startxy(2));
            self.sketch.CreateVertex(endxy(1), endxy(2));
            self.sketch.CreateVertex(centerxy(1), centerxy(2));
            arc = self.sketch.CreateArc(centerxy(1), centerxy(2), ...
                                        startxy(1), startxy(2), ...
                                        endxy(1), endxy(2));
        end
        
        function geomApp = checkGeomApp(self)
            if ~isnumeric(self.geomApp)
                geomApp = self.geomApp;
            else
                self.app.LaunchGeometryEditor();
                geomApp = self.app.CreateGeometryEditor(true);
                self.geomApp = geomApp;
            end
        end
        
        function sketch = getSketch(self, iSketch)
            if ~isnumeric(self.sketch)
                sketch = self.sketch;
            else
                if isnumeric(iSketch)
                    self.geomApp = self.checkGeomApp();
                    self.geomApp.NewDocument();
                    self.doc = self.geomApp.GetDocument();
                    self.ass = self.doc.GetAssembly();
                    ref1 = self.ass.GetItem('XY Plane');
                    ref2 = self.doc.CreateReferenceFromItem(ref1);
                    self.sketch = self.ass.CreateSketch(ref2);
                    self.sketch.SetProperty('Name', 'Sketch1')
                    self.sketch.SetProperty('Color', 'k')
                    sketch = self.sketch;
                else
                    sketch = self.ass.GetItem(iSketch); % iSketch is the name of sketch here
                end
            end
            self.sketch.OpenSketch();           
        end
        
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