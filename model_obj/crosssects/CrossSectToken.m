classdef CrossSectToken
    %CROSSSECTTOKEN Data generated upon drawing a cross-section
    %   Objects of this class contain data that was generated when a 
    %   cross-section is drawn. 
    
    properties(GetAccess = 'public', SetAccess = 'protected')
        token = []; %Untyped token created by the drawing tool
        innerCoord; %x,y coordinate that is located somewhere inside the cross-section (does not have to be the center        
    end
    
    methods        
        function obj = CrossSectToken(innerCoord, token)
            %CROSSSECTTOKEN Constructor of a CrossSectToken with a token
            %   This cross-section token object consists of a coordinate
            %   and a token
            validateattributes(innerCoord, {'double'}, {'size', [1,2]});            
            obj.innerCoord = innerCoord; %TO DO: How to deal with units??
            obj.token = token;
        end        
    end
end

