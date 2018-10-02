% Code tests jitter for sending EEG tags
% in serial port to Biosemi recording SW
% from PsychToolBox Stereo experiment
%
% Michael Tesar
% 2.10.2018 16:53
%
clear; close all; clc;
close_ports();
jitter = test_tag_jitter(100);

% Visualize jitter data
% Boxplot
boxplot(jitter, 'Labels', {'Old','New'}, 'whisker',2);
xlabel('Methods');
ylabel('EEG tag jitter (ms)');
title('Testing EEG jitter for old and new methods');
% Line plot
plot(jitter);
ylabel('EEG tag jitter (ms)');
xlabel('Number of trial');
legend({'Old method','New method'}, 'Location', 'southwest');
legend('boxoff');

function jitter = test_tag_jitter(times)
% TEST_TAG_JITTER tests a jitter based on opening
% sending and closing serial port.
%
    % Test old function
    jitter1 = zeros(1, times);
    for test = 1:times
       tic;
       sendtag(1);
       jitter1(test) = toc*1000;
       disp(sprintf('TEST 1: %.2f %%', test/times));
    end
    
    % Test new function
    eeg = serial('COM3', 'BAUD', 115200, 'DataBits', 8);
    fopen(eeg);
    jitter2 = zeros(1, times);
    for test = 1:times
       tic;
       sendtag2(eeg, 1);
       jitter2(test) = toc*1000;
       disp(sprintf('TEST 2: %.2f %%', test/times));
    end
    fclose(eeg);
    
    % Return jitter variable
    jitter = [jitter1; jitter2]';
end

function sendtag(tag)
% SENDTAG is communication function with Biosemi ActiveTwo
% via serial port as emulator to paraller port.
%
    eeg = serial('COM3', 'BAUD', 115200, 'DataBits', 8);
    fopen(eeg);
    try
        fwrite(eeg, tag);
    catch ME
        warning(strcat(ME, ' cannot write tag'));
        fclose(eeg);
    end
    fclose(eeg);
end

function sendtag2(eeg, tag)
% SENDTAG2 is communication function with Biosemi ActiveTwo
% via serial port as emulator to serial port with as less
% jitter as possible.
%
fwrite(eeg, tag);
end

function close_ports()
% In any case the port stays open CLOSE_PORTS
% shutdown all ports
%
     if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
     end
end