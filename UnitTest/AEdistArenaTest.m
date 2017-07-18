function AEdistArenaTest
% AEDistArenaTest is unit test of 2D AEDist2017 experiment
%
% Coordinate system:
%   X - backwards (negative goes right, positive goes left)
%   Y - is up and down
%   Z - far or close the object
%
global win;
global winRect;

testingvalues;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [], 0, 0);
initialize;

%introduction;

Screen('BeginOpenGL', win);
    setview(cameraAngle);
    try
        drawsphere(RedX, RedZ, RedY, [1.0, 0.0, 0.0, 1.0]);
        drawsphere(WhiteX, WhiteZ, WhiteY, [1.0, 1.0, 1.0, 1.0]);
        drawviewline; 
        drawaxes;
        drawmark(0.017, 0.483);
        drawfloor;
        drawarena;
    catch
        psychlasterror;
        sca;
    end
Screen('EndOpenGL', win);
infotext;
Screen('Flip', win);
KbWait;
sca;
return