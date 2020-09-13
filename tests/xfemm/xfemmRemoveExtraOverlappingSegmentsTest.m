% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two ideally overlapping segments  
toolXFEMM.drawLine([20 0],[30 10]);
toolXFEMM.drawLine([20 0],[30 10]);

% Remove extra segment
FemmProblem = toolXFEMM.removeOverlaps();  

% We know that 1 segment should be removed and there should be 1 segment left
assert(length(FemmProblem.Segments) == 1);
