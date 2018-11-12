function [status] = mn_d_save(doc, dpath, stype)
%MN_D_SAVE Save this model.
%   [status] = mn_d_save(doc, dpath) Save the full model (with any mesh and
%   solved solutions).
%   
%   [status] = mn_d_save(doc, dpath, stype) Save the model as either a full
%   model or a reduced model based on the value of stype.
%
%   This is a wrapper for Document::save
%
%   stype can be one of two options:
%       Consts = invoke(mn, 'getConstants');
%       stype = get(Consts,'InfoWholeModel')
%       stype = get(Consts,'InfoMinimalModel')
%
%   Returns 0 if successful, nonzero is an error code.
%
%   Important: as of MagNet 7.8.3.5, if the file doesn't save successfully,
%   MagNet will require the user to respond within the GU if visible is set
%   to true. If the process is made invisible, no user response is
%   required.

if nargin < 3
    mn = invoke(doc, 'getapplication');
    Consts = invoke(mn, 'getConstants');
    stype = get(Consts, 'InfoWholeModel');
end

status = invoke(doc, 'save', dpath, stype);
end
