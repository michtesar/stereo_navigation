function infotext
global win;
global winRect;

nTrial = 1;
RedX = 1.1; RedY = 0.245; RedZ = 12.471;
WhiteX = -2.45; WhiteY = 0.002; WhiteZ = 3.147;
ReferenceX = 0.5; ReferenceY = 0.018;
CameraX = -0.5; CameraY = -2.1; CameraZ = 0.158;
CameraPitch = 146; CameraRoll = -20; ViewAngle = 90;

Screen('TextSize', win, 20);
text = sprintf('TRIAL INFO\n==========\nTrial\t %d \n\n', nTrial);
text = strcat(text, sprintf('\n\nRed X: %0.3f \nRed Y: %0.3f \nRed Z: %0.3f \n',...
    RedX, RedY, RedZ));
text = strcat(text, sprintf('\n\nWhite X: %0.3f \nWhite Y: %0.3f \nWhite Z: %0.3f \n',...
    WhiteX, WhiteY, WhiteZ));
text = strcat(text, sprintf('\n\nReference X: %0.3f\nReference Y: %0.3f\n',...
    ReferenceX, ReferenceY));
text = strcat(text, sprintf('\n\nCamera X: %0.3f\nCamera Y: %0.3f\nCamera Z: %0.3f\n',...
    CameraX, CameraY, CameraZ));
text = strcat(text, sprintf('\nCamera pitch: %0.3f\nCamera Roll: %0.3f\nView Angle: %0.3f\n',...
    CameraPitch, CameraRoll, ViewAngle));
DrawFormattedText(win, text, 40, 40, [255 255 0], [], [], [], 1.2);
fprintf('%s \n\n', text);

DrawFormattedText(win, 'Press ESCAPE to exit',...
    'center', RectHeight(winRect)-40, [255 0 0]);

DrawFormattedText(win, 'Toggle test/real view with V',...
    40, RectHeight(winRect)-40, [0 0 255]);

DrawFormattedText(win, 'Toggle view lines with L',...
    RectWidth(winRect) - 340, RectHeight(winRect)-40, [0 0 255]);

os = 'Uknown';
if ispc
    os = 'Windows';
elseif ismac
    os = 'macOS';
elseif isunix
    os = 'Linux';
end
ptbVersion = PsychtoolboxVersion;
info = sprintf('\nAEDist Unit Test \n\nPsychtoolbox: %s \nOS: %s \nDate: %s\nMichael Tesar',...
    ptbVersion(1:6), os, date);
DrawFormattedText(win, info, RectWidth(winRect) - 340, 40, [255 255 255], [], [], [], 1.2);
end