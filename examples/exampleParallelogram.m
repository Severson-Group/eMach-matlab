clc
clear

%This example draws a parallelogram.

DRAW_MAGNET = 0;
DRAW_TIKZ   = 0;
DRAW_JMAG = 1;

%% Define cross sections
parallelogram = CrossSectParallelogram( ...
        'name', 'parallelogram', ...
        'dim_l', DimMillimeter(40), ...
        'dim_t', DimMillimeter(8), ...
        'dim_theta', DimDegree(45), ...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree(0).toRadians() ...
        ) ...
        );
%% Define components

cs = parallelogram;

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', cs, ...
'material', MaterialGeneric('name', 'M19: USS Transformer 72 -- 29 Gage'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(15)) ...
        );

%% Draw via MagNet

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.open(0,0,true);
    toolMn.setDefaultLengthUnit('millimeters', false);

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
    
    tooljd.close();
end


