classdef TokenDraw
    % TOKENDRAW Data generated upon drawing an arc/line
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        drawToken;
        geometryType; % 1 is arc, 0 is line
    end
    
    methods        
        function obj = TokenDraw(drawToken, geometryType)
            % TOKENDRAW Constructor of a TokenDraw
            
            % TODO: validate `geometryType` is either 1/0...            
            
            obj.drawToken = drawToken;
            obj.geometryType = geometryType;
        end        
    end
end

