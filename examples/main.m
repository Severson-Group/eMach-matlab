clc
clear

toolMn = MagNet();
toolMn.open(0,0,true);
toolMn.setDefaultLengthUnit('millimeters', false);

% Run these commands to show that the MagNet object is working
% 
% pause(1);
% toolMn.drawLine([0,0],[5,5]);
% 
% pause(1);
% toolMn.drawArc([0,0],[5,5],[0,5]);
% 
% toolMn.viewAll()
% 
% pause(1)
% toolMn.setVisibility(false);
% 
% pause(1)
% toolMn.setVisibility(true);

arc = CrossSectArc( ...
        'name', 'arc1', ...
        'dim_d_a', DimMillimeter(4), ...
        'dim_r_o', DimMillimeter(80), ...
        'dim_depth', DimMillimeter(9), ...
        'dim_alpha', DimDegree(45).toRadians(), ...
        'material', MaterialGeneric('name', 'pm'), ...
        'location', Location2D('anchor_xy', DimMillimeter([0,0]), ...
        'rotate_xy', DimDegree([0,0]).toRadians()), ...
        'drawer', toolMn ...
        );    
arc.draw();

toolMn.viewAll();

    

