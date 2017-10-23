function StereoPilot2()
% Positive x-Axis points horizontally to the right.
% Positive y-Axis points vertically upwards.
% Positive z-Axis points to the observer.
% Positive yaw camera rotation leads to move camera to the left.
% Positive pitch camera rotation moves camera to the top and looks down.
% Positive roll camera rotation spins camera itself counter-clockwise.

load source;

global gltextargetFloor gltexFloor gltexWall gltextargetWall;

Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);

HideCursor();
ListenChar(2);

screenID = max(Screen('Screens'));

InitializeMatlabOpenGL([], [], [], 0);

[win, winRect] = PsychImaging('OpenWindow', screenID, 0, [], [], [], 0, 0);

% Read textures - nejde to nikam pøesouvat
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

fov = 60;
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
gluPerspective(fov, 1/ar, 0.001, 100);

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);

gluLookAt(0.302, 0.125, -0.350, 0.302, 0.125, 0.5, 0, 1, 0);
glClearColor(0, 0, 0, 0);
glClear;

for trial = 1:height(source)
    yaw = source.Yaw(trial)-90;
    pitch = 346-360;
    roll = 0;
    
    glClear;
    
    glPushMatrix;   
    % Set camera angles
    setcamera([yaw, pitch, roll]); % otáèím se pozirtivními hodnotami po smìru hodinových ruèièek a pohled pøed sebe rovnì je 90 stupòù
    drawarena;

    drawsphere([source.RedX(trial), source.RedY(trial), source.RedZ(trial)], [1, 0, 0]);
    drawsphere([source.WhiteX(trial), source.WhiteY(trial), source.WhiteZ(trial)], [1, 1, 1]);
    
    glPopMatrix;
    Screen('EndOpenGL', win);
    
    % Show some informations first
    text = sprintf('Trial %d info\nRed:\t\tx = %0.3f, y = %0.3f, z = %0.3f\nWhite:\tx = %0.3f, y = %0.3f, z = %0.3f\nYaw = %0.0f, Pitch = %0.0f, Roll = %d\nFOV = %0.0f',...
        trial, source.RedX(trial), source.RedY(trial), source.RedZ(trial), source.WhiteX(trial), source.WhiteY(trial), source.WhiteZ(trial), yaw+90, pitch+360, roll, fov);
    Screen('TextSize', win, 40);
    Screen('TextStyle', win, 0);
    DrawFormattedText(win, text, 100, 200, [255 255 255]);
    DrawFormattedText(win, 'Navigate to next trial by pressing left of right arrows', 'center', 100, [255 255 0]);
    DrawFormattedText(win, 'Press ESC to quit experiment', 'center', winRect(4) - 100, [255 0 0]);
    
    Screen('Flip', win);
    
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

                break;
            elseif keyCode == KbName('RightArrow')
                break;
            end
        end
    end
    
    Screen('BeginOpenGL', win);
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
    glRotatef(camera(1), 0, 1, 0);  % Camera yaw
    glRotatef(camera(2), 1, 0, 0);  % Camera pitch
    glRotatef(camera(3), 0, 0, 1);  % Camera roll 
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
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1.0 1.0 0.0 1 ]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [ 1.0 1.0 0.0 1 ]);
glPushMatrix
height = 0.1;
glTranslatef(0.017, height, 0.483);
glRotatef(90, 1, 0, 0);
mark = gluNewQuadric;
gluCylinder(mark, 0.025, 0.025, height, 100, 100);
glPopMatrix;
end

function bindtexture(gltextarget, gltex)
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