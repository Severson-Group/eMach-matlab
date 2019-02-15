function [segments] = mn_drawBreadloaf(mn, compBreadloafObj)
%MN_DRAWBREADLOAF Draws a breadloaf object in a MagNet document.
%   This function draws an arc based on the compArcObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compBreadloafObj (i.e., mm vs inches).
%
%   Variables:
%       mn          - MagNet activexserver object
%       compBreadloafObj  - Breadloaf specification object
%   Returns an array of the interface objects: 
%       [base, left side, radial segment, right side]
    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.

validateattributes(compBreadloafObj,{'compBreadloaf'},{'nonempty'})

shift_xy = compBreadloafObj.location.anchor_xyz(1:2);
rotate_xy = compBreadloafObj.location.rotate_xyz(3).toRadians;

center = [0,0] + shift_xy(1:2); 

R = [cos(rotate_xy), -sin(rotate_xy);...
     sin(rotate_xy),  cos(rotate_xy)];
 
 w = compBreadloafObj.dim_w;
 l = compBreadloafObj.dim_r;
 alpha = compBreadloafObj.dim_alpha.toRadians;
 r = compBreadloafObj.dim_r;
 

%% Top arc segment

y = w/2 - l*cos(alpha);
beta = asin(temp/r);
x = r*cos(beta);

startxy_arc = transpose(R*[ x; -y]);
endxy_arc =  transpose(R*[ x; y]);

[arc] = mn_dv_newarc(mn, center, startxy_arc, endxy_arc);

%% side segments

y = w/2;
x = endxy_arc(1) - l*sin(alpha);
side1_start = transpose(R*[x;-y]);
side2_start = transpose(R*[x;y]);

[side1] = mn_dv_newline(mn, side1_start, startxy_arc);
[side2] = mn_dv_newline(mn, side2_start, endxy_arc);

%% Base Line

[base] = mn_dv_newline(mn, side1_start, side_start);

segments = [arc, side1, side2, base];

    
