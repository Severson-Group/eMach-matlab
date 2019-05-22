function [boundary] = mn_d_createEvenPeriodicBoundaryCondition(mn, problemID, surfacesFace, Face , x, y, z, name )
%MN_D_CREATEBOUNDARYCONDITION Creates an even periodic boundary condition.
%   mn_d_createBoundaryCondition(mn, problemID, surfacesFace, Face , x, y, z, name )
%      
%   problemID - integer problem ID. 
%   surfacesFace - Single string or a cell array of strings of the
%       components to which boundary condition is applied. 
%   Face - The face number within the component to which the boundary condition is applied. 
%   x,y,z - The coordinates of the shift vector.
%   name: name assigned to the boundary condition
%   This is a wrapper for Document::createBoundaryCondition
validateattributes(problemID, {'numeric'}, {'positive','integer'});

invoke(mn, 'processcommand', 'getDocument.beginUndoGroup("Assign Boundary Condition")');
    if iscell(surfacesFace) 
        invoke(mn, 'processcommand', ...
        sprintf('REDIM nmArray(%i)', length(surfacesFace)-1));
        for i = 1:length(surfacesFace)
            invoke(mn, 'processcommand', ...
            sprintf('nmArray(%i)= "%s,Face#%i"', i-1, surfacesFace{i}, Face));
        end
    else
        
        invoke(mn, 'processcommand', 'REDIM nmArray(0)');
        invoke(mn, 'processcommand', ...
        sprintf('nmArray(0)= "%s,Face#%i"', surfacesFace, Face));    
    end
cmdstring = sprintf('call getDocument.createBoundaryCondition(nmArray,"%s")', name); 

invoke(mn, 'processcommand', cmdstring);
invoke(mn, 'processcommand', 'REDIM ShiftVector(2)');
invoke(mn, 'processcommand', sprintf('ShiftVector(0)= %s', num2str(x)));
invoke(mn, 'processcommand', sprintf('ShiftVector(1)= %s', num2str(y)));
invoke(mn, 'processcommand', sprintf('ShiftVector(2)= %s', num2str(z)));
invoke(mn, 'processcommand', sprintf('call getDocument.setEvenPeriodic("%s",Null,Null,Null,Null,ShiftVector,Null)',name));

invoke(mn, 'processcommand', 'ret = getDocument.endUndoGroup()');
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
boundary = invoke(mn, 'getvariant', 0);