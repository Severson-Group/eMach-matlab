% Create FemmProblem
toolXFEMM = XFEMM();
toolXFEMM.newFemmProblem(0,'planar','millimeters');

% Draw two partially overlapping arc segments. Second arc is the version of
% the first arc rotated by 45 degrees counterclockwise
toolXFEMM.drawArc([0 0],[10 -20],[10 20]);
toolXFEMM.drawArc([0 0],[21.2132 -7.0711],[-7.0711 21.2132]);

% Remove all arc segments and add new non-overlapping arc segments
FemmProblem = toolXFEMM.removeOverlaps();  

% We know that 2 arc segment should be removed and 3 arc segments should be
% added
assert(length(FemmProblem.ArcSegments) == 3);
