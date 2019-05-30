function mn_d_setEvenPeriodic(mn, name,scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center)
%MN_D_SETEVENPERIODIC Makes the boundary condition even periodic
%   mn_d_setEvenPeriodic(mn, name,scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center)
%   name: name assigned to the boundary condition
%   scale_factor: set the scale_factor value
%   rotation_angle: set the angle of rotation in degrees
%   RotationAxis: rotation axis about which rotation_angle is set
%   MirrorNormal: normal vector to the mirror plane
%   ShiftVector: coordinates of the shift vector in (mm)
%   Center: reference point coordinates in (mm)
%   This is a wrapper for Document::setEvenPeriodic
if strcmp(ShiftVector,'Null')== 0
    shift = 'ShiftVector';
    invoke(mn, 'processcommand', 'REDIM ShiftVector(2)');
    invoke(mn, 'processcommand', sprintf('ShiftVector(0)= %s', num2str(ShiftVector(1))));
    invoke(mn, 'processcommand', sprintf('ShiftVector(1)= %s', num2str(ShiftVector(2))));
    invoke(mn, 'processcommand', sprintf('ShiftVector(2)= %s', num2str(ShiftVector(3))));
else
    shift = 'Null';
end

if strcmp(RotationAxis,'Null')== 0
    axis = 'RotationAxis';
    invoke(mn, 'processcommand', 'REDIM RotationAxis(2)');
    invoke(mn, 'processcommand', sprintf('RotationAxis(0)= %s', num2str(RotationAxis(1))));
    invoke(mn, 'processcommand', sprintf('RotationAxis(1)= %s', num2str(RotationAxis(2))));
    invoke(mn, 'processcommand', sprintf('RotationAxis(2)= %s', num2str(RotationAxis(3))));
else
    axis = 'Null';
end

if strcmp(MirrorNormal,'Null')== 0
    normal = 'MirrorNormal';
    invoke(mn, 'processcommand', 'REDIM MirrorNormal(2)');
    invoke(mn, 'processcommand', sprintf('MirrorNormal(0)= %s', num2str(MirrorNormal(1))));
    invoke(mn, 'processcommand', sprintf('MirrorNormal(1)= %s', num2str(MirrorNormal(2))));
    invoke(mn, 'processcommand', sprintf('MirrorNormal(2)= %s', num2str(MirrorNormal(3))));
else
    normal = 'Null';
end

if strcmp(Center,'Null')== 0
    reference = 'Center';
    invoke(mn, 'processcommand', 'REDIM Center(2)');
    invoke(mn, 'processcommand', sprintf('Center(0)= %s', num2str(Center(1))));
    invoke(mn, 'processcommand', sprintf('Center(1)= %s', num2str(Center(2))));
    invoke(mn, 'processcommand', sprintf('Center(2)= %s', num2str(Center(3))));
else
    reference = 'Null';
end

arguments = sprintf('"%s",%s,%s,%s, %s, %s, %s',...
    name,num2str(scale_factor),num2str(rotation_angle),axis,normal,shift,reference);
end