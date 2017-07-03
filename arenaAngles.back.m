function arenaAngles

global GL;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [],...
    0, 0);

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

Screen('BeginOpenGL', win);       
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    gluLookAt(1, 1, 1, 0, 0, 0, 0, 1, 0 );
    glClear;   
 
    glPushMatrix;
        drawsphere(0.0, 0.0, -0.15, [1, 0, 0, 1]);
    glPopMatrix;

    glPushMatrix;
        drawsphere(0.3, 0.0, -0.15, [1, 1, 1, 1]);
    glPopMatrix;

    glPushMatrix;
        drawsphere(0.0, 0.0, 0.0, [0, 1, 0, 1]);
    glPopMatrix;

    glPushMatrix;
        drawmark();
    glPopMatrix; 

    glPushMatrix;
        drawfloor();
    glPopMatrix;

    glPushMatrix;
        drawarena();
    glPopMatrix;

Screen('EndOpenGL', win);
Screen('Flip', win);
KbWait;
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
glPopMatrix;
    glTranslatef(x, y, z);
glPushMatrix;
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
glPopMatrix;
    glRotatef(90, 1, 0, 0);
    glTranslatef(0, 0, -0.25);
glPushMatrix;
glEnable(GL.TEXTURE_2D);
    gluCylinder(qobj, 0.5, 0.5, 0.25, 30, 30);
glDisable(GL.TEXTURE_2D);
end

function drawfloor()
global GL
readtexture('source/floor.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
glRotatef(90, 1, 0, 0);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);

glEnable(GL.TEXTURE_2D);
    gluDisk(qobj, 0, 0.5, 30, 30);
glDisable(GL.TEXTURE_2D);
end

function drawmark()
global GL
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 0, 0]);
qobj = gluNewQuadric();
glTranslatef(0.0, 0.25, 0.5);
glRotatef(90, 1, 0, 0);
gluCylinder(qobj, 0.02, 0.02, 0.2, 30, 30);
end
