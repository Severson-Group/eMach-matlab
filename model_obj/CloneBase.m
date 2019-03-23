classdef CloneBase < matlab.mixin.Copyable
    %CLONEBASE provides two static methods that are useful to avoid duplicated
    %name of objects.
    
    properties
    end
    
    methods(Static)
        function out = setGetNumObjects(obj)
            persistent counter;
            if isempty(counter)
                counter = 0;
            end
            if nargin
                obj.setGetObjectNamePool(counter, obj);
                counter = counter + 1;
            end
            out = counter;
        end
        
        function out = setGetObjectNamePool(counter, obj)
            persistent objectNamePool;
            if nargin
                if counter == 0
                    % Initialize the object array
                    objectNamePool = {obj.name, };
                else
                    objectNamePool{end+1} = obj.name;
                end
            end
            out = objectNamePool;
            % debug
            % counter, out
            
            % Compare new name with the names from object pool.
            len = length(objectNamePool);
            for i = 1:len
                for j = i+1:len
                    if strcmp(objectNamePool(i), objectNamePool(j))
                        error('Error: There is already an object of CloneBase class named "%s".', char(objectNamePool(i)))
                    end
                end
            end 
        end
    end
end

