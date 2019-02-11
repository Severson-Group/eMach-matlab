function [] = mn_dv_viewAll(mn)
%MN_DV_VIEWALL View the entire model
%   [] = mn_dv_viewAll(mn)


invoke(mn, 'processcommand', 'Call getDocument().getView().viewAll()');


