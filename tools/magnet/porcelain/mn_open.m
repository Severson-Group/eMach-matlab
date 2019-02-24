function [mn, doc] = mn_open(filename, mn, visible)
%MN_OPEN Open MagNet or a specific file.
%   [mn, doc] = mn_open() opens a new instance of MagNet with a new
%   document.
%   [mn, doc] = mn_open('filename') opens the file in a new 
%   instance of MagNet.
%   [mn, doc] = mn_open('filename', MN) opens the file in the MN
%   MagNet instance
%   [mn, doc] = mn_open('filename', MN, VISIBLE) opens the file in 
%   the MN MagNet instance with customizable visibility (true for visible)
%
%   mn and filename can be set to 0 to allow setting the visibility of a 
%   new instance.
%
%   Variables:
%       mn      - MagNet activexserver object
%       doc     - Document object

if nargin < 2
    mn = actxserver('MagNet.Application');
end
if nargin > 2
    if isnumeric(mn)
        mn = actxserver('MagNet.Application');
    end
    set(mn, 'Visible', visible);
end

if nargin > 0 && ~isnumeric(filename)
    doc = invoke(mn, 'openDocument', filename);
else
    doc = invoke(mn, 'newDocument');
end
  
