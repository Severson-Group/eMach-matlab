function [hystLoss, eddyCurLoss] = mn_ds_getIronLossInComponent(mn, ...
                                componentName, pid)
%   MN_DS_GETIRONLOSSINCOMPONENT Get the eddy current and hystersis loss
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

invoke(mn, 'processcommand', 'ReDim Losses(1)');
invoke(mn, 'processcommand', ...
    ['call getDocument().getSolution().getIronLossInComponent(' ...
    num2str(pid) ', "' componentName '", Losses)']);

invoke(mn, 'processcommand', 'Call setVariant(0, Losses, "MATLAB")');
Losses = invoke(mn,  'getVariant', 0, 'MATLAB');
hystLoss = Losses{1};
eddyCurLoss = Losses{2};
