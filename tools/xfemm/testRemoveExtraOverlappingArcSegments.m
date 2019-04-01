clc
clear   

% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two ideally overlapping arc segments  
toolXFEMM.drawArc([0 0],[0 -20],[0 20]);
toolXFEMM.drawArc([0 0],[0 -20],[0 20]);

% Remove extra arc segment
FemmProblem = toolXFEMM.removeOverlaps();  
toolXFEMM.plot();

% We know that 1 arc segment should be removed and there should be 1 arc
% segment left
if length(FemmProblem.ArcSegments) == 1
    fprintf('TEST PASSED!\n');
else
    fprintf('TEST FAILED\n');
end

% You can manually go and look at FemmProblem struct to ensure there are no
% overlapping arc segments anymore
