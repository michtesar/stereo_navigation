function SceneDemo

AssertOpenGL;
screenid=max(Screen('Screens'));
InitializeMatlabOpenGL(1);
[win , winRect] = Screen('OpenWindow', screenid);
ar = winRect(4) / winRect(3);

Screen('BeginOpenGL', win);

lighting();

glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(25, 1/ar, 0.1, 100);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
gluLookAt(0, 0, 10, 0, 0, 0, 0, 1, 0);
glClearColor(0, 0, 0, 0);
glPushMatrix;

glClear;

readtexture('ball_01.jpg');

color = [1.0, 0.0, 0.0, 1.0];
glMaterialfv(GL_FRONT, GL_DIFFUSE, color);
glTranslatef(-1.5,0,0);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL_TRUE);
glEnable(GL_TEXTURE_2D);
gluSphere(qobj, 1, 80, 80);
glDisable(GL_TEXTURE_2D);

readtexture('ball_03.jpg');

color = [1.0, 0.0, 0.0, 1.0];
glMaterialfv(GL_FRONT, GL_DIFFUSE, color);
glTranslatef(3.5,0,-3);
qobj = gluNewQuadric();
gluQuadricTexture(qobj, GL_TRUE);
glEnable(GL_TEXTURE_2D);
gluSphere(qobj, 1, 80, 80);
glDisable(GL_TEXTURE_2D);

glPopMatrix;

Screen('EndOpenGL', win);
Screen('Flip', win);
Screen('BeginOpenGL', win);

KbWait;

Screen('EndOpenGL', win);
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
glTexEnvf(GL.TEXTURE_ENV, GL.TEXTURE_ENV_MODE, GL.DECAL);
glTexImage2D(GL.TEXTURE_2D, 0, GL.RGB, img_size(1), img_size(2),...
    0, GL.RGB, GL.UNSIGNED_BYTE, img_data);
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

function drawsphere(size, x, y, z, texture)
global GL

end
