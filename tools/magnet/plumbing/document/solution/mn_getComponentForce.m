function dataPoints = mn_getComponentForce(mn, doc, compName, pid, axis)
%   MN_GETCOMPONENTFORCE Reads force experienced by component(not time averaged)
%
%   dataPoints = mn_getComponentForce(mn, doc, compName, pid, axis)
%   mn: pointer to the MagNet project
%   doc: pointer to the document within the MagNet project
%   compName: string name of group of components whose force should be read
%   pid: Problem ID (1 if there is only one project -- optional in this
%           case)
%   axis: Specifies which axis the force is being read for. Use 0 for
%   x-axis, 1 for y-axis and 2 for z-axis.
%
%   Returns dataPoints: column 1 is the time step, column 2 is the force
%           magnitude
if (exist('PID') ~= 1)
    pid = 1;
end

command= ['ReDim Quantity(2) : '...
        'call getDocument.getSolution.getForceOnBody(SolutionID, "' compName '",Quantity(0),Quantity(1),Quantity(2)) : ' ...
        sprintf('Result= Quantity(%i)',axis)];
    
isFieldQuantity = 0;
isTimeAveraged = 0;

[dataPoints] = mn_getCurveValues(mn, doc, pid, command, ...
    isFieldQuantity, isTimeAveraged);
end