function [] = mn_d_setparameter(doc, opath, param, value, ptype)
%MN_DV_SETPARAMETER Set a parameter.
%   mn_d_setparameter(doc, objectpath, param_name, new_value, param_type)
%       Sets that specified parameter name. 

%   objectpath is '' for a global parameter. 
%
%   param_type can be one of four options:
%       Consts = invoke(mn, 'getConstants');
%       get(Consts,'InfoStringParameter')
%       get(Consts,'InfoNumberParameter')
%       get(Consts,'InfoArrayParameter')
%       get(Consts,'InfoVariantParameter')
%
%   This is a wrapper for Document::setParameter

invoke(doc, 'setParameter', opath, param, value, ptype)

end
