classdef MagNet < ToolBase & Drawer2dBase
    %MagNet Encapsulation for the MagNet FEA software
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    %   TODO add more description
    
    properties (GetAccess = 'private', SetAccess = 'private')
        mn; % MagNet activexserver object
        doc; % Document object
    end
    
    properties (GetAccess = 'public', SetAccess = 'protected')
%        attr1; % Describe this attribute
%        attr2; % Describe this attribute
    end
    
    methods
        function obj = MagNet(varargin)
            obj = obj.createProps(nargin,varargin);            
            obj.validateProps();            
        end
        
        % ----------------------------------------
        % ToolBase abstract method implementations
        % ----------------------------------------
        
        function obj = open(obj, iFilename, iMn, iVisible)
            %OPEN Open MagNet or a specific file.
            %   open() opens a new instance of MagNet with a new document.
            %
            %   open('filename') opens the file in a new instance of MagNet.
            %
            %   open('filename', MN) opens the file in the MN MagNet instance
            %
            %   open('filename', MN, VISIBLE) opens the file in the MN MagNet
            %        instance with customizable visibility (true for visible)
            %
            %   iMn and iFilename can be set to 0 to allow setting
            %   the visibility of a new instance.

            if nargin < 2
                obj.mn = actxserver('MagNet.Application');
            end
            
            if nargin > 2
                if isnumeric(iMn)
                    obj.mn = actxserver('MagNet.Application');
                end
                
                set(obj.mn, 'Visible', iVisible);
            end

            if nargin > 0 && ~isnumeric(iFilename)
                obj.doc = invoke(obj.mn, 'openDocument', iFilename);
            else
                obj.doc = invoke(obj.mn, 'newDocument');
            end
        end
        
        function close(obj)
           % CLOSE Closes MagNet application
            
        end

        
        % --------------------------------------------
        % Drawer2dBase abstract method implementations
        % --------------------------------------------

        function [line] = drawLine(obj, startxy, endxy)
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
            end
        end
        
        function [arc] = drawArc(obj, centerxy, startxy, endxy)
            %DRAWARC Draw an arc in the current MagNet document.
            %   drawarc(mn, [center_x,_y], [start_x, _y], [end_x, _y]) draws an arc
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
            end   
        end
        
        function select(obj)
            %SELET Selects something from canvas (?)
            % TODO:
            % implement this...
        end

        
        % --------------------------------------------
        % MagNet specific method implementations
        % --------------------------------------------
        
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
             
            %1. use the superclass method to validate the properties 
            validateProps@ToolBase(obj);   
            validateProps@Drawer2dBase(obj);
            
            %2. valudate the new properties that have been added here
%            validateattributes(obj.dim_d_a,{'DimLinear'},{'nonnegative','nonempty'})            
%            validateattributes(obj.dim_r_o,{'DimLinear'},{'nonnegative','nonempty'})
%            validateattributes(obj.dim_depth,{'DimLinear'},{'nonnegative', 'nonempty'})
%            validateattributes(obj.dim_alpha,{'DimAngular'},{'nonnegative', 'nonempty', '<', 2*pi})
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