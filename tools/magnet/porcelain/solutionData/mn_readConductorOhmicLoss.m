function dataPoints = mn_readConductorOhmicLoss(mn, doc, compName, pid)
%   MN_READCONDUCTOROHMICLOSS Reads ohmic loss (not time averaged)
%
%   dataPoints = mn_readConductorOhmicLoss(mn, doc, compName, pid)
%   mn: pointer to the MagNet project
%   doc: pointer to the document within the MagNet project
%   compName: string name of component whose voltage should be read
%   pid: Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns dataPoints: column 1 is the time step, column 2 is the loss
%           magnitude
%
%
%   Example: 

if (exist('PID') ~= 1)
    pid = 1;
end

command= ['ReDim Quantity(0) : '...
        'Quantity(0) = getDocument.getSolution.getOhmicLossInConductor(SolutionID, "' compName '") : ' ...
        'Result= Quantity(0)'];
    
isFieldQuantity = 0;
isTimeAveraged = 0;

[dataPoints] = mn_getCurveValues(mn, doc, pid, command, ...
    isFieldQuantity, isTimeAveraged);