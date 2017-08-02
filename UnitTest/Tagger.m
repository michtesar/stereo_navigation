classdef Tagger
    % TAGGER is interface with Biosemi tagging system via
    % paraller port which is emulated by USB to serial.
    % This is a same behavior as Arduino does.
    %
    % t = Tagger;
    % t = Tagger('COM1', 9600, 8);
    %
   properties
      eeg;
      port;
      baudRate = 115200;
      dataBits = 8;
   end
   
   methods
       function obj = Tagger(port, baudRate, dataBits)
           % Constructor of the class
           % Input:
           %    If non arguments then default is used as
           %    follows: COM3 port, 115200 baud rate and 8 bits.
           %    Else you can specify your Biosemi setup.
           %
           if nargin < 1
               obj.port = 'COM3';
               obj.baudRate = '115200';
               obj.dataBits = 8;
           else
               obj.port = port;
               obj.baudRate = baudRate;
               obj.dataBits = dataBits;
           end
           try
                obj.eeg = serial(obj.port, 'BAUD', obj,baudRate,...
                    'DataBits', obj.dataBits);
           catch ME
               error(ME);
               warning('Cannot initialize communcation with Biosemi.');
           end
       end
       
       function sendTag(obj, tag)
           % SENDTAG is main method for sending tags to
           % Biosemi.
           % Input:
           %    tag (int) - integer tag
           %
           try
                fwrite(obj.eeg, tag); 
           catch ME
               error(ME);
               warning('Cannot send tag to Biosemi!');
           end
       end
       
       function uninitialize(obj)
          % UNINITIALIZE closes port communiccation
          % after you are finished with triggering.
          %
          try
              fclose(obj.eeg);
          catch ME
              error(ME);
              warning('Cannot uninitialize Biosemi, port is still running! Restart your PC');
          end
       end
   end
end