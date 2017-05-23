function StereoScene(stereo)

global GL;

if nargin == 0
    stereoMode = 0;
    stereoViews = 0;
else
    stereoMode = stereo;
    stereoViews = stereo;
end

AssertOpenGL;

KbName('UnifyKeynames');
RestrictKeysForKbCheck(KbName('ESCAPE'));

screenid = max(Screen('Screens'));
Screen('Preference', 'SkipSyncTests', 1);

try
    InitializeMatlabOpenGL;
    PsychImaging('PrepareConfiguration');
    [win, winRect] = PsychImaging('OpenWindow', screenid, 0, [], [], [],...
        stereoMode, 0);

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
    
    while ~KbCheck
        for view = 0:stereoViews
            Screen('SelectStereoDrawbuffer', win, view);
            Screen('BeginOpenGL', win);
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                gluLookAt(-0.4 + view * 0.8, 4, -10, 0, 0, 0, 0, 1, 0);
                glClear;
                
                % Draw the whole arena here
                glPushMatrix;
                    drawsphere(-1, 0, 0, [1, 0, 0, 0]);
                glPopMatrix;

                glPushMatrix;
                    drawsphere(1, 0, -2, [1, 1, 1, 0]);
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
    end
    sca;
catch
    sca; 
    psychrethrow(psychlasterror);
end

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
readtexture('wall.jpg');
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
readtexture('floor.jpg');
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