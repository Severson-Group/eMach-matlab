clc
clear   

% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two ideally overlapping segments  
toolXFEMM.drawLine([20 0],[30 10]);
toolXFEMM.drawLine([20 0],[30 10]);

% Remove extra segment
FemmProblem = toolXFEMM.removeOverlaps();  
toolXFEMM.plot();

% We know that 1 segment should be removed and there should be 1 segment left
if length(FemmProblem.Segments) == 1
    fprintf('TEST PASSED!\n');
else
    fprintf('TEST FAILED\n');
end

% You can manually go and look at FemmProblem struct to ensure there are no
% overlapping segments anymore
