classdef TokenDraw
    % TOKENDRAW Data generated upon drawing an arc/line
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        segmentIndices;
        geometryType; % 1 is arc, 0 is line
    end
    
    methods        
        function obj = TokenDraw(segmentIndices, geometryType)
            % TOKENDRAW Constructor of a TokenDraw
            
            % TODO: validate `geometryType` is either 1/0...

            % TODO: validate `segmentIndices` is an integer...
            
            obj.segmentIndices = segmentIndices;
            obj.geometryType = geometryType;
        end        
    end
end

