function returnVector = mn_readFieldAtPoints(mn, thePoints, ...
                                                fieldName, pid, time)
%   MagNet_GetFieldAtPoints Gets the field data at specific points
%
%   mn: pointer to the MagNet object
%   thePoints = [x1 y1 z1; x2 y2 z2; ...]
%   pid: Problem ID (1 if there is only one project, optional in this
%           case)
%   time: time to evaluate the field at (for transient solution) --
%           not used for static solution
%   fieldName: 'B' for magnetic field, special options can be used for time
%       harmonic
%   Returns DataPoints: column 1 is the time step, column 2 is the field
%           magnitude
%
%

tempV = [0]; 
if (exist('pid') ~= 1)
    pid = 1;
end
if (exist('time') ~= 1)
    invoke(mn, 'processcommand', ...
        ['Set Mesh = getDocument.getSolution.getMesh(' num2str(pid) ')']);
else
    invoke(mn, 'processcommand', ...
        ['Set Mesh = getDocument.getSolution.getMesh(Array(' num2str(pid) ', ' num2str(time) '))']);
end
invoke(mn, 'processcommand', ...
    ['Set Field = getDocument.getSolution.getSystemField(Mesh, "' fieldName '")']);
invoke(mn, 'processcommand', 'ReDim FieldVector(0)');
temp = size(thePoints);
for i=1:temp(1)
    %fprintf('\n i = %g of %g ', i, temp(1))
    thePoint = thePoints(i,:);	
    invoke(mn, 'processcommand', ['Call Field.getFieldAtPoint(' ...
        num2str(thePoint(1)) ', ' num2str(thePoint(2)) ', ' num2str(thePoint(3)) ...
        ', FieldVector)']);	
    invoke(mn, 'processcommand', 'Call setVariant(0, FieldVector, "MATLAB")');
    tempV = invoke(mn, 'getVariant', 0, 'MATLAB');
    if sum(isnan(cell2mat(tempV))) > 0
        throw(MException('Vector:IsNaN','NaN found for field quantity'));
    end
    for n =1:length(tempV)
        returnVector(i,n) = tempV{n};
    end
end