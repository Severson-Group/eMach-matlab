function [line] = mn_dv_newline(mn, startxy, endxy)
%MN_DV_NEWLINE Draw a line in the current MagNet document.
%   [] = mn_dv_newline(mn, [start_x, _y], [end_x, _y]) draws a line
%
%   [line] = mn_dv_newline(mn, [start_x, _y], [end_x, _y]) 
%   draws an arc and returns the ISliceEdge interface object of the arc. 
%
%   This is a wrapper for the Document::View::newLine function.
%
%   Variable Details:
%   mn      - MagNet activexserver object
%   line     - This can be used to select the line object:
%       invoke(view, 'selectobject', line, get(Consts,'InfoSetSelection'))

invoke (mn, 'processcommand', 'redim line(0)')
invoke (mn, 'processcommand', sprintf(...
    'call getDocument.getView.newLine( %f, %f, %f, %f, line)', ...    
    startxy(1), startxy(2), ...
    endxy(1), endxy(2)));

if nargout > 0
    invoke(mn, 'processcommand', 'call setvariant(0, line, "matlab")')
    line = invoke(mn, 'getvariant', 0, 'matlab');    
end
