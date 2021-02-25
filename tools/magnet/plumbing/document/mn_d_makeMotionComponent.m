function [motion] = mn_d_makeMotionComponent(mn, componentName)
%MN_D_MAKEMOTIONCOMPONENT   create a motion component in MagNet.
%   motion = MN_D_MAKEMOTIONCOMPONENT(mn, componentName) creates a motion 
%   component to move the geometry named componentName. mn is the MagNet 
%   object. componentName is a string containing the name of the geometry 
%   to be included in the motion component. If multiple components are to 
%   be moved, componentName will be a cell array of strings containing 
%   names of the geometries to be included in the motion component.
%   
%   This function returns motion, which is a string containing name of the 
%   motion component created.
%
%   For example, motion = MN_D_MAKEMOTIONCOMPONENT(mn, 'rotorIron'), 
%   creates a motion component to move the geometry 'rotorIron'. 
%   
%   motion2 = MN_D_MAKEMOTIONCOMPONENT(mn, [{'rotorIron'},{'magnet1'},...
%   {'magnet2'}]), creates a motion component to move the geometries 
%   'rotorIron', 'magnet1' and 'magnet2' as one single block.
%
%   This is a wrapper for Document::makeMotionComponent.
%
%   See also MN_FINDBODY, MN_GETPATHOFRADIALFACES, MN_D_MAKESIMPLECOIL, 
%   MN_D_SETDEFAULTLENGTHUNIT, MN_D_SETPARAMETER, 
%   MN_D_CREATEBOUNDARYCONDITION.

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