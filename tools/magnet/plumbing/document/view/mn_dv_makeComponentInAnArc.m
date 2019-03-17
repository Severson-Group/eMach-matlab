function [mnerror] = mn_dv_makeComponentInAnArc(mn, center, axis, angle, name, material, flags)
%MN_DV_MAKECOMPONENTINANARC Extrude a cross-section along an arc
%   [mnerror] = mn_dv_makeComponentInAnArc(mn, center, axis, angle, name, material)  
%   extrudes a component
%
%   [mnerror] = mn_dv_makeComponentInAnArc(mn, center, axis, angle, name, material, flags)  
%   extrudes a component using optional flags.
%
%   This is a wrapper for the Document::View::makeComponentInAnArc function
%
%   Variable Details:
%   mn          - MagNet activexserver object
%   center      - x,y coordinates of center point of rotation
%   axis        - x,y coordinate on the axis of ration (negative reverses
%               direction) (0, -1) to rotate clockwise about the y axis
%   angle       - Angle of rotation in degrees
%   name        - name of the newly extruded component
%   material    - name of the material to use
%   flags       - Optional array of constants for extruding
%       flags(1) = get(Consts,'infoMakeComponentUnionSurfaces'));
%       flags(2) = get(Consts,'infoMakeComponentIgnoreHoles'));
%       flags(3) = get(Consts,'infoMakeComponentRemoveVertices'));
%
%   Returns mnerror = 0 for success, 1 for failure.

validateattributes(center, {'numeric'}, {'size',[1,2]})
validateattributes(axis, {'numeric'}, {'size',[1,2]})
validateattributes(angle, {'numeric'}, {'nonempty'});
validateattributes(name, {'char'}, {'nonempty'});
validateattributes(material, {'char'}, {'nonempty'});

matstring = sprintf('Name=%s',material);
invoke(mn, 'processcommand', 'REDIM nmArray(0)');
invoke(mn, 'processcommand', sprintf('nmArray(0)= "%s"', name));
 
cmdstring = sprintf(...
    'ret = getDocument.getView.makeComponentInAnArc(%i,%i,%i,%i,%i,nmArray,"%s"', ...
             center(1), center(2), axis(1), axis(2), angle, matstring);
         
if nargin > 6 %we have object code(s) to consider
    validateattributes(flags, {'numeric'}, {'row','integer'})
    stflags = sprintf('%i Or ', flags);
    cmdstring = sprintf('%s,%s)', cmdstring, stflags(1:end-3));        
else
    cmdstring = sprintf('%s)', cmdstring);        
end

invoke(mn, 'processcommand', cmdstring);
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
mnerror = invoke(mn, 'getvariant', 0);
