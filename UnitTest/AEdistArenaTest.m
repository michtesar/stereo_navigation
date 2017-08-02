function AEdistArenaTest(stereo)
% AEDistArenaTest is unit test of 2D AEDist2017 experiment
%
% Coordinate system:
%   X - backwards (negative goes right, positive goes left)
%   Y - is up and down
%   Z - far or close the object
%
global win;
global winRect;

if nargin == 0
    stereo = 0;
else
    stereo = 1;
end

run config\testingvalues;
run config\config;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [], stereo, 0);
initialize(viewAngle);

% Hide cursor and prevent from writing into console
HideCursor();
ListenChar(2);

%introduction;

KbName('UnifyKeyNames');
while 1
    for view = 0:stereo
        Screen('SelectStereoDrawbuffer', win, view);
        Screen('BeginOpenGL', win);
        setview(cameraAngle, view);
            try
                drawsphere(-RedX, RedZ, RedY, [1.0, 0.0, 0.0, 1.0]);
                drawsphere(-WhiteX, WhiteZ, WhiteY, [1.0, 1.0, 1.0, 1.0]);
                if drawLines
                    drawviewline; 
                    drawaxes;
                end
                drawmark;
                drawarena;
            catch
                psychlasterror;
                sca;
            end
        Screen('EndOpenGL', win);
        infotext; 
    end
    Screen('DrawingFinished', win, 2);
    Screen('Flip', win);
    startSecs = GetSecs;
    
    % Keyboard response collection
    KbWait;
    [keyIsDown, timeSecs, keyCode] = KbCheck;
    keyCode = find(keyCode, 1);
    
    if keyIsDown
       fprintf('"%s" typed at time %.3f seconds\n',...
           KbName(keyCode), timeSecs - startSecs); 
       if keyCode == KbName('ESCAPE')
           ListenChar(0);
           ShowCursor();
           break;
       elseif keyCode == KbName('v')
           topView = ~topView;
       elseif keyCode == KbName('l')
           drawLines = ~drawLines;
       end
       KbReleaseWait;
    end
    Screen('Flip', win);
end
ListenChar(0);
ShowCursor();
sca;
end