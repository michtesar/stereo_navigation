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
config;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [], 0, 0);
initialize(viewAngle);

%introduction;

KbName('UnifyKeyNames');
while 1
    Screen('BeginOpenGL', win);
        setview(cameraAngle);
        try
            drawsphere(-RedX, RedZ, RedY, [1.0, 0.0, 0.0, 1.0]);
            drawsphere(-WhiteX, WhiteZ, WhiteY, [1.0, 1.0, 1.0, 1.0]);
            if drawLines
                drawviewline; 
                drawaxes;
            end
            drawmark(-0.017, 0.483);
            drawarena;
        catch
            psychlasterror;
            sca;
        end
    Screen('EndOpenGL', win);
    infotext;
    Screen('Flip', win);
    startSecs = GetSecs;
    
    % Keyboard response collection
    KbWait;
    [keyIsDown, timeSecs, keyCode] = KbCheck;
    keyCode = find(keyCode, 1);
    
    if keyIsDown
       fprintf('"%s" typed at time %.3f seconds\n',...
           KbName(keyCode), timeSecs - startSecs); 
       if keyCode == KbName('ESCAPE');
           break;
       elseif keyCode == KbName('v');
           topView = ~topView;
       elseif keyCode == KbName('l');
           drawLines = ~drawLines;
       end
       KbReleaseWait;
    end
    Screen('Flip', win);
end
sca;
end