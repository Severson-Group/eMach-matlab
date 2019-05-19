function dataPoints = mn_getCoilVoltage(mn, doc, compName, pid)
%   MN_GETCOILVOLTAGE Reads the coil voltage (not time averaged)
%
%   dataPoints = mn_getCoilVoltage(mn, doc, compName, pid)
%   mn: pointer to the MagNet project
%   doc: pointer to the document within the MagNet project
%   compName: string name of coil whose voltage should be read
%   pid: Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns dataPoints: column 1 is the time step, column 2 is the voltage
%           magnitude

if (exist('PID') ~= 1)
    pid = 1;
end

command= ['ReDim Quantity(0) : '...
        'call getDocument.getSolution.getVoltageAcrossCoil(SolutionID, "' compName '",Quantity(0)) : ' ...
        'Result= Quantity(0)'];
    
isFieldQuantity = 0;
isTimeAveraged = 0;

[dataPoints] = mn_getCurveValues(mn, doc, pid, command, ...
    isFieldQuantity, isTimeAveraged);
end