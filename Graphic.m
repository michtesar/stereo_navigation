classdef Graphic
    properties
        win;
        winRect;
        textures;
    end
    
    methods
        function obj = Graphic
            
            global GL;
            AssertOpenGL;
            screenid = max(Screen('Screens'));
            InitializeMatlabOpenGL(0, 0);
            HideCursor;
            ListenChar(2);
            [obj.win, obj.winRect] = Screen('OpenWindow', screenid);
            
            floorImage = imread('source/floor.jpg');
            obj.textures(1) = Screen('MakeTexture', obj.win, floorImage, [], 1);
            wallImage = imread('source/wall.jpg');
            obj.textures(2) = Screen('MakeTexture', obj.win, wallImage, [], 1);
            
            Screen('BeginOpenGL', obj.win);
                ar = obj.winRect(4) / obj.winRect(3);
                glEnable(GL.LIGHTING);
                glEnable(GL.LIGHT0);
                glEnable(GL.DEPTH_TEST);
                glMatrixMode(GL.PROJECTION);
                glLoadIdentity;
                gluPerspective(25, 1/ar, 0.1, 100);
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                gluLookAt(0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0, 1, 0);
                glClearColor(0.0, 0.0, 0.0, 0.0);
                glLightfv(GL.LIGHT0,GL.POSITION,[1.0, 2.0, 3.0, 0.0]);
                glLightfv(GL.LIGHT0,GL.DIFFUSE, [1.0, 1.0, 1.0, 1.0]);
                glLightfv(GL.LIGHT0,GL.AMBIENT, [0.1, 0.1, 0.1, 1.0]);
                glClear;
            Screen('EndOpenGL', obj.win);
        end
             
        function debug(obj, text)
             DrawFormattedText(obj.win, text,...
                 100, 100, [255 255 0]);
        end
        
        function setView(obj, camera, target)
            global GL;
            Screen('BeginOpenGL', obj.win);
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                gluLookAt(camera(1), camera(2), camera(3),...
                    target(1), target(2), target(3),...
                    0, 1, 0);
                glClear;               
            Screen('EndOpenGL', obj.win);
        end
        
        function drawInstruction(obj, text)
            unicode = double(text);
            Screen('FillRect', obj.win, [0, 0, 0]);
            DrawFormattedText(obj.win, unicode,...
                 'center', 'center', [255 255 255]); 
        end
        
        function drawArena(obj)
            global GL;
            
            % Mark
            Screen('BeginOpenGL', obj.win);
            markSize = 0.05;
            markDiameter = 0.02;
            glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 0, 0]);
            qobj = gluNewQuadric();
            glPushMatrix;
                glTranslatef(0.017, markSize, -0.483);
                glRotatef(90, 1, 0, 0);
                gluCylinder(qobj, markDiameter, markDiameter, markSize, 30, 30);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);
            
            % Floor
            floorSize = 0.5;
            [wallgltex, wallgltextarget] = Screen('GetOpenGLTexture', obj.win, obj.textures(1));
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
                glRotatef(90, 1, 0, 0);
                gluDisk(qobj, 0, floorSize, 50, 50);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);
            
            % Walls
            wallHeight = 0.1;
            wallSize = 0.5;
            [wallgltex, wallgltextarget] = Screen('GetOpenGLTexture', obj.win, obj.textures(2));
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
                glRotatef(90, 1, 0, 0);
                glTranslatef(0, 0, -wallHeight);
                gluCylinder(qobj, wallSize, wallSize, wallHeight, 30, 30);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);
        end
        
        function wait(obj)
            Screen('Flip', obj.win);
            %KbWait(-1);
            %KbReleaseWait;
        end
        
        function sphere(obj, coord)
            global GL;
            Screen('BeginOpenGL', obj.win);
            glPushMatrix;
                glTranslatef(coord(1), coord(2), coord(3));
                glMaterialfv(GL.FRONT, GL.DIFFUSE, [0, 0, 1]);
                glutSolidSphere(0.02, 30, 30);
            glPopMatrix;
            Screen('EndOpenGL', obj.win);
        end
        
        function close(obj)
            Screen('Flip', obj.win);
            ShowCursor;
            ListenChar;
            Screen('CloseAll');
            fprintf('Done!\n');
        end 
    end
end
            
            