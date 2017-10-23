function infotext
% INFOTEXT is debugging tool for vizualization of
%   instructions for unit testing and some print out
%   of important variables in real time.
%
global win;
global winRect;
global viewAngle;

global RedX RedY RedZ
global WhiteX WhiteY WhiteZ
global cameraAngle cameraYaw
global CameraX CameraY CameraZ
global ReferenceX ReferenceY
global nTrial

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
text = strcat(text, sprintf('\nCamera pitch: %d\nCamera roll: %d\nView angle: %d\n',...
    cameraYaw, cameraAngle, viewAngle));
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
info = sprintf('\nAEDist Unit Test \n\nPsychtoolbox: %s \nOS: %s \nDate: %s',...
    ptbVersion(1:6), os, date);
DrawFormattedText(win, info, RectWidth(winRect) - 340, 40, [255 255 255], [], [], [], 1.2);
end