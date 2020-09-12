function [motion] = mn_d_makeMotionComponent(mn, componentName)
%MN_D_MAKEMOTIONCOMPONENT Creates a motion component.
%   mn_d_setMotionComponent(mn, componentName)
%       
%   componentName - Single string or a cell array of strings of the
%       geometry to be moved. 
%
%   Return value - a path to the motion component.
%   This is a wrapper for Document::makeMotionComponent

if iscell(componentName) 
    invoke(mn, 'processcommand', ...
        sprintf('REDIM nmArray(%i)', length(componentName)-1));
    for i = 1:length(componentName)
        invoke(mn, 'processcommand', ...
            sprintf('nmArray(%i)= "%s"', i-1, componentName{i}));
    end
else
    invoke(mn, 'processcommand', 'REDIM nmArray(0)');
    invoke(mn, 'processcommand', ...
            sprintf('nmArray(0)= "%s"', componentName));    
end

invoke(mn, 'processcommand', 'ret = getDocument.makeMotionComponent(nmArray)');

invoke(mn, 'processcommand', 'call setvariant(0, ret)');
motion = invoke(mn, 'getvariant', 0);