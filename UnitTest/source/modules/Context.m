classdef Context
    % CONTEXT is basic experimental object which
    % holds all the context variables instead of
    % passing them as global variables.
    % It even stores a configuration of experiment.
    %
    % c = Context; - uses default 'context.csv'
    % c = Context('C:\Path\to\your\source.csv');
    %
    properties
       redX;
       redY;
       redZ;
       sourceTable = 'config/AEDist2017_source.csv';
       nTrial;
    end
    
    methods
        function obj = Context(source)
            % Constructor of the class
            % Input:
            %   If none default path and file is
            %   used as 'context.csv' in root.
            %   If string is passed, context expect
            %   to find a comma delimited CSV in there.
            %
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
            % VIEWCONTEXT prints out a common holded
            % context for each trial.
            for i = 1:obj.nTrial
                fprintf('Trial %d\tRed X:\t%0.f2, Red Y:\t%0.f2, Red Z:\t%0.f2\n',...
                    i, obj.redX(i), obj.redY(i), obj.redZ(i));
            end
        end
        
        function readTrial(obj, trial)
            % READTRIAL prints out specified trial defined
            % by trial number.
            fprintf('Trial %d\tRed X:\t%0.f2, Red Y:\t%0.f2, Red Z:\t%0.f2\n',...
               trial, obj.redX(trial), obj.redY(trial), obj.redZ(trial)); 
        end
        
        function t = extractTrial(obj, trial)
            % EXTARCTTRIAL extracts specified trial based on
            % trial number to structure whic can be passed into
            % Logger object for writing to logfile.
            % See LOGGER, LOGGER.WRITEDATA method
            %
            t = struct('redX', obj.redX(trial), 'redY', obj.redY(trial), 'redZ', obj.redZ(trial)); 
        end
    end
end