function [segments] = mn_drawTrapezoid(mn, compTrapezoidObj)
%MN_DRAWTRAPEZOID Draw a trapezoid object in a MagNet document.
%   This function draws a trapezoid based on the compTrapezoidObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compTrapezoidObj (i.e., mm vs inches).
%
%   Variables:
%       mn                - MagNet activexserver object
%       compTrapezoidObj  - Trapezoid specification object
%   Returns an array of the interface objects: 
%       [top segment, bottom segment, left segment, right segment]
    
%When handling the location settings, only deal with xy coordinates because 
%MagNet always draws in the xy reference frame.

validateattributes(compTrapezoidObj,{'compTrapezoid'},{'nonempty'})


%% Calculate points of trapezoid
% Bottom left is 1, rotating clockwise for 2, 3, 4

l = compTrapezoidObj.dim_l;
w = compTrapezoidObj.dim_w;
theta = compTrapezoidObj.dim_theta;


point1 = [-(w/2), 0];
point2 = [-(w/2) + l*cos(theta), l*sin(theta)];
point3 = [ (w/2) - l*cos(theta), l*sin(theta)];
point4 = [ (w/2), 0];


%% Draw segments
[top_seg]    = mn_dv_newline(mn, point2, point3);
[bottom_seg] = mn_dv_newline(mn, point1, point4);
[left_seg]   = mn_dv_newline(mn, point1, point2);
[right_seg]  = mn_dv_newline(mn, point3, point4);

segments = [top_seg, bottom_seg, left_seg, right_seg];