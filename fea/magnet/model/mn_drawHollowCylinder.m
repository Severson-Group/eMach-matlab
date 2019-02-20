function [segments] = mn_drawHollowCylinder(mn, compHollowCylinderObj)
%MN_DRAWHOLLOWCYLINDER Draw a HollowCylinder object in a MagNet document.
%   This function draws a hollow cylinder based on the
%   compHollowCylinderObj description. It assumes that MagNet is configured
%   to use the linear units provided by compHollowCylinderObj
%   (i.e., mm vs inches).
%
%   Variables:
%       mn          - MagNet activexserver object
%       compHollowCylinderObj  - HollowCylinder specification object
%   Returns an array of the interface objects: 
%       [outer arc, inner arc, counter-clockwise radial segment, other
%       radial segment]
    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.

validateattributes(compHollowCylinderObj,{'compHollowCylinder'},{'nonempty'})

shift_xy = compHollowCylinderObj.location.anchor_xyz(1:2);
rotate_xy = compHollowCylinderObj.location.rotate_xyz(3).toRadians;

center = [0,0] + [shift_xy(1)*cos(rotate_xy)-shift_xy(2)*sin(rotate_xy),... 
                  shift_xy(1)*sin(rotate_xy)+shift_xy(2)*cos(rotate_xy)];

%% Outer circle
outer_radius = compHollowCylinderObj.dim_r_o;     

% [arc_out1, arc_out2] = mn_dv_newcircle(mn, center, outer_radius);

startxy_out = outer_radius*[0, -1] + shift_xy;
endxy_out = outer_radius*[0, 1] + shift_xy;

[arc_out1] = mn_dv_newarc(mn, center, startxy_out, endxy_out);
[arc_out2] = mn_dv_newarc(mn, center, endxy_out, startxy_out);

%% inner circle
inner_radius = compHollowCylinderObj.dim_r_o - compHollowCylinderObj.dim_d_a;
                       
% [arc_in1, arc_in2] = mn_dv_newcircle(mn, center, inner_radius);

startxy_in = inner_radius*[0, -1] + shift_xy;
endxy_in = inner_radius*[0, 1] + shift_xy;

[arc_in1] = mn_dv_newarc(mn, center, startxy_in, endxy_in);
[arc_in2] = mn_dv_newarc(mn, center, endxy_in, startxy_in);

segments = [arc_out1, arc_out2, arc_in1, arc_in2];