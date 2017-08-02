classdef Logger
    properties
        source = 'logfile.csv';
        fileId;
    end
   
    methods
        function obj = Logger(source)
           if nargin < 1
               fileId = fopen(strcat(date, '_', obj.source), 'a');
           else
               obj.source = strcat(date, '_', source);
               fileId = fopen(strcat(date, '_', obj.source), 'a');
           end
           obj.fileId = fileId;
           fprintf(obj.fileId, 'Trial, RedX, RedY, RedZ\n');
        end
        
        function closeInstance(obj)
           try
               fclose(obj.fileId);
           catch ME
               warning(ME)
           end
        end
        
        function writeData(obj, n, data)
            fprintf(obj.fileId, '%d, %f, %f, %f\n',...
                    n, data.redX, data.redY, data.redZ);
        end
    end
end
    