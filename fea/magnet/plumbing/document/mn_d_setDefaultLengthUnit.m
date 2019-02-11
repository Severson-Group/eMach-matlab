function [] = mn_d_setDefaultLengthUnit(doc, userUnit, makeAppDefault)
%MN_D_SETDEFAULTLENGTHUNIT Set the default unit for length.
%   mn_d_setDefaultLengthUnit(doc, userUnit, makeAppDefault)
%       Sets the units for length. 

%   userUnit can be one of these options:
%       'kilometers'
%       'meters'
%       'centimeters'
%       'millimeters'
%		'microns'
%		'miles'
%		'yards'	
%		'feet'
%       'inches'
%
%   This is a wrapper for Document::setDefaultLengthUnit

invoke(doc, 'setDefaultLengthUnit', userUnit, makeAppDefault)

end
