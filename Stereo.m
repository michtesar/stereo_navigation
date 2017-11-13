function Stereo(subject)
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

load src/source.mat;

if nargin < 1
    subject = 'default';
end

% Create a logfile and write a header
try
    log = fopen([subject, '.csv'], 'wt');
    fprintf(log, ['RedX, RedY, RedZ, WhiteX, WhiteY,',...
        'WhiteZ, CameraPitch, CameraRoll, CameraYaw,',...
        'Response, RTms, StimOnsetClock, Name, IsCorrect\n']);
catch
    error('Cannot write or open a logfile!');
end

Screen('Preference', 'SkipSyncTests', 2);
PsychDefaultSetup(2);

HideCursor();
ListenChar(2);

InitializeMatlabOpenGL;

[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [], 1, 0);

% Read textures into buffer before star to speeding up the experiment
global gltextargetFloor gltexFloor gltexWall gltextargetWall;
imgFloor = imread('img/floor.jpg');
texFloor = Screen('MakeTexture', win, imgFloor, [], 1);
[gltexFloor, gltextargetFloor] = Screen('GetOpenGLTexture', win, texFloor);
imgWall = imread('img/wall.jpg');
texWall = Screen('MakeTexture', win, imgWall, [], 1);
[gltexWall, gltextargetWall] = Screen('GetOpenGLTexture', win, texWall);

Screen('TextSize', win, 30);

% Show initial instructions
text = 'Wellcome in navigation experiment.\nYour goal is to navigate in arena\n\nPress any KEY to continue.';
DrawFormattedText(win, text, 'center', 'center', [1 1 1]);
Screen('Flip', win);
KbStrokeWait;

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

correct = 0;
KbQueueCreate(-1);
KbQueueCreate;
KbQueueStart;

for trial = 1:height(source)
    Screen('EndOpenGL', win);
    
    % Give instuction for a block if any
    if source.Pause(trial)
        text = sprintf('This is a block of %s', source.Type{trial});
        DrawFormattedText(win, text, 'center', 'center', [1 1 1]);
        Screen('Flip', win);
        KbStrokeWait;
    end
    
    for view = 0:1
        Screen('SelectStereoDrawbuffer', win, view);
        Screen('BeginOpenGL', win);

        glClear;

        glPushMatrix;  
        
        % Set camera angles and draw arena
        setcamera([source.Yaw(trial), source.Pitch(trial), source.Roll(trial)],...
            [source.CameraX(trial), source.CameraY(trial), source.CameraZ(trial)]);
        if view == 0 && source.Stereo(trial) == 1
            glTranslatef(0.005, 0, 0);
        elseif view == 1 && source.Stereo(trial) == 1
            glTranslatef(-0.005, 0, 0);
        end
        drawarena;

        % Draw spheres
        drawsphere([source.RedX(trial), source.RedY(trial),...
            source.RedZ(trial)], [1, 0, 0]);
        drawsphere([source.WhiteX(trial), source.WhiteY(trial),...
            source.WhiteZ(trial)], [1, 1, 1]);

        glPopMatrix;

        Screen('EndOpenGL', win);    
    end
    
    Screen('DrawingFinished', win, 2);
    onset = Screen('Flip', win);
    
    % Send onset tag of scene
    try
        sendtag(10);
    catch
        warning('Cannot send scene onset tag')
    end
    
    KbQueueFlush;
    WaitSecs(3.0);

    [pressed, firstPress] = KbQueueCheck;

    if pressed
        firstPress(firstPress == 0) = NaN;
        [reaction, keyIndex] = min(firstPress);
        key = KbName(keyIndex); 
        if strcmp(key, 'ESCAPE')
            ListenChar(0);
            ShowCursor();
            sca;
            break;
        elseif strcmp(key, 'LeftArrow')
            resp = 'left';
        elseif strcmp(key, 'RightArrow')
            resp = 'right';
        end
        rt = (reaction-onset)*1000;
    else
        rt = 0.0;
    end
    
    % Decide if response was correct or not
    if strcmp(resp, source.Correct{trial})
        correctAnswer = true;
        correct = correct + 1;
    else
        correctAnswer = false;
    end
    
    % Send response tag based on pressed key
    %   1 - Correct answer
    %   2 - Incorrect answer
    try
        if correctAnswer
            sendtag(1);
        else
            sendtag(2);
        end
    catch
        warning('Cannot send response tag');
    end
    
    % Show black screen for baseline t = 500 - 1000 ms (random)
    DrawFormattedText(win, '+', 'center', 'center', [1 1 1]);
    Screen('Flip', win);
    WaitSecs(0.5+rand);
    
    % Give feedback if training
    if source.Feedback(trial)
        text = sprintf('Correct %d out of %d (%0.2f %%) trials',...
            correct, 8, correct/8*100);
        DrawFormattedText(win, text, 'center', 'center', [1 1 1]);
        correct = 0;
        Screen('Flip', win);
        KbStrokeWait;
    end
    
    Screen('BeginOpenGL', win);
 
    % Append to logfile experiment variables
    try
        fprintf(log, '%0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %s, %0.4f, %0.4f, %s, %d\n',...
            source.RedX(trial), source.RedY(trial), source.RedZ(trial),...
            source.WhiteX(trial), source.WhiteY(trial),...
            source.WhiteZ(trial), source.Pitch(trial),...
            source.Roll(trial), source.Yaw(trial), resp,...
            rt, onset, source.Name{trial}, correctAnswer);
    catch
        sca;
        fclose(log);
        error('Cannot append to existing log file!');
    end
