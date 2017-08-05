classdef Graphic
    properties
        win;
        winRect;
    end
    
    methods
        function obj = Graphic
            global GL;
            AssertOpenGL;
            screenid = max(Screen('Screens'));
            InitializeMatlabOpenGL(0, 0);
            [obj.win , obj.winRect] = Screen('OpenWindow', screenid);
            HideCursor;
            ListenChar(2);
            
            Screen('BeginOpenGL', obj.win);
                ar = obj.winRect(4)/obj.winRect(3);
                glEnable(GL.LIGHTING);
                glEnable(GL.LIGHT0);
                glEnable(GL.DEPTH_TEST);
                glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE,GL.TRUE);
                
                glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ .33 .22 .03 1 ]);
                glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ .78 .57 .11 1 ]);
                glMaterialfv(GL.FRONT_AND_BACK,GL.SHININESS,27.8);

                glMatrixMode(GL.PROJECTION);
                glLoadIdentity;
                gluPerspective(25,1/ar,0.1,100);

                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                gluLookAt(0,0,5,0,0,0,0,1,0);
                glClearColor(0,0,0,0);

                glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
                glLightfv(GL.LIGHT0,GL.DIFFUSE, [ 1 1 1 1 ]);
                glLightfv(GL.LIGHT0,GL.AMBIENT, [ .1 .1 .1 1 ]);
                glClear;
            Screen('EndOpenGL', obj.win);
        end
             
        function drawText(obj, text)
             DrawFormattedText(obj.win, text,...
                 'center', 'center', [255 0 0]);
        end
        
        function setView(obj, eyeX, eyeY, eyeZ, pointX, pointY, pointZ)
            global GL;
            Screen('BeginOpenGL', obj.win);
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                gluLookAt(eyeX,eyeY,eyeZ,pointX,pointY,pointZ,0,1,0);
                glClear;
            Screen('EndOpenGL', obj.win);
        end
        
        function drawPlanet(obj, texture, x, y, z)
            global GL;
            myimg = imread(texture);
            mytex = Screen('MakeTexture', obj.win, myimg, [], 1);
            [gltex, gltextarget] = Screen('GetOpenGLTexture', obj.win, mytex);
            Screen('BeginOpenGL', obj.win);
                glEnable(gltextarget);
                glBindTexture(gltextarget, gltex);
                glTexEnvfv(GL.TEXTURE_ENV,GL.TEXTURE_ENV_MODE,GL.MODULATE);
                glTexParameteri(gltextarget, GL.TEXTURE_WRAP_S, GL.REPEAT);
                glTexParameteri(gltextarget, GL.TEXTURE_WRAP_T, GL.REPEAT);
                glTexParameteri(gltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
                glTexParameteri(gltextarget, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
                glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1 1 1 1 ]);
                glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1 1 1 1 ]);
        
                mysphere = gluNewQuadric;
                gluQuadricTexture(mysphere, GL.TRUE); 
                glPushMatrix;
                    glTranslatef(x, y, z);
                    glRotatef(40,1,0,0);
                    gluSphere(mysphere, 0.4, 60, 60);
                glPopMatrix;
            Screen('EndOpenGL', obj.win);    
        end
        
        function drawInstruction(obj, text)
            unicode = double(text);
            Screen('FillRect', obj.win, [0, 0, 0]);
            DrawFormattedText(obj.win, unicode,...
                 'center', 'center', [255 255 255]); 
        end
        
        function drawArena(obj, rx, ry, rz, wx, wy, wz)
            global GL;
            
            % Red sphere
            Screen('BeginOpenGL', obj.win);
            glPushMatrix;
                glMaterialfv(GL.FRONT, GL.DIFFUSE, [1 0 0]);
                glTranslatef(rx, ry, rz);
                qobj = gluNewQuadric();
                gluQuadricTexture(qobj, GL.TRUE);
                gluSphere(qobj, 0.03, 60, 60);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);

            % White sphere
            Screen('BeginOpenGL', obj.win);
            glPushMatrix;
                glMaterialfv(GL.FRONT, GL.DIFFUSE, [1 1 1]);
                glTranslatef(wx, wy, wz);
                qobj = gluNewQuadric();
                gluQuadricTexture(qobj, GL.TRUE);
                gluSphere(qobj, 0.03, 60, 60);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);

            % Walls
            wallImage = imread('source/wall.jpg');
            wallTex = Screen('MakeTexture', obj.win, wallImage, [], 1);
            [wallgltex, wallgltextarget] = Screen('GetOpenGLTexture', obj.win, wallTex);
            Screen('BeginOpenGL', obj.win);
                glEnable(wallgltextarget);
                glBindTexture(wallgltextarget, wallgltex);
                glTexEnvfv(GL.TEXTURE_ENV,GL.TEXTURE_ENV_MODE,GL.MODULATE);
                glTexParameteri(wallgltextarget, GL.TEXTURE_WRAP_S, GL.REPEAT);
                glTexParameteri(wallgltextarget, GL.TEXTURE_WRAP_T, GL.REPEAT);
                glTexParameteri(wallgltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
                glTexParameteri(wallgltextarget, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
                glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1 1 1 1 ]);
                glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1 1 1 1 ]);

                qobj = gluNewQuadric;
                gluQuadricTexture(qobj, GL.TRUE); 
                glPushMatrix;
                    glTranslatef(0, 0, 0);
                    glRotatef(40,1,0,0);
                    gluCylinder(qobj, 0.5, 0.5, 30, 30, 30);
                glPopMatrix;
            Screen('EndOpenGL', obj.win);

            % Floor
            wallImage = imread('source/floor.jpg');
            wallTex = Screen('MakeTexture', obj.win, wallImage, [], 1);
            [wallgltex, wallgltextarget] = Screen('GetOpenGLTexture', obj.win, wallTex);
            Screen('BeginOpenGL', obj.win);
                glEnable(wallgltextarget);
                glBindTexture(wallgltextarget, wallgltex);
                glTexEnvfv(GL.TEXTURE_ENV,GL.TEXTURE_ENV_MODE,GL.MODULATE);
                glTexParameteri(wallgltextarget, GL.TEXTURE_WRAP_S, GL.REPEAT);
                glTexParameteri(wallgltextarget, GL.TEXTURE_WRAP_T, GL.REPEAT);
                glTexParameteri(wallgltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
                glTexParameteri(wallgltextarget, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
                glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1 1 1 1 ]);
                glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1 1 1 1 ]);

                qobj = gluNewQuadric;
                gluQuadricTexture(qobj, GL.TRUE); 
                glPushMatrix;
                    glTranslatef(0, 0, 0);
                    glRotatef(-80,1,0,0);
                    gluDisk(qobj, 0, 5, 50, 50);
                glPopMatrix;
            Screen('EndOpenGL', obj.win);   
            
            % Marks
            Screen('BeginOpenGL', obj.win);
            glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 0, 0]);
            qobj = gluNewQuadric();
            glTranslatef(0.0, 0.0, 0.5);
            glRotatef(90, 1, 0, 0);
            glPushMatrix;
                gluCylinder(qobj, 0.07, 0.07, 0.2, 30, 30);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);
        end
        
        function wait(obj)
            Screen('Flip', obj.win);
            KbWait;
            KbReleaseWait;
        end
        
        function close(obj)
            Screen('Flip', obj.win);
            ShowCursor;
            ListenChar;
            sca;
            fprintf('Done!\n');
        end
    end
end
            
            