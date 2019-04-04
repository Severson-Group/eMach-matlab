clc
clear

DRAW_MAGNET = 0;
DRAW_TIKZ   = 0;
DRAW_JMAG   = 1;

%% Define cross sections
   
SimpleRect = CrossSectSolidRect( ...
        'name', 'SimpleRect', ...
        'dim_w',DimMillimeter(20),....
        'dim_h',DimMillimeter(20),...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    
%% Define components

cs = SimpleRect;

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', cs, ...
        'material', MaterialGeneric('name', 'pm'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(20)) ...
        );
%% Draw via MagNet

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.open(0,0,true);
    %toolMn.setDefaultLengthUnit('millimeters', false);

    comp1.make(toolMn,toolMn);

    toolMn.viewAll();
end

%% Draw via TikZ

if (DRAW_TIKZ)
    toolTikz = TikZ();
    toolTikz.open('output.txt');

    comp1.make(toolTikz);

    toolTikz.close();
end

%% Draw via JMAG

if (DRAW_JMAG)
    toolJd = JMAG();
    toolJd.open(0,0,true);

    comp1.make(toolJd,toolJd);

    %toolJd.viewAll();
end