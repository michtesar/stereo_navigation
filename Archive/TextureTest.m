function TextureTest(stereo)

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
        gluLookAt(0,0,10,0,0,0,0,1,0);
        glClearColor(0,0,0,0);
        glClear;
    Screen('EndOpenGL', win);

    % Get duration of a single frame:
    ifi = Screen('GetFlipInterval', win);

    % Initial flip to sync us to VBL and get start timestamp:
    vbl = Screen('Flip', win);
    tstart = vbl;
    telapsed = 0;

    Screen('BeginOpenGL', win);
        glEnable(GL.LIGHTING);
        glEnable(GL.DEPTH_TEST);
        glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    Screen('EndOpenGL', win);
    
    while ~KbCheck
        for view = 0:stereoViews
            Screen('SelectStereoDrawbuffer', win, view);
            Screen('BeginOpenGL', win);
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                % FIX ME: help moglStereoProjection:
                gluLookAt(-0.4 + view * 3.8 , 0, 10, 0, 0, 0, 0, 1, 0);
                glClear;
                glRotated(20 * telapsed, 0, 1, 0);
                glRotated(10  * telapsed, 1, 0, 0);
                drawsphere;
                glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
            Screen('EndOpenGL', win); 
            telapsed = vbl - tstart;
        end
        Screen('DrawingFinished', win, 2);
        vbl = Screen('Flip', win, vbl + 0.5 * ifi, 2);
        [~, ~, buttons] = GetMouse;
        if any(buttons)
            GetClicks;
        end
    end
    sca;
    RestrictKeysForKbCheck([]);
catch
    sca;
    RestrictKeysForKbCheck([]);
    psychrethrow(psychlasterror);
end

end

function drawsphere
global GL;
readtexture('ball.jpg');
sphere = gluNewQuadric();
gluQuadricTexture(sphere, GL.TRUE);
glEnable(GL.TEXTURE_2D);
    gluSphere(sphere, 2, 80, 80);
glDisable(GL.TEXTURE_2D);    
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
