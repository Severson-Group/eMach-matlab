function FemmProblem = xfemm_drawHollowCylinder(FemmProblem, compHollowCylinderObj)
%MN_DRAWHOLLOWCYLINDER Draw a HollowCylinder object in xfemm.
%   This function draws a hollow cylinder based on the
%   compHollowCylinderObj description. It
%   assumes that MagNet is configured to use the linear units provided by
%   compHollowCylinderObj (i.e., mm vs inches).
%
%   Variables:
%       FemmProblem          - xfemm struct
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

[FemmProblem, seginds, nodeinds, nodeids] = addcircle_mfemm(FemmProblem,...
    center(1), center(2), outer_radius);

%% inner circle
inner_radius = compHollowCylinderObj.dim_r_o - compHollowCylinderObj.dim_d_a;
                       
[FemmProblem, seginds, nodeinds, nodeids] = addcircle_mfemm(FemmProblem,...
    center(1), center(2), inner_radius);