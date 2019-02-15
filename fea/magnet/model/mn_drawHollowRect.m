function [segments] = mn_drawHollowRect(mn, compHollowRectObj)
%MN_DRAWHOLLOWRECT Draw a hollow rectangle object in a MagNet document.
%   This function draws a hollow rectangle based on the compHollowRectObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compHollowRectObj (i.e., mm vs inches).
%
%   Variables:
%       mn                 - MagNet activexserver object
%       compHollowRectObj  - Rectangle specification object
%   Returns an array of the interface objects: 
%       [inner line 1, inner line 2, inner line 3, inner line 4, outer line
%       1, outer line 2, outer line 3, outer line 4];

    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.

validateattributes(compHollowRectObj,{'compHollowRect'},{'nonempty'})

shift_xy = compHollowRectObj.location.anchor_xyz(1:2);
rotate_xy = compHollowRectObj.location.rotate_xyz(3).toRadians;

axis = [0,0] + shift_xy(1:2); 
outer_length=compHollowRectObj.dim_l_o;
thickness=compHollowRectObj.dim_t;
length_inner=outer_length-thickness;

[line_inner1] = mn_dv_newline(mn, [axis(1)+thickness,axis(2)+thickness],[axis(1)+thickness,length_inner+axis(2)]);
[line_inner2] = mn_dv_newline(mn, [axis(1)+thickness,length_inner+axis(2)],[length_inner+axis(1),length_inner+axis(2)]);
[line_inner3] = mn_dv_newline(mn, [length_inner+axis(1),length_inner+axis(2)],[length_inner+axis(1),thickness+axis(2)]);
[line_inner4] = mn_dv_newline(mn, [length_inner+axis(1),thickness+axis(2)],[thickness+axis(1),thickness+axis(2)]);

%% Outer Rectangle
[line_outer1] = mn_dv_newline(mn, [axis(1),axis(2)],[axis(1),outer_length+axis(2)]);
[line_outer2] = mn_dv_newline(mn, [axis(1),outer_length+axis(2)],[outer_length+axis(1),outer_length+axis(2)]);
[line_outer3] = mn_dv_newline(mn, [outer_length+axis(1),outer_length+axis(2)],[outer_length+axis(1),axis(2)]);
[line_outer4] = mn_dv_newline(mn, [outer_length+axis(1),axis(2)],[axis(1),axis(2)]);
%% Inner Rectangle
segments = [line_inner1, line_inner2, line_inner3, line_inner4, line_outer1, line_outer2, line_outer3, line_outer4];