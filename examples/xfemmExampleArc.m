clc
clear

DRAW_MAGNET = 0;
DRAW_TIKZ   = 0;
DRAW_XFEMM = 1;

%% Define cross sections

arc1 = CrossSectArc( ...
        'name', 'arc1', ...
        'dim_d_a', DimMillimeter(1), ...
        'dim_r_o', DimMillimeter(10), ...        
        'dim_alpha', DimDegree(150).toRadians(), ...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([0,0]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
    
arc2 = CrossSectArc( ...
        'name', 'arc2', ...
        'dim_d_a', DimMillimeter(1), ...
        'dim_r_o', DimMillimeter(11), ...        
        'dim_alpha', DimDegree(20).toRadians(), ...
        'location', Location2D( ...
            'anchor_xy', DimMillimeter([5,0]), ...
            'theta', DimDegree([0]).toRadians() ...
        ) ...
        );
%% Define components

comp1 = Component( ...
        'name', 'comp1', ...
        'crossSections', arc1, ...
        'material', MaterialGeneric('name', 'Titanium'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(0)) ...
        );

comp2 = Component( ...
        'name', 'comp1', ...
        'crossSections', arc2, ...
        'material', MaterialGeneric('name', '18 AWG'), ...
        'makeSolid', MakeExtrude( ...
            'location', Location3D( ...
                'anchor_xyz', DimMillimeter([0,0,0]), ...
                'rotate_xyz', DimDegree([0,0,0]).toRadians() ...
                ), ...
            'dim_depth', DimMillimeter(0)) ...
        );

%% Draw via MagNet

if (DRAW_MAGNET)
    toolMn = MagNet();
    toolMn.open();
    toolMn.setVisibility(1);
    toolMn.setDefaultLengthUnit('DimMillimeter', false);

    comp1.make(toolMn, toolMn);
    comp2.make(toolMn, toolMn);

    toolMn.viewAll();
end

%% Draw via TikZ

if (DRAW_TIKZ)
    toolTikz = TikZ();
    toolTikz.open('output.txt');

    comp1.make(toolTikz);
    comp2.make(toolTikz);

    toolTikz.close();
end

if (DRAW_XFEMM)
    toolXFEMM = XFEMM();
    toolXFEMM.newFemmProblem(0,'planar','millimeters');
    
    tokenComp1 = comp1.make(toolXFEMM,toolXFEMM);
    tokenComp2 = comp2.make(toolXFEMM,toolXFEMM);
    
    toolXFEMM.setGroupNumber(1,tokenComp1);
    toolXFEMM.setGroupNumber(2,tokenComp2);

    FemmProblem = toolXFEMM.removeOverlaps();

    toolXFEMM.plot();
end
