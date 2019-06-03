function[bc_path]= mn_d_createBoundaryCondition(mn, pathArray, name)
%MN_D_CREATEBOUNDARYCONDITION Creates a boundary condition.
%   mn_d_createBoundaryCondition(mn, surfacesFace, Face , name )
%   pathArray - Single string or a cell array of strings of the
%       geometry to which boundary condition is assigned. This will be in
%       the format {compName,Face#i} where compName is the name of the
%       component and Face#i is the face number to which the boundary
%       condition is applied. i is an integer denoting face number.
%   name: name assigned to the boundary condition
%   This is a wrapper for Document::createBoundaryCondition
    if iscell(pathArray) 
        invoke(mn, 'processcommand', ...
        sprintf('REDIM nmArray(%i)', length(pathArray)-1));
       
        for i = 1:length(pathArray)
            invoke(mn, 'processcommand', ...
            sprintf('nmArray(%i)= "%s"', i-1, pathArray{i}));
        end
    else
        
        invoke(mn, 'processcommand','REDIM nmArray(0)');
        invoke(mn, 'processcommand', ...
        sprintf('nmArray(0)= "%s"', pathArray));    
    end
    
cmdstring = sprintf('ret = getDocument.createBoundaryCondition(nmArray,"%s")', name); 
invoke(mn, 'processcommand', cmdstring);
invoke(mn, 'processcommand', 'call setvariant(0, ret)');
bc_path = invoke(mn, 'getvariant', 0);

end