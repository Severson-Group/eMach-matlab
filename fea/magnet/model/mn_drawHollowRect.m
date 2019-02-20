function [segments] = mn_drawHollowRect(mn, compHollowRectObj)
%MN_DRAWHOLLOWRECT Draw a hollow rectangle object in a MagNet document.
%   This function draws a hollow rectangle based on the 
%   compHollowRectObj description. 
%   It assumes MagNet is configured to use the linear units provided by
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
theta = compHollowRectObj.location.rotate_xyz(3).toRadians;

axis = [0,0] + shift_xy(1:2); 
l_o=compHollowRectObj.dim_l_o;
b_o=compHollowRectObj.dim_b_o;
t1=compHollowRectObj.dim_t1;
t2=compHollowRectObj.dim_t2;
t3=compHollowRectObj.dim_t3;
t4=compHollowRectObj.dim_t4;

points_i=[axis(1)+t1,axis(2)+t4; axis(1)+t1,axis(2)+b_o-t2;...
          l_o-t3+axis(1), b_o-t2+axis(2);l_o-t3+axis(1),t4+axis(2);];
points_o = [axis(1),axis(2); axis(1),axis(2)+b_o; axis(1)+l_o, ....
            axis(2)+b_o; axis(1)+l_o,axis(2)];
rotate=[cos(theta), -sin(theta); sin(theta), cos(theta)];

for j=1:4
points_i(j,:)=rotate*points_i(j,:)'
points_o(j,:)=rotate*points_o(j,:)'
end

%% Inner Rectangle
[l_i1] = mn_dv_newline(mn, points_i(1,:),points_i(2,:));
[l_i2] = mn_dv_newline(mn, points_i(2,:),points_i(3,:));
[l_i3] = mn_dv_newline(mn, points_i(3,:),points_i(4,:));
[l_i4] = mn_dv_newline(mn, points_i(4,:),points_i(1,:));

%% Outer Rectangle
[l_o1] = mn_dv_newline(mn, points_o(1,:),points_o(2,:));
[l_o2] = mn_dv_newline(mn, points_o(2,:),points_o(3,:));
[l_o3] = mn_dv_newline(mn, points_o(3,:),points_o(4,:));
[l_o4] = mn_dv_newline(mn, points_o(4,:),points_o(1,:));

segments = [l_i1, l_i2, l_i3, l_i4,...
            l_o1, l_o2, l_o3, l_o4];