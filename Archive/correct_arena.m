AssertOpenGL;
screenid = max(Screen('Screens'));
InitializeMatlabOpenGL(0,0);

HideCursor;
ListenChar(2);

[win, winRect] = PsychImaging('OpenWindow', screenid, 0, [], [], [], 0, 0);

KbName('UnifyKeyNames');

camera = [0.0, 0.0, 10.0];
lookAt = [0.0, 0.0, 0.0];

Screen('BeginOpenGL', win);
    ar = winRect(4) / winRect(3);  
    glEnable(GL.LIGHTING);
    glEnable(GL.LIGHT0);
    glEnable(GL.DEPTH_TEST);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    gluPerspective(25, 1/ar, 0.01, 100);
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 0]);
    gluLookAt(camera(1), camera(2), camera(3),...
        lookAt(1), lookAt(2), lookAt(3), 0, 1, 0);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear;
Screen('EndOpenGL', win);

