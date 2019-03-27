function force = mn_readForceOnBody(mn, doc, bodyID, forceDir, pid)
%   MN_READFORCEONBODY Reads the force on a component
%
%   force = mn_readForceOnBody(mn, doc, bodyID, forceDir, pid)
%   MN: pointer to the MagNet project
%   Doc = pointer to the document within the MagNet project
%   BodyID = index (greater than or equal to 1) of body that torque should
%           be calculated on
%   ForceDir = force in what direction? (0 = x, 1 = y, 2 = z)
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

command= ['ReDim Quantity(2) : '...
        'Call getDocument.getSolution.getForceOnBody(SolutionID, ' ...
                num2str(bodyID) ', Quantity(0),' ...
                'Quantity(1), Quantity(2)) : ' ...
        'Result= Quantity(' num2str(forceDir) ')'];
    
isFieldQuantity = 0;
isTimeAveraged = 0;

[force] = mn_getCurveValues(mn, doc, pid, command, ...
    isFieldQuantity, isTimeAveraged);