function SceneDemo1
% Generate main scene demo for active stereoscopy
% paradigm. Only need PsychToolbox installed.
% For enabling stereoscopy it is needed to add
% new Screen parameters as in SpinningCube demo is.
% Michael Tesar
% 2017

% Enable Psychtoolbox and OpenGL
AssertOpenGL;
screenid=max(Screen('Screens'));
InitializeMatlabOpenGL(1);
[win , winRect] = Screen('OpenWindow', screenid);
ar = winRect(4) / winRect(3);
Screen('BeginOpenGL', win);

% Light the scene
lighting();

% Create projection and camera
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(25, 1/ar, 0.1, 100);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
gluLookAt(0, 4, -10, 0, 0, 0, 0, 1, 0);
glClearColor(0, 0, 0, 0);
glPushMatrix;
glClear;

try
    % Draw all elements in screen
    drawfloor();
    drawsphere(-2.5, 0, 2, [1, 0, 0, 0]);
    drawsphere(3.5, 0, -3, [0, 0, 1, 0]);
    drawarena();
    drawsky();
    glPopMatrix;
catch
    sca;
end

% Finish drawing
Screen('EndOpenGL', win);
Screen('Flip', win);

% Wait for any key press
KbWait;

% Clear the screen and quit
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
 
function lighting()
global GL
glEnable(GL.LIGHTING);
glEnable(GL.LIGHT0);
glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);
glEnable(GL.DEPTH_TEST);
lightZeroPosition = [10., 4., 10., 1.];
lightZeroColor = [0.8, 1.0, 0.8, 1.0];
glLightfv(GL.LIGHT0, GL.POSITION, lightZeroPosition);
glLightfv(GL.LIGHT0, GL.DIFFUSE, lightZeroColor);
glLightf(GL.LIGHT0, GL.CONSTANT_ATTENUATION, 0.1);
glLightf(GL.LIGHT0, GL.LINEAR_ATTENUATION, 0.05);
end

function drawsphere(x, y, z, color)
global GL
readtexture('ball.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, color);
glTranslatef(x, y, z);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
glEnable(GL.TEXTURE_2D);
gluSphere(qobj, 0.5, 80, 80);
glDisable(GL.TEXTURE_2D);
end

function drawarena()
global GL
readtexture('wall.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
glEnable(GL.TEXTURE_2D);
gluCylinder(qobj, 10, 10, 50, 30, 30);
glDisable(GL.TEXTURE_2D);
end

function drawfloor()
global GL
readtexture('grass.jpg');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [0, 1, 0, 0]);
glRotatef(100, 1, 0, 0);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
glEnable(GL.TEXTURE_2D);
gluDisk(qobj, 0, 5, 30, 30);
glDisable(GL.TEXTURE_2D);
end

function drawsky()
global GL
readtexture('sky.bmp');
glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL.TRUE);
glEnable(GL.TEXTURE_2D);
gluCylinder(qobj, 11, 11, 200, 30, 30);
glDisable(GL.TEXTURE_2D);
end
