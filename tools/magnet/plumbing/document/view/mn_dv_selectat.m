function [] = mn_dv_selectat(mn, locxy, seltype, objcode)
%MN_DV_SELECTAT Select an object.
%   [] = mn_dv_selectat(mn, [loc_x, _y], seltype) selects any 
%   object at the x,y coordinate location specified.
%
%   [] = mn_dv_selectat(mn, [loc_x, _y], seltype, objcode) selects an 
%   object of type objcode at the x,y coordinate location specified
%
%   [] = mn_dv_selectat(mn, [loc_x, _y], seltype, [cd1, cd2, ...]) selects an 
%   object of any type listed in [cd1, cd2, ...] at the x,y coordinate 
%   location specified
%
%   This is a wrapper for the Document::View::selectAt function.
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


validateattributes(locxy, {'numeric'}, {'size', [1,2]})
validateattributes(seltype, {'numeric'}, {'integer'})

cmdstring = sprintf('Call getDocument.getView.selectAt(%f,%f,%i', ...
            locxy(1), locxy(2), seltype);
if nargin > 3 %we have object code(s) to consider
    validateattributes(objcode, {'numeric'}, {'row','integer'})
    stobj = sprintf('%i,', objcode);
    cmdstring = sprintf('%s,Array(%s)', cmdstring, stobj(1:end-1));    
end
cmdstring = strcat(cmdstring, ')');

invoke(mn, 'processcommand', cmdstring);


