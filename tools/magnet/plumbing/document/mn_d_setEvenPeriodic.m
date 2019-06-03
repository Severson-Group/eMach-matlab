function[status] = mn_d_setEvenPeriodic(mn, name, scaleFactor, rotationAngle, rotationAxis, mirrorNormal, shiftVector, center)
%MN_D_SETEVENPERIODIC Makes the boundary condition even periodic
%   mn_d_setEvenPeriodic(mn, name,scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center)
%   name: name assigned to the boundary condition
%   scaleFactor: set the scale_factor value
%   rotationAngle: set the angle of rotation in degrees
%   rotationAxis: rotation axis about which rotation_angle is set
%   mirrorNormal: normal vector to the mirror plane
%   shiftVector: coordinates of the shift vector in (mm)
%   center: reference point coordinates in (mm)
%   This is a wrapper for Document::setEvenPeriodic

 if ~isempty(shiftVector)
    shift = 'ShiftVector';
    invoke(mn, 'processcommand', 'REDIM ShiftVector(2)');
    invoke(mn, 'processcommand', sprintf('ShiftVector(0)= %s', num2str(shiftVector(1))));
    invoke(mn, 'processcommand', sprintf('ShiftVector(1)= %s', num2str(shiftVector(2))));
    invoke(mn, 'processcommand', sprintf('ShiftVector(2)= %s', num2str(shiftVector(3))));
else
    shift = 'Null';
end


  if  ~isempty(rotationAxis)
    axis = 'RotationAxis';
    invoke(mn, 'processcommand', 'REDIM RotationAxis(2)');
    invoke(mn, 'processcommand', sprintf('RotationAxis(0)= %s', num2str(rotationAxis(1))));
    invoke(mn, 'processcommand', sprintf('RotationAxis(1)= %s', num2str(rotationAxis(2))));
    invoke(mn, 'processcommand', sprintf('RotationAxis(2)= %s', num2str(rotationAxis(3))));
else
    axis = 'Null';
end

 if  ~isempty(mirrorNormal)
    normal = 'MirrorNormal';
    invoke(mn, 'processcommand', 'REDIM MirrorNormal(2)');
    invoke(mn, 'processcommand', sprintf('MirrorNormal(0)= %s', num2str(mirrorNormal(1))));
    invoke(mn, 'processcommand', sprintf('MirrorNormal(1)= %s', num2str(mirrorNormal(2))));
    invoke(mn, 'processcommand', sprintf('MirrorNormal(2)= %s', num2str(mirrorNormal(3))));
else
    normal = 'Null';
end

   if ~isempty(center)
    reference = 'Center';
    invoke(mn, 'processcommand', 'REDIM Center(2)');
    invoke(mn, 'processcommand', sprintf('Center(0)= %s', num2str(center(1))));
    invoke(mn, 'processcommand', sprintf('Center(1)= %s', num2str(center(2))));
    invoke(mn, 'processcommand', sprintf('Center(2)= %s', num2str(center(3))));
else
    reference = 'Null';
end

arguments = sprintf('"%s",%s,%s,%s, %s, %s, %s',...
    name,num2str(scaleFactor),num2str(rotationAngle),axis,normal,shift,reference);

invoke(mn, 'processcommand', ['ret = getDocument().setEvenPeriodic(' arguments ')']);

invoke(mn, 'processcommand', 'call setvariant(0, ret)');
status = invoke(mn, 'getvariant', 0);
end