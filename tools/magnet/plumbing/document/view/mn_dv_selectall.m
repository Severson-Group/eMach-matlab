function [] = mn_dv_selectall(mn, seltype, objcode)
%MN_DV_SELECTALL Select all objects of a certain type.
%   [] = mn_dv_selectall(mn, seltype) selects all objects following the
%   instructions of seltype.
%
%   [] = mn_dv_selectall(mn, seltype, objcode) selects all objects of type 
%   objcode following the instructions of seltype

%   [] = mn_dv_selectall(mn, seltype, [cd1, cd2, ...]) selects all objects
%   of any type listed in [cd1, cd2, ...] following the instructions of
%   seltype.
%
%   This is a wrapper for the Document::View::selectAll function.
%
%   Variable Details:
%   seltype     - Instructions on how to add this selection. Valid options:
%               Consts = invoke(mn, 'getConstants');
%               seltype = get(Consts,'InfoSetSelection')
%               seltype = get(Consts,'InfoAddToSelection')
%               seltype = get(Consts,'InfoToggleInSelection')
%
%   objcode     - Type of object that can be selected. This can be an array
%               if multiple object types should be considered. A lengthy 
%               list of valid options are privded in the MagNet help
%               documentation at Scripting/Scripting constants/Object code.
%               Frequent examples include
%               Consts = invoke(mn, 'getConstants');
%               seltype = get(Consts,'infoLine') - line edge of a component
%               seltype = get(Consts,'infoSliceLine') - line on the
%               construction slice
%               seltype = get(Consts,'InfoArc') - arc edge of a component
%               seltype = get(Consts,'infoSliceArc') - arc on the
%               construction slice
%               seltype = get(Consts,'infoSurace') - surface of a component
%               seltype = get(Consts,'infoSliceSurface') - surface on the
%               construction slice


validateattributes(seltype, {'numeric'}, {'integer'})

cmdstring = sprintf('Call getDocument.getView.selectAll(%i', seltype);
if nargin > 2 %we have object code(s) to consider
    validateattributes(objcode, {'numeric'}, {'row','integer'})
    
    stobj = sprintf('%i,', objcode);
    cmdstring = sprintf('%s,Array(%s)', cmdstring, stobj(1:end-1));    
end
cmdstring = strcat(cmdstring, ')');

invoke(mn, 'processcommand', cmdstring);


