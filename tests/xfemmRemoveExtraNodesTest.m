% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two segments, 4 nodes are added to FemmProblem struct, 2 of which are
% overlapping    
toolXFEMM.drawLine([10 0],[20 0]);
toolXFEMM.drawLine([20 0],[30 10]);

% Remove extra nodes
FemmProblem = toolXFEMM.removeOverlaps();  

% We know that 1 node should be removed and there should be 3 nodes left
assert(length(FemmProblem.Nodes) == 3);
