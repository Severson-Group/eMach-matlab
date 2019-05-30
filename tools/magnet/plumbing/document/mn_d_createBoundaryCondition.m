function mn_d_createBoundaryCondition(mn, surfacesFace, Face , name )
%MN_D_CREATEBOUNDARYCONDITION Creates a boundary condition.
%   mn_d_createBoundaryCondition(mn, surfacesFace, Face , name )
%   surfacesFace - Single string or a cell array of strings of the
%       geometry to which boundary condition is assigned. 
%   Face - The face number within the component to which the boundary condition is applied. 
%   name: name assigned to the boundary condition
%   This is a wrapper for Document::createBoundaryCondition

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
end