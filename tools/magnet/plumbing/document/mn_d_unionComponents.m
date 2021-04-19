function [component] = mn_d_unionComponents(mn, componentArray)
%MN_D_UNIONCOMPONENT   create a union of two or more components in MagNet.
%   motion = MN_D_UNIONCOMPONENT(mn, componentArray) creates a union of components 
%   in the componentArray. mn is the MagNet object. componentArray is a cell array
%   of strings containing the names of the geometry to be included in the union. 
%   
%   This function returns 'component', a string containing name of the 
%   component created after performing a union of two or more components.
%
%   For example, magnet = MN_D_UNIONCOMPONENT(mn, [{'magnetPart1'},....
%                            {'magnetPart2'}]); creates a single component
%   'magnet' by union of the parts 'magnetPart1' and 'magnetPart2'.
%   
%
%   This is a wrapper for Document::unionComponents.
%
%   See also MN_FINDBODY, MN_GETPATHOFRADIALFACES, MN_D_MAKESIMPLECOIL, 
%   MN_D_SETDEFAULTLENGTHUNIT, MN_D_SETPARAMETER, 
%   MN_D_CREATEBOUNDARYCONDITION.

if iscell(componentArray) 
    invoke(mn, 'processcommand', ...
        sprintf('REDIM compArray(%i)', length(componentArray)-1));
    for i = 1:length(componentArray)
        invoke(mn, 'processcommand', ...
            sprintf('compArray(%i)= "%s"', i-1, componentArray{i}));
    end
else
    error('componentArray must be a cell array\n');
end

invoke(mn, 'processcommand', 'ret = getDocument.unionComponents(compArray,1)');
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
component = invoke(mn, 'getvariant', 0);

%% Delete the components
for i=1:length(componentArray)
    invoke(mn, 'processcommand', sprintf('Call getDocument().getView().selectObject("%s", infoSetSelection)',componentArray{i}));
    invoke(mn, 'processcommand', 'getDocument().getView().deleteSelection()');
end

end