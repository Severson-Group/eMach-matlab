function timeInstants = mn_getTimeInstants(mn, pid, bField)
%   mn_getTimeInstants Return array of all time istants within the problem
%
%   MN = pointer to the MagNet project
%   PID = problem ID to get the solution times for
%   bField = set to 1 if time instants should only be reported for which
%       field solutions have been saved (0 returns all solution time
%       instants)
%  
%
%   Returns timeInstants - array of all timesteps
%
%

invoke(mn, 'processcommand', 'ReDim TimeInstants(0)');
if bField == 1             
    invoke (mn, 'processcommand', ...
        ['getDocument.getSolution.getFieldSolutionTimeInstants ' ...
        num2str(pid) ', TimeInstants']);             
else
    invoke (mn, 'processcommand', ...
        ['getDocument.getSolution.getGlobalSolutionTimeInstants ' ...
        num2str(pid) ', TimeInstants']);
end
invoke (mn,  'processcommand', 'Call setVariant(0, TimeInstants, "MATLAB")');         
temp = invoke (mn,  'getVariant', 0, 'MATLAB');
timeInstants = zeros(length(temp),1);
for i = 1:length(temp)
    timeInstants(i) = temp{i};
end
