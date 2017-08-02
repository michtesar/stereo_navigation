classdef Logger
    % LOGGER stores variables from context to a logfile
    % It has to be intialized and closed after witing.
    % If anything goes wrong you can allways write command
    % 'fclose('all');' to close all active connections to
    % any files on your drive or serial ports.
    %
    % l = Logger;
    % l = Logger('C\This\path\to\your\logfile.csv');
    %
    properties
        source = 'logfiles/logfile.csv';
        fileId;
    end
   
    methods
        function obj = Logger(source)
           if nargin < 1
               fileId = fopen(obj.source, 'a');
           else
               obj.source = source;
               fileId = fopen(obj.source, 'a');
           end
           obj.fileId = fileId;
           fprintf(obj.fileId, 'Trial, RedX, RedY, RedZ\n');
        end
        
        function closeInstance(obj)
            % CLOSEINSTANCE closes opened file. E.g, uninitialize
            % fileID object.
           try
               fclose(obj.fileId);
           catch ME
               disp(ME)
           end
        end
        
        function writeData(obj, n, data)
            % WRITEDATA is actuall logging method for
            % writing to text file (CSV).
            % Input:
            %   n (int) - trial number to extract
            %   data (struct) - structure of exported data
            %   from CONTEXT object.
            %
            fprintf(obj.fileId, '%d, %f, %f, %f\n',...
                    n, data.redX, data.redY, data.redZ);
        end
    end
end
    