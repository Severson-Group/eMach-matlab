function torque = mn_readTorqueOnBody(mn, doc, bodyID, torqueDir, pid)
%   MN_READTORQUEONBODY Retrieve solution data for torque on a component
%
%   torque = mn_readTorqueOnBody(mn, doc, bodyID, torqueDir, pid)
%   MN: pointer to the MagNet project
%   Doc: pointer to the document within the MagNet project
%   bodyID: index (greater than or equal to 1) of body that torque should
%           be calculated on
%   torqueDir: torque about what axis? (0 = x, 1 = y, 2 = z)
%   PID: Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns DataPoints: column 1 is the time step, column 2 is the voltage
%           magnitude
%
%

if (exist('pid') ~= 1)
    pid = 1;
end

Command= ['ReDim Quantity(2) : '...
        'Call getDocument.getSolution.getTorqueOnBody(SolutionID, ' ...
                num2str(bodyID) ', Array(0, 0, 0), Quantity(0),' ...
                'Quantity(1), Quantity(2)) : ' ...
        'Result= Quantity(' num2str(torqueDir) ')'];
    
IsFieldQuantity = 0;
IsTimeAveraged = 0;

[torque] = mn_getCurveValues(mn, doc, pid, Command, ...
    IsFieldQuantity, IsTimeAveraged);