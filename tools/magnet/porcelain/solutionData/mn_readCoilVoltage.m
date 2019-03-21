function dataPoints = mn_readCoilVoltage(mn, doc, coilName, pid)
%   MN_READCOILVOLTAGE Read the voltage of a component 
%   
%   dataPoints = mn_readCoilVoltage(mn, doc, coilName, pid)
%   MN = pointer to the MagNet project
%   Doc = pointer to the document within the MagNet project
%   CoilName = string name of component whose voltage should be read
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

command= ['ReDim Quantity(0) : '...
        'Call getDocument.getSolution.getVoltageAcrossCoil(SolutionID, "' coilName '", Quantity(0)) : ' ...
        'Result= Quantity(0)'];
    
isFieldQuantity = 0;
isTimeAveraged = 0;

[dataPoints] = mn_getCurveValues(mn, doc, pid, command, ...
    isFieldQuantity, isTimeAveraged);