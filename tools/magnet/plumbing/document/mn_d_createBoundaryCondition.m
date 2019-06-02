function mn_d_createBoundaryCondition(mn, componentNames, face, name)
%MN_D_CREATEBOUNDARYCONDITION Creates a boundary condition.
%   mn_d_createBoundaryCondition(mn, surfacesFace, Face , name )
%   componentNames - Single string or a cell array of strings of the
%       geometry to which boundary condition is assigned. 
%   face - Array containing the face number within the component to which 
%   the boundary condition is applied. 
%   name: name assigned to the boundary condition
%   This is a wrapper for Document::createBoundaryCondition

    if iscell(componentNames) 
        invoke(mn, 'processcommand', ...
        sprintf('REDIM nmArray(%i)', length(componentNames)-1));
        for i = 1:length(componentNames)
            invoke(mn, 'processcommand', ...
            sprintf('nmArray(%i)= "%s,Face#%i"', i-1, componentNames{i}, face(i)));
        end
    else
        
        invoke(mn, 'processcommand', 'REDIM nmArray(0)');
        invoke(mn, 'processcommand', ...
        sprintf('nmArray(0)= "%s,Face#%i"', componentNames, face));    
    end
cmdstring = sprintf('call getDocument.createBoundaryCondition(nmArray,"%s")', name); 
invoke(mn, 'processcommand', cmdstring);
end