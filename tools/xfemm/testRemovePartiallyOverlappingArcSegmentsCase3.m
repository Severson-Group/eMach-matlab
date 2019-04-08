clc
clear   
close all

% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two partially overlapping arc segments.

R = 3;  % radius

% Arc 1
angleArc1 = pi; % angle of arc 1 
angleRotate1 = pi; % rotate arc by angleRotate1 counterclockwise
% Start and end node coordinates of the arc in the form of x + jy
pStart1 = (R*cos(angleArc1/2) - 1i*R*sin(angleArc1/2))*exp(1i*angleRotate1);
pEnd1   = pStart1*exp(1i*angleArc1);

% Arc 2
angleArc2 = 180*pi/180; % angle of arc 2
angleRotate2 = 270*pi/180; % rotate arc by angleRotate2 counterclockwise
% Start and end node coordinates of the arc in the form of x + jy
pStart2 = (R*cos(angleArc2/2) - 1i*R*sin(angleArc2/2))*exp(1i*angleRotate2);
pEnd2   = pStart2*exp(1i*angleArc2);

% Draw arcs
toolXFEMM.drawArc([0 0],[real(pStart1) imag(pStart1)],[real(pEnd1) imag(pEnd1)]);
toolXFEMM.drawArc([0 0],[real(pStart2) imag(pStart2)],[real(pEnd2) imag(pEnd2)]);

% Remove all arc segments and add new non-overlapping arc segments
FemmProblem = toolXFEMM.removeOverlaps();  
toolXFEMM.plot();
hold on
plot([-5 5],[0 0],'--black'); plot([0 0],[-5 5],'--black')
xlim([-5 5]); ylim([-5 5])

% We know that 2 arc segment should be removed and 3 arc segments should be
% added
if length(FemmProblem.ArcSegments) == 3
    fprintf('TEST PASSED!\n');
else
    fprintf('TEST FAILED\n');
end

% You can manually go and look at FemmProblem struct to ensure there are no
% partially overlapping arc segments anymore
