function AEDist2017

global GL;

% Switch to stereo mode by
stereoMode = 0; %stereo;
stereoViews = 0; %stereo;

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

% OpenGL part
Screen('BeginOpenGL', win);
    ar = RectHeight(winRect) / RectWidth(winRect);
    glViewport(0, 0, RectWidth(winRect), RectHeight(winRect));
    glColor3f(1,1,0);
    glEnable(GL.LIGHT0);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    gluPerspective(25, 1/ar, 0.1, 100);
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);
    glClearColor(0,0,0,0);   
    glEnable(GL.LIGHTING);
    glEnable(GL.DEPTH_TEST);
Screen('EndOpenGL', win);

for epoch = 1:5
    
    for view = 0:stereoViews
        Screen('SelectStereoDrawbuffer', win, view);
        Screen('BeginOpenGL', win);
            glMatrixMode(GL.MODELVIEW);
            glLoadIdentity;
            gluLookAt(-0.4 + view * 0.8, 4, -10, 0, 0, 0, 0, 1, 0);
            glClear;
            
            % Random coordinate
            redX = randi([-2 2], 1);
            redZ = randi([-2 2], 1);
            whiteX = randi([-2 2], 1);
            whiteZ = randi([-2 2], 1);
            
            % Draw the whole arena here
            glPushMatrix;
                drawsphere(redX, 0, redZ, [1, 0, 0, 0]);
            glPopMatrix;

            glPushMatrix;
                drawsphere(whiteX, 0, whiteZ, [1, 1, 1, 0]);
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
    Screen('Flip', win);

    while 1
        [~, timeSecs, keyCode] = KbCheck;
        if find(keyCode, 1) == leftKey
            fprintf('Pressed: Left key, RT: %d ms\n', timeSecs*1000);
            KbReleaseWait;
            break;
        elseif find(keyCode, 1) == rightKey
            fprintf('Pressed: Right key, RT: %d ms\n', timeSecs*1000);
            KbReleaseWait;
            break;
        elseif find(keyCode, 1) == escapeKey
            ListenChar(0);
            ShowCursor();
            sca;
            break;
        end 
    end

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
gluSphere(qobj, 0.5, 80, 80);
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
    gluCylinder(qobj, 8, 8, 30, 30, 30);
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
glTranslatef(0.0, 1.0, 3.0);
glRotatef(90, 1, 0, 0);
gluCylinder(qobj, 0.25, 0.25, 1, 30, 30);
end