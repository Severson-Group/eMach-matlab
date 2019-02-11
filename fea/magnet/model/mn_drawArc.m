function [segments] = mn_drawArc(mn, compArcObj)
%MN_DRAWARC Draw an Arc object in a MagNet document.
%   This function draws an arc based on the compArcObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compArcObj (i.e., mm vs inches).
%
%   Variables:
%       mn          - MagNet activexserver object
%       compArcObj  - Arc specification object
%   Returns an array of the interface objects: 
%       [outer arc, inner arc, counter-clockwise radial segment, other
%       radial segment]
    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.
shift_xy = compArcObj.location.anchor_xyz(1:2);
rotate_xy = compArcObj.location.rotate_xyz(3).toRadians;

center = [0,0] + shift_xy(1:2); 

%% Outer arc segment
startxy_out = compArcObj.dim_r_o*...
            [   cos(-compArcObj.dim_alpha.toRadians/2 + rotate_xy), ...
                sin(-compArcObj.dim_alpha.toRadians/2 + rotate_xy)] ...
                + shift_xy;
endxy_out = compArcObj.dim_r_o*...
            [   cos(compArcObj.dim_alpha.toRadians/2 + rotate_xy), ...
                sin(compArcObj.dim_alpha.toRadians/2 + rotate_xy)] ...
                + shift_xy;        

[arc_out] = mn_dv_newarc(mn, center, startxy_out, endxy_out);

%% inner arc segment
startxy_in = (compArcObj.dim_r_o - compArcObj.dim_d_a) *...
            [   cos(-compArcObj.dim_alpha.toRadians/2 + rotate_xy), ...
                sin(-compArcObj.dim_alpha.toRadians/2 + rotate_xy)] ...
                + shift_xy;
            
endxy_in = (compArcObj.dim_r_o - compArcObj.dim_d_a) *...
            [   cos(compArcObj.dim_alpha.toRadians/2 + rotate_xy), ...
                sin(compArcObj.dim_alpha.toRadians/2 + rotate_xy)] ...
                + shift_xy;
            
[arc_in] = mn_dv_newarc(mn, center, startxy_in, endxy_in);

%% side segments
[line_cc] = mn_dv_newline(mn, endxy_in, endxy_out);
[line_cw] = mn_dv_newline(mn, startxy_in, startxy_out);

segments = [arc_out, arc_in, line_cc, line_cw];