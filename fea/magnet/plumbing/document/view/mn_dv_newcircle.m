function [arc1, arc2] = mn_dv_newcircle(mn, center, radius)
%MN_DV_CIRCLE Draw a circle in the current MagNet document.
%   [] = mn_dv_newcircle(mn, [center_x,center_y], radius) draws a circle
%
%   [arc1, arc2] = mn_dv_newcircle(mn, [center_x,center_y], radius) draws 
%   a circle and returns the ISliceEdge interface objects of each arc.
%
%   This is a wrapper for the Document::View::newCircle function.
%
%   Variable Details:
%   mn      - MagNet activexserver object
%   arc*    - This can be used to select the arc object:
%       invoke(view, 'selectobject', arc1, get(Consts,'InfoSetSelection'))

invoke (mn, 'processcommand', 'redim arcs(1)')
invoke (mn, 'processcommand', sprintf(...
    'call getDocument.getView.newCircle(%f, %f, %f, arcs(0), arcs(1))', ...
    center(1), center(2), radius));
if nargout > 0
    invoke(mn, 'processcommand', 'call setvariant(0, arcs, "matlab")')
    ret = invoke(mn, 'getvariant', 0, 'matlab');
    arc1 = ret{1};
    arc2 = ret{2};
end
