% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two ideally overlapping arc segments  
toolXFEMM.drawArc([0 0],[0 -20],[0 20]);
toolXFEMM.drawArc([0 0],[0 -20],[0 20]);

% Remove extra arc segment
FemmProblem = toolXFEMM.removeOverlaps();  

% We know that 1 arc segment should be removed and there should be 1 arc
% segment left
assert(length(FemmProblem.ArcSegments) == 1);
