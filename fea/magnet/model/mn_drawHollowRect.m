function [segments] = mn_drawHollowRect(mn, compHollowRectObj)
%MN_DRAWHollowRect Draw a hollow rectangle object in a MagNet document.
%   This function draws an arc based on the compArcObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compArcObj (i.e., mm vs inches).
%
%   Variables:
%       mn                 - MagNet activexserver object
%       compHollowRectObj  - Rectangle specification object
%   Returns an array of the interface objects: 
%       [outer arc, inner arc, counter-clockwise radial segment, other
%       radial segment]
    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.

validateattributes(compHollowRectObj,{'compHollowRect'},{'nonempty'})

shift_xy = compHollowRectObj.location.anchor_xyz(1:2);
rotate_xy = compHollowRectObj.location.rotate_xyz(3).toRadians;

center = [0,0] + shift_xy(1:2); 


inner_points=compHollowRectObj.dim_l_i*[-0.5,0.5];
outer_points=[inner_points(1)-compHollowRectObj.dim_t, inner_points(2)+compHollowRectObj.dim_t];


%% Inner Rectangle
[line_inner1] = mn_dv_newline(mn, [inner_points(1),inner_points(1)],[inner_points(1),inner_points(2)]);
[line_inner2] = mn_dv_newline(mn, [inner_points(1),inner_points(2)],[inner_points(2),inner_points(2)]);
[line_inner3] = mn_dv_newline(mn, [inner_points(2),inner_points(2)],[inner_points(2),inner_points(1)]);
[line_inner4] = mn_dv_newline(mn, [inner_points(2),inner_points(1)],[inner_points(1),inner_points(1)]);
%% Outer Rectangle
[line_outer1] = mn_dv_newline(mn, [outer_points(1),outer_points(1)],[outer_points(1),outer_points(2)]);
[line_outer2] = mn_dv_newline(mn, [outer_points(1),outer_points(2)],[outer_points(2),outer_points(2)]);
[line_outer3] = mn_dv_newline(mn, [outer_points(2),outer_points(2)],[outer_points(2),outer_points(1)]);
[line_outer4] = mn_dv_newline(mn, [outer_points(2),outer_points(1)],[outer_points(1),outer_points(1)]);

segments = [line_inner1, line_inner2, line_inner3, line_inner4, line_outer1, line_outer2, line_outer3, line_outer4];