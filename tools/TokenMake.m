classdef TokenMake
    % TOKENMAKE Data generated upon making a component
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        csToken = [];
        prepSectToken = [];
        makeSolidToken = [];
    end
    
    methods        
        function obj = TokenMake(csToken, prepSectToken, makeSolidToken)
            % TOKENMAKE Constructor of a TokenMake
            
            % TODO: validate `csToken` has two properties: 1 - an ARRAY of 
            % CrossSectToken objects, 2 - innerCoords:
            % validateattributes(csToken, {});
            
            % TODO: consider validating the other tokens...
            
            obj.csToken = csToken;
            obj.prepSectToken = prepSectToken;
            obj.makeSolidToken = makeSolidToken;
        end        
    end
end

