function PIDs = mn_ds_getSolvedProblems(doc)
%   MN_GETSOLVEDPROBLEMS Return an array of all solved problem IDs
%   mn_getSolvedProblems(doc)
%   doc = pointer to the document within the MagNet project
%  
%
%   Returns PIDs - array of all solved problem IDs (0 if none)
%
%

Sol = invoke(doc, 'GetSolution'); 
vals = invoke (Sol, 'getSolvedProblems');
if isempty(vals)
    PIDs = 0;
else
    for i=1:length(vals)
        PIDs(i) = vals{i};
    end
end
end

