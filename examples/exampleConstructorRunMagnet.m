clc
clear all

DRAW_MAGNET = 1;
DRAW_TIKZ   = 0;

%% Define cross sections

hollowCylinder1 = CrossSectHollowCylinder( ...
        'name', 'hollowCylinder1', ...
        'dim_d_a', DimMillimeter(4), ...
        'dim_r_o', DimMillimeter(80), ...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree(0).toRadians() ...
        ) ...
        );

hollowCylinder2 = hollowCylinder1.clone('name', 'hollowCylinder2', ...
                                        'dim_d_a', DimMillimeter(10), ...
                                        'dim_r_o', DimMillimeter(50), ...
                                        'location', Location2D( ...
                                                'anchor_xy', DimMillimeter([10,10]), ...
                                                'theta', DimDegree(0).toRadians() ...
                                        ) ...
                                        );

%% Define components

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', hollowCylinder1, ...
        'material', MaterialGeneric('name', 'pm'), ...
        'makeSolid', MakeSimpleExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(80)) ...
        );

comp2 = comp1.clone('name', 'comp2', ...
                    'crossSections', hollowCylinder2 ...
                    );

%% Draw via MagNet

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.open(0,0,true);
    %toolMn.setDefaultLengthUnit('millimeters', false);

    comp1.make(toolMn, toolMn);
    comp2.make(toolMn, toolMn);

    toolMn.viewAll();
end

%% Draw via TikZ

if (DRAW_TIKZ)
    toolTikz = TikZ();
    toolTikz.open('output.txt');

    comp1.make(toolTikz);

    toolTikz.close();
end
