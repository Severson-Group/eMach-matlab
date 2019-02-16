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

validateattributes(compBreadloafObj,{'compBreadloaf'},{'nonempty'});

shift_xy = compBreadloafObj.location.anchor_xyz(1:2);
rotate_xy = compBreadloafObj.location.rotate_xyz(3).toRadians;

%rotation transformation for rotating local coordinate system
R = [cos(rotate_xy), -sin(rotate_xy);...
     sin(rotate_xy),  cos(rotate_xy)];

%Defining short local variables to avoid long unreadable code expressions
w = compBreadloafObj.dim_w;
l = compBreadloafObj.dim_l;
alpha = compBreadloafObj.dim_alpha.toRadians;
r = compBreadloafObj.dim_r;
 

%% Vertices (Local Coordinate System)
%Computing the coordinates of each vertice in the cross-sections local
%coordinate system. Vertices begin at bottom right vertex and proceed
%counterclockwise.

%preallocate column vectors for each coordinate point
x = zeros(1,4);
y = zeros(1,4);

% y-coordinates
y(1) = -w/2 + l*cos(alpha);
y(2) = -y(1);
y(3) = w/2;
y(4) = -y(3);

% x-coordinates
beta = asin(y(1)/r);
x(1) = r*cos(beta);
x(2) = x(1);
x(3) = x(1) - l*sin(alpha);
x(4) = x(3);

local_coords = [x;y]; % 2x4 matrix [--x--]
                      %            [--y--]
                      
%% Vertices (Global Coordinate System)

%NOTE: the order of operations is rotation about the local coordinate
%system origin followed by a translation (rotations and translations do not
%commute)

global_coords = R*local_coords; %rotate cross section about the local
                                     %coordinate system origin.

global_coords(1,:) = global_coords(1,:) + shift_xy(1); %add x offset
global_coords(2,:) = global_coords(2,:) + shift_xy(2); %add y offset


%% Create Segments

[arc] = mn_dv_newarc(mn, shift_xy, global_coords(:,1), global_coords(:,2));
[side1] = mn_dv_newline(mn,        global_coords(:,2), global_coords(:,3));
[side2] = mn_dv_newline(mn,        global_coords(:,3), global_coords(:,4));
[base] = mn_dv_newline(mn,         global_coords(:,4), global_coords(:,1));

segments = [arc, side1, side2, base];

    
