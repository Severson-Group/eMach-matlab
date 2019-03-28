function taOhmicLoss = mn_ds_getOhmicLossInConductor(mn, ...
                                conductorName, pid)
%   MN_DS_GETOHMICLOSSINCONDUCTOR Get the time averaged ohmic loss
%
%   mn = pointer to the MagNet project
%   pid = ID of solved problem (optional)
%   Returns taOhmicLoss
%
%
%   Example: 

if (exist('solutionID') ~= 1)
    pid = 1;
end

invoke(mn, 'processcommand', ...
    ['PLoss = getDocument().getSolution().getOhmicLossInConductor(' ...
    num2str(pid) ', "' conductorName '")']);

invoke(mn, 'processcommand', 'Call setVariant(0, PLoss, "MATLAB")');
taOhmicLoss = invoke(mn,  'getVariant', 0, 'MATLAB');
