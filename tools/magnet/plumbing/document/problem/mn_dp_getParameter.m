function paramVal = mn_dp_getParameter(mn, paramPath, paramName, pid)
%   MN_DP_GETPARAMETER Read a parameter value
%
%   paramVal = mn_dp_getParameter(mn, paramPath, paramName, pid)
%   MN = pointer to the MagNet project
%   paramPath = the path to the parameter (empty string for global
%           parameters
%   paramName = the parameter name
%   pid = Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns paramVal
%
%
%   Example: 

if (exist('pid') ~= 1)
    pid = 1;
end

invoke(mn, 'processcommand', ['call getDocument().getproblem(' ...
            num2str(pid) ').getParameter("' paramPath '", ' ...
            '"' paramName '",theVal)']);
invoke(mn, 'processcommand', 'Call setVariant(0, theVal, "MATLAB")');
paramVal = invoke(mn,  'getVariant', 0, 'MATLAB');