end

% Ending instructions
text = 'This is end of experiment\nFinish it with ANY key...';
DrawFormattedText(win, text, 'center', 'center', [1 1 1]);
Screen('Flip', win);
KbStrokeWait;

ListenChar(0);
ShowCursor();
fclose(log);
sca;

end

function setcamera(camera, origin)
% SETCAMERA sets camera yaw, pitch and roll.
%   setcamera([yaw, pitch, roll]); to set the scene
%   yaw - left to right possition
%   pitch - up and down possition
%   roll - rotation of camera it self
%
% See also this link <https://goo.gl/uqcAUD>

if length(camera) == 3 && length(origin) == 3
    glLoadIdentity;
    glRotatef(360-camera(2), 1, 0, 0);  % Pitch (360 deg is parallel)
    glRotatef(camera(1)-270, 0, 1, 0);  % Yaw (90 deg points in front)
    glRotatef(camera(3), 0, 0, 1);      % Camera roll (0 deg no rotation)
    glTranslatef(-origin(1), -origin(3), -origin(2));
else
    error('Enter two arrays consists of three values');
end
end

function drawsphere(coord, rgb)
% DRAWSPHERE draws a spehere on specified location with RGB defined color
%   drawsphere([0, 0, 0], [1, 1, 1]); draw a white sphere in center
%   drawsphere([1, 0, 0], [1, 1, 0]); draw a yellow sphere in right
%
% Coordinate has to be in array like same as color (RGB)

global GL;

r = 0.0415;

glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [rgb(1), rgb(2), rgb(3), 1]);
glMaterialfv(GL.FRONT_AND_BACK,GL.DIFFUSE, [rgb(1), rgb(2), rgb(3), 1]);

glPushMatrix;
glTranslatef(coord(1), coord(3), coord(2));
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
height = 0.153;
glTranslatef(0.017, height, 0.483);
glRotatef(90, 1, 0, 0);
mark = gluNewQuadric;
gluCylinder(mark, 0.0345, 0.0345, height, 100, 100);
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

function sendtag(tag)
% SENDTAG is communication function with Biosemi ActiveTwo
% via serial port as emulator to paraller port.
%
    eeg = serial('COM3', 'BAUD', 115200, 'DataBits', 8);
    fopen(eeg);
    try
        fwrite(eeg, tag);
    catch ME
        warning(strcat(ME, ' cannot write tag'));
        fclose(eeg);
    end
    fclose(eeg);
end