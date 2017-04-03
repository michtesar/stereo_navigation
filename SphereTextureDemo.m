 function SphereTextureDemo
 
AssertOpenGL;
screenid=max(Screen('Screens'));
InitializeMatlabOpenGL(1);
[win , winRect] = Screen('OpenWindow', screenid);
ar=winRect(4)/winRect(3);
Screen('BeginOpenGL', win);

glEnable(GL_LIGHTING);
glEnable(GL_LIGHT0);
glLightModelfv(GL_LIGHT_MODEL_TWO_SIDE,GL_TRUE);
glEnable(GL_DEPTH_TEST);
lightZeroPosition = [10., 4., 10., 1.];
lightZeroColor = [0.8, 1.0, 0.8, 1.0];
glLightfv(GL_LIGHT0, GL_POSITION, lightZeroPosition);
glLightfv(GL_LIGHT0, GL_DIFFUSE, lightZeroColor);
glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.1);
glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.05);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(25,1/ar,0.1,100);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;
gluLookAt(0,0,10,0,0,0,0,1,0);
glClearColor(0,0,0,0);
glPushMatrix;

glClear;
color = [1.0, 0.0, 0.0, 1.0];
glMaterialfv(GL_FRONT, GL_DIFFUSE, color);
qobj = gluNewQuadric();
gluSphere(qobj, 1, 80, 80);
glPopMatrix;

Screen('EndOpenGL', win);
Screen('Flip', win);
Screen('BeginOpenGL', win);

KbWait;

Screen('EndOpenGL', win);
sca;

return
