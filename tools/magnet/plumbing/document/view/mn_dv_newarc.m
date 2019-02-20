function [arc] = mn_dv_newarc(mn, centerxy, startxy, endxy)
%MN_DV_NEWARC Draw a circle in the current MagNet document.
%   [] = mn_dv_newarc(mn, [center_x,_y], [start_x, _y], [end_x, _y]) draws 
%   an arc
%
%   [arc] = mn_dv_newarc(mn, [center_x,_y], [start_x, _y], [end_x, _y]) 
%   draws an arc and returns the ISliceEdge interface object of the arc. 
%
%   This is a wrapper for the Document::View::newArc function.
%
%   Variable Details:
%   mn      - MagNet activexserver object
%   arc     - This can be used to select the arc object:
%       invoke(view, 'selectobject', arc, get(Consts,'InfoSetSelection'))

invoke (mn, 'processcommand', 'redim arc(0)')
invoke (mn, 'processcommand', sprintf(...
    'call getDocument.getView.newArc(%f, %f, %f, %f, %f, %f, arc)', ...
    centerxy(1), centerxy(2), ...
    startxy(1), startxy(2), ...
    endxy(1), endxy(2)));

if nargout > 0
    invoke(mn, 'processcommand', 'call setvariant(0, arc, "matlab")')
    arc = invoke(mn, 'getvariant', 0, 'matlab');    
end
