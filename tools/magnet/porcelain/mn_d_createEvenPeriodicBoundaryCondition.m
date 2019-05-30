function mn_d_createEvenPeriodicBoundaryCondition(mn, surfacesFace, Face,...
    name, scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center)
%MN_D_CREATEBOUNDARYCONDITION Creates an even periodic boundary condition.
%   mn_d_createEvenPeriodicBoundaryCondition(mn, surfacesFace, Face,
%    name, scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center)%      
%   surfacesFace - Single string or a cell array of strings of the
%       components to which boundary condition is applied. 
%   Face - The face number within the component to which the boundary condition is applied. 
%   name: name assigned to the boundary condition
%   scale_factor: set the scale_factor value
%   rotation_angle: set the angle of rotation in degrees
%   RotationAxis: rotation axis about which rotation_angle is set
%   MirrorNormal: normal vector to the mirror plane
%   ShiftVector: coordinates of the shift vector in (mm)
%   Center: reference point coordinates in (mm)
%   This is a porcelain function that uses mn_d_createBoundaryCondition and
%   mn_d_setEvenPeriodic to create even periodic boundary condition
mn_d_createBoundaryCondition(mn, surfacesFace, Face , name );
mn_d_setEvenPeriodic(mn, name,scale_factor, rotation_angle, RotationAxis, MirrorNormal, ShiftVector, Center);