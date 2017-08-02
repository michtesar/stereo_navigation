classdef Context
    properties
       redX;
       redY;
       redZ;
       sourceTable = 'context.csv';
       nTrial;
    end
    
    methods
        function obj = Context(source)
            if nargin < 1
            	data = csvread(obj.sourceTable);
            else
                obj.sourceTable = source;
                data = csvread(source);
            end
            obj.redX = data(:, 1);
            obj.redY = data(:, 2);
            obj.redZ = data(:, 3);
            obj.nTrial = length(data);
        end
        
        function viewContext(obj)
            for i = 1:obj.nTrial
                fprintf('Trial %d\tRed X:\t%0.f2, Red Y:\t%0.f2, Red Z:\t%0.f2\n',...
                    i, obj.redX(i), obj.redY(i), obj.redZ(i));
            end
        end
        
        function readTrial(obj, trial)
            fprintf('Trial %d\tRed X:\t%0.f2, Red Y:\t%0.f2, Red Z:\t%0.f2\n',...
               trial, obj.redX(trial), obj.redY(trial), obj.redZ(trial)); 
        end
        
        function t = extractTrial(obj, trial)
           t = struct('redX', obj.redX(trial), 'redY', obj.redY(trial), 'redZ', obj.redZ(trial)); 
        end
    end
end