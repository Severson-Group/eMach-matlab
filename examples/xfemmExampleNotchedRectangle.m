clc
clear

DRAW_MAGNET = 0;
DRAW_TIKZ   = 0;
DRAW_XFEMM = 1;

%% Define cross sections

notchedRectangle1 = CrossSectNotchedRectangle( ...
        'name', 'notchedRectangle1', ...
        'dim_w', DimMillimeter(100), ...
        'dim_w_n', DimMillimeter(15), ...   
        'dim_d', DimMillimeter(20), ...
        'dim_d_n', DimMillimeter(10), ...         
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );

%% Define components

cs = notchedRectangle1;

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', cs, ...
        'material', MaterialGeneric('name', 'Titanium'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(40)) ...
        );

%% Draw via MagNet

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.open();
    toolMn.setVisibility(1);
    toolMn.setDefaultLengthUnit('DimMillimeter', false);

    comp1.make(toolMn, toolMn);

    toolMn.viewAll();
end

%% Draw via TikZ

if (DRAW_TIKZ)
    toolTikz = TikZ();
    toolTikz.open('output.txt');

    comp1.make(toolTikz);

    toolTikz.close();
end

%% Draw via XFEMM

if (DRAW_XFEMM)
    toolXFEMM = XFEMM();
    toolXFEMM.newFemmProblem(0,'planar','millimeters');
    comp1.make(toolXFEMM,toolXFEMM);

%     FemmProblem = toolXFEMM.removeOverlaps();
    
    toolXFEMM.plot();
end
