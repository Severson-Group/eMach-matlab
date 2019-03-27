function [coil] = mn_d_makeSimpleCoil(mn, problemID, surfacesVolume)
%MN_D_MAKESIMPLECOIL Create a simple coil.
%   mn_d_makeSimpleCoil(doc, objectpath, param_name, new_value, param_type)
%       Sets that specified parameter name. 

%   problemID - integer problem ID. 
%   surfacesVolume - Single string or a cell array of strings of the
%       geometry for the coil. If this is an array of volumes, the 
%       coil is constructed with Face#1 connected to Face#2, which is then
%       connected to Face#1 of the next volume.
%
%   Return value: a path to the new coil.
%   This is a wrapper for Document::makeSimpleCoil


validateattributes(problemID, {'numeric'}, {'positive','integer'});



if iscell(surfacesVolume) 
    invoke(mn, 'processcommand', ...
        sprintf('REDIM nmArray(%i)', length(surfacesVolume)-1));
    for i = 1:length(surfacesVolume)
        invoke(mn, 'processcommand', ...
            sprintf('nmArray(%i)= "%s"', i-1, surfacesVolume{i}));
    end
else
    invoke(mn, 'processcommand', 'REDIM nmArray(0)');
    invoke(mn, 'processcommand', ...
            sprintf('nmArray(0)= "%s"', surfacesVolume));
    
end

cmdstring = sprintf(...
    'ret = getDocument.makeSimpleCoil(%i,nmArray)', problemID); 

invoke(mn, 'processcommand', cmdstring);
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
coil = invoke(mn, 'getvariant', 0);

end
