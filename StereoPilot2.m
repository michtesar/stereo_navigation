function StereoPilot2(subject)
% STEREOPILOT2 is PsychToolbox implementation of AEDist 2016 experiment
%   You can run it without any parameters which leads to running in
%   default non-stereoscopic mode. Otherwise use prepared GUI to run it.
% Coordinate system:
%   Positive x-Axis points horizontally to the right.
%   Positive y-Axis points vertically upwards.
%   Positive z-Axis points to the observer.
%   Positive yaw camera rotation leads to move camera to the left.
%   Positive pitch camera rotation moves camera to the top and looks down.
%   Positive roll camera rotation spins camera itself counter-clockwise.
%
% Coded by Michael Tesar
% <michtesar@gmail.com>
% 2017, Prague

load source;

if nargin < 1
    subject = 'default';
end

% Create a logfile and write a header
try
    log = fopen([subject, '.csv'], 'wt');
    fprintf(log, ['RedX, RedY, RedZ, WhiteX, WhiteY,',...
        'WhiteZ, Response, RT (ms)\n']);
    fclose(log);
catch
    error('Cannot write or open a logfile!');
end

Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);

HideCursor();
ListenChar(2);

screenID = max(Screen('Screens'));

InitializeMatlabOpenGL([], [], [], 0);

[win, winRect] = PsychImaging('OpenWindow', screenID, 0, [], [], [], 0, 0);

% Read textures into buffer before star to speeding up the epxeriment
global gltextargetFloor gltexFloor gltexWall gltextargetWall;
imgFloor = imread('floor.jpg');
texFloor = Screen('MakeTexture', win, imgFloor, [], 1);
[gltexFloor, gltextargetFloor] = Screen('GetOpenGLTexture', win, texFloor);
imgWall = imread('wall.jpg');
texWall = Screen('MakeTexture', win, imgWall, [], 1);
[gltexWall, gltextargetWall] = Screen('GetOpenGLTexture', win, texWall);

Screen('BeginOpenGL', win);

ar = winRect(4) / winRect(3);

glEnable(GL.LIGHTING);
glEnable(GL.LIGHT0);
glEnable(GL.DEPTH_TEST);

glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(60, 1/ar, 0.001, 100);

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 0]);
glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);

glClearColor(0, 0, 0, 0);
glClear;

for trial = 1:height(source)
    % Camera yaw - left to right look, while 90 means to look directly in
    % front. Angles smaller than 90 deg points to left, and bigger to
    % right.
    yaw = source.Yaw(trial);
    % Camera pitch - up and down look, while 360 means to look parallel with
    % the floor and smaller angle like 346 means to look slightly down.
    pitch = 346;
    % Camera roll - rotate a camera around its axe. It is not used in this
    % experiment, but can be setted up and it works.
    roll = 0;
    
    glClear;
    
    glPushMatrix;
    
    % Set camera angles and draw arena
    setcamera([yaw, pitch, roll]);
    drawarena;
    
    % Draw spheres
    drawsphere([source.RedX(trial), source.RedY(trial),...
        source.RedZ(trial)], [1, 0, 0]);
    drawsphere([source.WhiteX(trial), source.WhiteY(trial),...
        source.WhiteZ(trial)], [1, 1, 1]);
    
    glPopMatrix;
    
    Screen('EndOpenGL', win);    
    onset = Screen('Flip', win);
    
    while 1
        [keyIsDown, seconds, keyCode] = KbCheck;
        keyCode = find(keyCode, 1);
        if keyIsDown
            KbReleaseWait;
            if keyCode == KbName('ESCAPE')
                ListenChar(0);
                ShowCursor();
                sca;
                break;
            elseif keyCode == KbName('LeftArrow')
                resp = 1;
                break;
            elseif keyCode == KbName('RightArrow')
                resp = 2;
                break;
            end
        end
    end
    
    Screen('BeginOpenGL', win);
    
    try
        dlmwrite([subject, '.csv'],...
            [source.RedX(trial), source.RedY(trial),...
            source.RedZ(trial), source.WhiteX(trial),...
            source.WhiteY(trial), source.WhiteZ(trial),...
            resp, (seconds-onset)],...
            '-append');
    catch
        sca;
        error('Cannot append to existing log file!');
    end
