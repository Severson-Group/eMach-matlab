function dataPoints = mn_readCircuitCompCurrent(mn, doc, compName, pid)
%   MN_READCIRCUITCOMPCURRENT Reads the current through a circuit component 
%
%   MN = pointer to the MagNet project
%   Doc = pointer to the document within the MagNet project
%   CompName = string name of component whose voltage should be read
%   PID = Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns DataPoints: column 1 is the time step, column 2 is the voltage
%           magnitude
%
%
%   Example: 

if (exist('pid') ~= 1)
    pid = 1;
end

Command= ['ReDim Quantity(0) : '...
        'Call getDocument.getSolution.getCurrentThroughCircuitComponent(SolutionID, "' compName '", Quantity(0)) : ' ...
        'Result= Quantity(0)'];
    
IsFieldQuantity = 0;
IsTimeAveraged = 0;

[dataPoints] = mn_getCurveValues(mn, doc, pid, Command, IsFieldQuantity, IsTimeAveraged);