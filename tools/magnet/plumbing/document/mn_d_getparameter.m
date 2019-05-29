function [value, paramType] = mn_d_getparameter(mn, opath, param)
%MN_DV_GETPARAMETER Read a parameter value.
%   [value, paramType] mn_d_getparameter(doc, objectpath, param_name)
%       Sets that specified parameter name. 

%   objectpath is '' for a global parameter. 
%
%   paramType may be one of five options:
%       Consts = invoke(mn, 'getConstants');
%       get(Consts,'InfoStringParameter')
%       get(Consts,'InfoNumberParameter')
%       get(Consts,'InfoArrayParameter')
%       get(Consts,'InfoVariantParameter')
%       get(Consts,'InfoNoParameter')
%
%   This is a wrapper for Document::getParameter

invoke(mn, 'processcommand', 'ReDim strArray(0)');
invoke(mn, 'processcommand', 'ReDim pType(0)');
invoke(mn, 'processcommand', ...
    ['pType = getDocument().getParameter(' ...
    '"' opath '", "' param '", strArray)']);

invoke(mn, 'processcommand', 'Call setVariant(0, strArray, "MATLAB")');
value = invoke(mn,  'getVariant', 0, 'MATLAB');
invoke(mn, 'processcommand', 'Call setVariant(0, pType, "MATLAB")');
paramType = invoke(mn,  'getVariant', 0, 'MATLAB');
%invoke(doc, 'getParameter', opath, param, value, ptype)

end
