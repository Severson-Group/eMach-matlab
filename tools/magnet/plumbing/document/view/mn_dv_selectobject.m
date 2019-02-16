function [success] = mn_dv_selectobject(view, opath, seltype)
%MN_DV_SELECTOBJECT Selects the specified object
%   [] = mn_dv_selectobject(view, opath, seltype) selects all objects following the
%   instructions of seltype.
%
%   This is a wrapper for the Document::View::selectObject function.
%
%   Variable Details:
%   opath       - Either the path or interface to an object.
%
%   seltype     - Instructions on how to add this selection. Valid options:
%               Consts = invoke(mn, 'getConstants');
%               seltype = get(Consts,'InfoSetSelection')
%               seltype = get(Consts,'InfoAddToSelection')
%               seltype = get(Consts,'InfoToggleInSelection')
%
%   Returns true if the object was selected, otherwise false.
%
%   Example:
%       arc = mn_dv_newarc(mn, [1,0], [4,0], [0,4])
%       mn_dv_selectobject(view, arc, get(Consts, 'infoSetSelection');
%


success = invoke(view, 'selectobject', opath, seltype);