end

ListenChar(0);
ShowCursor();
sca;

end

function setcamera(camera)
% SETCAMERA sets camera yaw, pitch and roll.
%   setcamera([yaw, pitch, roll]); to set the scene
%   yaw - left to right possition
%   pitch - up and down possition
%   roll - rotation of camera it self
%
% See also this link <https://goo.gl/uqcAUD>

if length(camera) == 3
    glLoadIdentity;
    glRotatef(360-camera(2), 1, 0, 0);  % Pitch (360 deg is parallel)
    glRotatef(camera(1)-270, 0, 1, 0);  % Yaw (90 deg points in front)
    glRotatef(camera(3), 0, 0, 1);      % Camera roll (0 deg no rotation)    
    glTranslatef(-0.302, -0.125, 0.350);% Reset camera to origin
else
    error('Enter array consists of three values');
end
end

function drawsphere(coord, rgb)
% DRAWSPHERE draws a spehere on specified location with RGB defined color
%   drawsphere([0, 0, 0], [1, 1, 1]); draw a white sphere in center
%   drawsphere([1, 0, 0], [1, 1, 0]); draw a yellow sphere in right
%
% Coordinate has to be in array like same as color (RGB)

global GL;

r = 0.035;

glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [rgb(1), rgb(2), rgb(3), 1]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [rgb(1), rgb(2), rgb(3), 1]);

glPushMatrix;
glTranslatef(coord(1), coord(2), coord(3));
glutSolidSphere(r, 100, 100);
glPopMatrix;
end

function drawarena()
% DRAWARENA draws a floor, walls and mark in arena with textures
%   drawarena(); draws whole arena

global GL gltextargetFloor gltexFloor gltexWall gltextargetWall;

r = 0.5;

glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1.0 1.0 1.0 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1.0 1.0 1.0 1 ]);

% Floor
bindtexture(gltextargetFloor, gltexFloor)
glPushMatrix;
floor = gluNewQuadric;
gluQuadricTexture(floor, GL.TRUE);
glRotatef(90, 1, 0, 0);
gluDisk(floor, 0, r, 100, 100);
glPopMatrix;

% Wall
bindtexture(gltextargetWall, gltexWall)
glPushMatrix;
height = 1.0;
wall = gluNewQuadric;
gluQuadricTexture(wall, GL.TRUE);
glTranslatef(0, height, 0);
glRotatef(90, 1, 0, 0);
gluCylinder(wall, r, r, height, 100, 100);
glPopMatrix;

% Mark
glMaterialfv(GL.FRONT_AND_BACK, GL.AMBIENT, [1.0 1.0 0.0 1]);
glMaterialfv(GL.FRONT_AND_BACK, GL.DIFFUSE, [1.0 1.0 0.0 1]);
glPushMatrix
height = 0.1;
glTranslatef(0.017, height, 0.483);
glRotatef(90, 1, 0, 0);
mark = gluNewQuadric;
gluCylinder(mark, 0.025, 0.025, height, 100, 100);
glPopMatrix;
end

function bindtexture(gltextarget, gltex)
% BINDTEXTURE binds a image texture to a glu object.
%   It doesn't work on glut object because they don't have any texture
%   mapping by themself. If is crucial to load images into memmory before
%   OpenGl starts with SCREEN('BEGINOPENGL', WIN).
%
%   bindtexture(gltextargetFloor, gltexFloor);
%
%   For loading the texture use this snippet
%       img = imread('image.jpg');
%       tex = Screen('MakeTexture', win, img, [], 1);
%       [gltex, gltextarget] = Screen('GetOpenGLTexture', win, tex);

global GL;

glEnable(gltextarget);
glBindTexture(gltextarget, gltex);
glTexEnvfv(GL.TEXTURE_ENV,GL.TEXTURE_ENV_MODE,GL.MODULATE);

glTexParameteri(gltextarget, GL.TEXTURE_WRAP_S, GL.REPEAT);
glTexParameteri(gltextarget, GL.TEXTURE_WRAP_T, GL.REPEAT);

glTexParameteri(gltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
glTexParameteri(gltextarget, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
glTexParameteri(gltextarget, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
end