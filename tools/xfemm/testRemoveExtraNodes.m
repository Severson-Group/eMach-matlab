clc
clear   

% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two segments, 4 nodes are added to FemmProblem struct, 2 of which are 
% overlapping    
toolXFEMM.drawLine([10 0],[20 0]);
toolXFEMM.drawLine([20 0],[30 10]);

% Remove extra nodes
FemmProblem = toolXFEMM.removeOverlaps();  
toolXFEMM.plot();

% We know that 1 node should be removed and there should be 3 nodes left
if length(FemmProblem.Nodes) == 3
    fprintf('TEST PASSED!\n');
else
    fprintf('TEST FAILED\n');
end

% You can manually go and look at FemmProblem struct to ensure there are no
% overlapping nodes anymore
