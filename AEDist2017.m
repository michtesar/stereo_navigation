function AEDist2017

global GL;

eyesDistance = 0.04;

% Switch to stereo mode by
stereoMode = 0; %1 stereo;
stereoViews = 0; %1 stereo;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [],...
    stereoMode, 0);

% Set the keyboard
KbName('UnifyKeyNames');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
escapeKey = KbName('ESCAPE');

% Hide cursor and prevent from writing into console
HideCursor();
ListenChar(2);

% Intruction
instructionText = sprintf(['Hello, thank you for participation\n',...
    'in AEDist2017 active stereoscopy paradigm.\nThis ',...
    'is a demo of futher full paradigm setup.\n\nPress ANY ',...
    'key to continue.']);
Screen('TextSize', win, 40);
Screen('TextStyle', win, 0);

DrawFormattedText(win,instructionText,'center','center',[255 255 255]);
Screen('Flip', win);

KbWait;

% Blank screen before experiment
Screen('Flip', win);
WaitSecs(0.5);

% OpenGL part
Screen('BeginOpenGL', win);
    ar = RectHeight(winRect) / RectWidth(winRect);
    glViewport(0, 0, RectWidth(winRect), RectHeight(winRect));
    glColor3f(1,1,0);
    glEnable(GL.LIGHT0);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    gluPerspective(45, 1/ar, 0.3, 100);
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);
    glClearColor(0,0,0,0);   
    glEnable(GL.LIGHTING);
    glEnable(GL.DEPTH_TEST);
Screen('EndOpenGL', win);

for epoch = 1:100
    % Random coordinate
    redX = 0.2;%randi([-2 2], 1);
    redZ = 0.2;%randi([-2 2], 1);
    whiteX = 0.1;%randi([-2 2], 1);
    whiteZ = 0.1;%randi([-2 2], 1);

    for view = 0:stereoViews
        Screen('SelectStereoDrawbuffer', win, view);
        Screen('BeginOpenGL', win);       
            glMatrixMode(GL.MODELVIEW);
            glLoadIdentity;
            if view == 0
                eyePosition = -0.08;
            else
                eyePosition = 0.08;
            end
            %gluLookAt(-0.4 + view * paralaxIndex, 4, -12, 0, 2, -2, 0, 1, 0);
            gluLookAt(eyePosition * eyesDistance, 0.15, -0.7, 0, 0.15, -0.2, 0, 1, 0 );
            glClear;   
            
            % Draw the whole arena here
            glPushMatrix;
                drawsphere(redX, -0.1, redZ, [1, 0, 0, 1]);
            glPopMatrix;

            glPushMatrix;
                drawsphere(whiteX, -0.1, whiteZ, [1, 1, 1, 1]);
            glPopMatrix;

            glPushMatrix;
                drawfloor();
            glPopMatrix;

            glPushMatrix;
                drawarena();
            glPopMatrix;

            glPushMatrix;
                drawmark();
            glPopMatrix; 

        Screen('EndOpenGL', win);
    end

    Screen('DrawingFinished', win, 2);
    startTime = Screen('Flip', win);

    while 1
        [~, timeSecs, keyCode] = KbCheck;
        if find(keyCode, 1) == leftKey
            fprintf('Pressed: Left key, RT: %0.2f sec\n', timeSecs - startTime);
            eyesDistance = eyesDistance - 0.01;
            disp(eyePosition * eyesDistance)
            KbReleaseWait;
            break;
        elseif find(keyCode, 1) == rightKey
            fprintf('Pressed: Left key, RT: %0.2f sec\n', timeSecs - startTime);
            eyesDistance = eyesDistance + 0.01;
            disp(eyePosition * eyesDistance)
            KbReleaseWait;
            break;
        elseif find(keyCode, 1) == escapeKey
            ListenChar(0);
            ShowCursor();
            sca;
            break;
        end 
    end
    
    % Blank screen
    Screen('Flip', win);
    WaitSecs(0.5);
    
end

ListenChar(0);
ShowCursor();
Priority(0);
KbQueueRelease;
sca;
end

function readtexture(source)
global GL
img_data = imread(source);
img_size = size(img_data);
texture_id = glGenTextures(1);
glBindTexture(GL.TEXTURE_2D, texture_id);
glPixelStorei(GL.UNPACK_ALIGNMENT, 1);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
glTexParameterf(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
glTexEnvf(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.COMBINE);
glTexImage2D(GL.TEXTURE_2D, 0, GL.RGBA, img_size(1), img_size(2),...
    0, GL.BGR, GL.UNSIGNED_BYTE, img_data);
end

function drawsphere(x, y, z, color)
global GL
glMaterialfv(GL.FRONT, GL.DIFFUSE, color);
glTranslatef(x, y, z);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
gluSphere(qobj, 0.03, 60, 60);
end

function drawarena()
global GL
readtexture('source/wall.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
glRotatef(90, 1, 0, 0);
glTranslatef(0, 0, -2);

glEnable(GL.TEXTURE_2D);
    gluCylinder(qobj, 0.5, 0.5, 30, 30, 30);
glDisable(GL.TEXTURE_2D);
end

function drawfloor()
global GL
readtexture('source/floor.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
glRotatef(90, 1, 0, 0);
glTranslatef(0.0, -1.5, 0.1);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);

glEnable(GL.TEXTURE_2D);
    gluDisk(qobj, 0, 5, 50, 50);
glDisable(GL.TEXTURE_2D);
end

function drawmark()
global GL
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 0, 0]);
qobj = gluNewQuadric();
glTranslatef(0.0, 0.0, 0.5);
glRotatef(90, 1, 0, 0);
gluCylinder(qobj, 0.07, 0.07, 0.2, 30, 30);
end
