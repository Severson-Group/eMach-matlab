function [mnerror] = mn_dv_makeComponentInALine(mn, sweepDist, name, material, flags)
%MN_DV_MAKECOMPONENTINALINE Extrude a cross-section into a component
%   [mnerror] = mn_dv_makeComponentInALine(mn, sweepDist, name, material)  
%   extrudes a component
%
%   [mnerror] = mn_dv_makeComponentInALine(mn, sweepDist, name, material, flags)  
%   extrudes a component using optional flags.
%
%   This is a wrapper for the Document::View::makeComponentInALine function
%
%   Variable Details:
%   mn          - MagNet activexserver object
%   sweepDist   - Length to extrude a component
%   name        - name of the newly extruded component
%   material    - name of the material to use
%   flags       - Optional array of constants for extruding
%       flags(1) = get(Consts,'infoMakeComponentUnionSurfaces'));
%       flags(2) = get(Consts,'infoMakeComponentIgnoreHoles'));
%       flags(3) = get(Consts,'infoMakeComponentRemoveVertices'));
%
%   Returns mnerror = 0 for success, 1 for failure.


validateattributes(sweepDist, {'numeric'}, {'nonnegative','nonempty'});
validateattributes(name, {'char'}, {'nonempty'});
validateattributes(material, {'char'}, {'nonempty'});

matstring = sprintf('Name=%s',material);
invoke(mn, 'processcommand', 'REDIM nmArray(0)');
invoke(mn, 'processcommand', sprintf('nmArray(0)= "%s"', name));
 
cmdstring = sprintf(...
    'ret = getDocument.getView.makeComponentInALine(%.2f,nmArray,"%s"', ...
             sweepDist, matstring);
         
if nargin > 4 %we have object code(s) to consider
    validateattributes(flags, {'numeric'}, {'row','integer'})
    stflags = sprintf('%i Or ', flags);
    cmdstring = sprintf('%s,%s)', cmdstring, stflags(1:end-3));        
else
    cmdstring = sprintf('%s)', cmdstring);        
end

invoke(mn, 'processcommand', cmdstring);
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
mnerror = invoke(mn, 'getvariant', 0);
