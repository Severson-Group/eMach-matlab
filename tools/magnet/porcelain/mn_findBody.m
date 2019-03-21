function bodyID = mn_findBody(mn, doc, keyword, pid)
%   MN_FINDBODY Identify a body that contains a keyword in a component name
%   mn_findBody(MN, Doc, Keyword, PID)
%   A solution must have been solved.
%
%   MN = pointer to the MagNet project
%   Doc = pointer to the document within the MagNet project
%   Keyword = search for a body which contains a component with this word
%           in its name
%   PID = Problem ID (1 if there is only one project -- optional in this
%           case)
%
%   Returns BodyID - ID number of body (0 for not found)
%
%
%   Example: 

if (exist('PID') ~= 1)
    pid = 1;
end

bodyID = 0;

sol = invoke(doc, 'GetSolution'); 
   
if invoke(sol, 'isSolved') == 1
    NumBodies = invoke(sol, 'getNumberOfBodies', pid);
    for i = 1 : NumBodies        
        Command= ['ReDim Paths(0) : '...
                'Call getDocument.getSolution.getPathsInBody(' ... 
                        num2str(pid) ', ' num2str(i) ', Paths)'];
        
        invoke(mn, 'processcommand', Command);
        invoke (mn,  'processcommand', 'Call setVariant(0, Paths, "MATLAB")'); 
        Temp = invoke (mn,  'getVariant', 0, 'MATLAB');
        %Search for keyword
        for n = 1 : length(Temp)
            tstr = Temp{n};
            in = strfind(tstr, keyword);
            if in >= 1
                %we found it!
                bodyID = i;
                break;
            end
        end
        if bodyID > 0 
            break;
        end
       
    end
    
    
    
end