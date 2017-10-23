AssertOpenGL;
screenid = max(Screen('Screens'));
InitializeMatlabOpenGL(0,0);

HideCursor;
ListenChar(2);

[win, winRect] = PsychImaging('OpenWindow', screenid, 0, [], [], [], 0, 0);

KbName('UnifyKeyNames');

camera = [0.0, 0.0, 10.0];
lookAt = [0.0, 0.0, 0.0];

while 1
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
    
    text = sprintf('Camera:\nX = %0.2f, Y = %0.2f, Z = %0.2f',...
        camera(1), camera(2), camera(3));
    text = strcat(text,...
        sprintf('\nLook at:\nX = %0.2f, Y = %0.2f, Z = %0.2f\n\n',...
        lookAt(1), lookAt(2), lookAt(3)));
    disp(text);
    DrawFormattedText(win, text, 100, 100, [255 255 0]);
    
    Screen('BeginOpenGL', win);
        glMaterialfv(GL.FRONT, GL.DIFFUSE, [1 0 0]);
    
        glPushMatrix;
        glTranslatef(camera(1), camera(2), camera(3)-0.2);
        glutSolidSphere(0.001, 30, 30);
        glPopMatrix;
        
        glMaterialfv(GL.FRONT, GL.DIFFUSE, [0 1 0]);
    
        glPushMatrix;
        glTranslatef(lookAt(1), lookAt(2), lookAt(3));
        glutSolidSphere(0.1, 30, 30);
        glPopMatrix;
        
        glMaterialfv(GL.FRONT, GL.DIFFUSE, [1 1 1]);
        
        glPushMatrix;
        glTranslatef(0.0, 0.0, 0.0);
        glutWireTeapot(0.7);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(2.0, 0.0, 0.0);
        glutWireSphere(0.3, 30, 30);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(-2.0, 0.0, 0.0);
        glutWireSphere(0.3, 30, 30);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0.0, 1.0, 0.0);
        glutWireCube(0.3);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0.0, -1.0, 0.0);
        glRotatef(-90, 1, 0, 0);
        glutWireCone(0.25, 0.25, 30, 30);
        glPopMatrix;

        glPushMatrix;
        glTranslatef(0.0, 0.0, -2.0);
        glScalef(-1, -1, 1);
        glutWireTeapot(0.1);
        glPopMatrix;
    Screen('EndOpenGL', win);
    Screen('Flip', win);
    
    [t, key, ~] = KbWait;
    if find(key, 1) == KbName('LeftArrow')
        camera(1) = camera(1) - 0.1;
    elseif find(key, 1) == KbName('RightArrow');
        camera(1) = camera(1) + 0.1;
    elseif find(key, 1) == KbName('UpArrow');
        camera(2) = camera(2) + 0.1;
    elseif find(key, 1)  == KbName('DownArrow');
        camera(2) = camera(2) - 0.1;
    elseif find(key, 1) == KbName('w');
        camera(3) = camera(3) - 0.1;
    elseif find(key, 1) == KbName('s');
        camera(3) = camera(3) + 0.1;
    elseif find(key, 1) == KbName('r');
        camera = [0.0, 0.0, 10.0]; 
        lookAt = [0.0, 0.0, 0.0];
    elseif find(key, 1) == KbName('a');
        lookAt(1) = lookAt(1) - 0.1; 
    elseif find(key, 1) == KbName('d');
        lookAt(1) = lookAt(1) + 0.1;
    elseif find(key, 1) == KbName('q');
        lookAt(2) = lookAt(2) - 0.1; 
    elseif find(key, 1) == KbName('e');
        lookAt(2) = lookAt(2) + 0.1;
    elseif find(key, 1) == KbName('x');
        lookAt(3) = lookAt(3) - 0.1; 
    elseif find(key, 1) == KbName('c');
        lookAt(3) = lookAt(3) + 0.1;
  elseif find(key, 1) == KbName('ESCAPE');
        sca;
        ShowCursor;
        ListenChar(0);
        break;
    end 
end
sca;
    
    
    
    
    