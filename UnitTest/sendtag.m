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