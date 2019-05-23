function mn_d_setEvenPeriodic(mn, x, y, z, name )
%MN_D_SETEVENPERIODIC Makes the boundary condition even periodic
%   mn_d_setEvenPeriodic(mn, x, y, z, name )
%   problemID - integer problem ID. 
%   x,y,z - The coordinates of the shift vector.
%   name: name assigned to the boundary condition
%   This is a wrapper for Document::setEvenPeriodic
invoke(mn, 'processcommand', 'REDIM ShiftVector(2)');
invoke(mn, 'processcommand', sprintf('ShiftVector(0)= %s', num2str(x)));
invoke(mn, 'processcommand', sprintf('ShiftVector(1)= %s', num2str(y)));
invoke(mn, 'processcommand', sprintf('ShiftVector(2)= %s', num2str(z)));
invoke(mn, 'processcommand', sprintf('call getDocument.setEvenPeriodic("%s",Null,Null,Null,Null,ShiftVector,Null)',name));
end