function Stereo_Czech(subjectId, subjectSex, subjectAge)
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
saveBuffer = false;

% Initialize EEG
close_ports();
global eeg;
eeg = serial('COM3', 'BAUD', 115200, 'DataBits', 8);
fopen(eeg);

% Create subject logfile
try
    dateTimestamp = datestr(datetime);
    dateTimestamp = strrep(dateTimestamp, ':', '-');
    dateTimestamp = strrep(dateTimestamp, ' ', '_');
    subject = sprintf('%s_%s%d_%s', subjectId, subjectSex,...
        subjectAge, dateTimestamp);
catch
    error('Cannot create logfile. Experiment is over...');
end

% Create a logfile and write a header
try
    log = fopen([subject, '.csv'], 'wt');
    fprintf(log, ['RedX, RedY, RedZ, WhiteX, WhiteY,',...
        'WhiteZ, CameraPitch, CameraRoll, CameraYaw,',...
        'Response, RTms, StimOnsetClock, Name, IsCorrect,',...
        'BlockAnswer, Missed, ResponseOnsetClock, TaskType, Stereo\n']);
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
Screen('TextFont', win, 'calibri');

% Show initial instructions
instructionText = 'Dobr� den!\nD�kujeme za V� �as p�i participaci na experimentu prostorov� navigace.\nRozhodn�te, kter� z koul� v ar�n� je bl�e v��i specifikovan�mu bodu na obrazovce.\nOdpov�dat m��ete pomoc� kl�ves LEV� a PRAV� �ipky.\n\nStiskn�te LIBOVOLNOU kl�vesu pro pokra�ov�n�...';
for view = 0:1
    Screen('SelectStereoDrawbuffer', win, view);
    DrawFormattedText(win, double(instructionText), 'center', 'center', [1 1 1], [], [], [], 2);
end
Screen('Flip', win);
KbWait([], 3);
Screen('Flip', win);

% Start EEG recording
sendtag(254);

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
blockIndex = 0;
averageRT = 0;
missed = 0;

for trial = 1:height(source)
    blockIndex = blockIndex + 1;
    blockAnswer = 'None';
    miss = 0;
    responseTimestamp = 0;
    floorRotation = randi([-360, 360]);
    Screen('EndOpenGL', win);
    
    % Give instuction for a block if any
    if source.Pause(trial)
        instructionText = sprintf('%s\n\n\nStiskn�te PRAVOU �ipku pro pokra�ov�n�\n\n\n%d - %d / 8', char(source.TypeCS(trial)), source.Repetition(trial), source.BlockRepetition(trial));
        for view = 0:1
            Screen('SelectStereoDrawbuffer', win, view);
            DrawFormattedText(win, double(instructionText), 'center', 'center', [1 1 1], [], [], [], 2);
        end
        Screen('Flip', win);
        KbWait([], 2);
        while 1
            [keyIsDown, ~, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(KbName('RightArrow'))
                    break
                end
            end
        end
        Screen('Flip', win);
        
        % Draw fixation cross to start new block with focus on screen
        for view = 0:1
            Screen('SelectStereoDrawbuffer', win, view);
            DrawFormattedText(win, '+', 'center', 'center', [1 1 1]);
        end
        Screen('Flip', win);
        WaitSecs(2);
    end
    
    for view = 0:1
        Screen('SelectStereoDrawbuffer', win, view);
        Screen('BeginOpenGL', win);

        glClear;

        glPushMatrix;  
        
        % Set camera angles and draw arena
        setcamera([source.Yaw(trial), source.Pitch(trial), source.Roll(trial)],...
            [source.CameraX(trial), source.CameraY(trial), source.CameraZ(trial)]);
        if view == 0 && source.Stereo(trial) == categorical(1)
            glTranslatef(0.005, 0, 0);
        elseif view == 1 && source.Stereo(trial) == categorical(1)
            glTranslatef(-0.005, 0, 0);
        end
        drawarena(floorRotation);

        % Draw spheres
        drawsphere([source.RedX(trial), source.RedY(trial),...
            source.RedZ(trial)], [1, 0, 0]);
        drawsphere([source.WhiteX(trial), source.WhiteY(trial),...
            source.WhiteZ(trial)], [1, 1, 1]);

        glPopMatrix;

        Screen('EndOpenGL', win);    
    end
    
    Screen('DrawingFinished', win, 2);
    
    % Prepare a onset tag value
    % Red - 1
    % Closer to you - 2
    % Closer to yellow mark - 3
    % Stereo adds 0 (no stereo) or 1 (is stereo)
    % Example:
    %   11 - Red, Stereo
    %   20 - Closer to you, No stereo
    % For answer - 1 (Correct), 2 (Incorrect)
    onsetTag = 0;
    if strcmp(char(source.Type(trial)), "Red")
        onsetTag = "1";
    elseif strcmp(char(source.Type(trial)), "Closer to you")
        onsetTag = "2";
    elseif strcmp(char(source.Type(trial)), "Closer to yellow mark")
        onsetTag = "3";
    end
    if strcmp(char(source.Stereo(trial)), "0")
        onsetTag = onsetTag + "0";
    else
        onsetTag = onsetTag + "1";
    end
    
    % Send onset tag of scene
    try
        sendtag(double(onsetTag))
    catch
        warning('Cannot send scene onset tag')
    end
    
    % Draw whole scene on screen
    arenaOnset = Screen('Flip', win);
    if saveBuffer == true
        imageArray = Screen('GetImage', win);
        imageName = ['./images/img_', num2str(source.Repetition(trial)), '_', num2str(source.BlockRepetition(trial)), '_', num2str(trial), '_', source.Name{trial}, '.png'];
        imwrite(imageArray, imageName);
    end
    
    t = 1.5;
    rtMs = 0;
    resp = 'None';
    correctKeyBySource = char(source.CorrectAnswer(trial));
    correctAnswer = false;
    
    % Wait for first input (reaction on arena screen) up to 1500 ms
    [arenaSec, keyCode, ~] = KbWait([], [], arenaOnset+t);
    if find(keyCode == 1)
        resp = KbName(keyCode==1);
        if strcmp(correctKeyBySource, resp)
            sendtag(1);
            correct = correct + 1;
            correctAnswer = true;
        else
            sendtag(2);
        end
        clear keyCode;
        rtMs = (arenaSec - arenaOnset) * 1000;
        responseTimestamp = arenaSec;
    end
    
    WaitSecs((t) - (arenaSec - arenaOnset));
    
    % Draw fixation cross up to 1500 ms for alte response
    for view = 0:1
        Screen('SelectStereoDrawbuffer', win, view);
        DrawFormattedText(win, '+', 'center', 'center', [1 1 1]);
    end
    
    lateOnset = Screen('Flip', win);
    [lateSec, keyCode, ~] = KbWait([], [], lateOnset+t);
    if find(keyCode == 1)
        if rtMs == 0
            resp = KbName(keyCode==1);
            if strcmp(correctKeyBySource, resp)
                sendtag(1);
                correct = correct + 1;
                correctAnswer = true;
            else
                sendtag(2);
            end
            clear keyCode;
            rtMs = (lateSec - arenaOnset) * 1000;
            responseTimestamp = lateSec;
        end
    end
    WaitSecs((t) - (lateSec - lateOnset));
    
    if rtMs == 0 || ~(strcmp('LeftArrow', resp) || strcmp('RightArrow', resp))
        missed = missed + 1;
        miss = 1;
    end
    
    % Close experiment if ESCAPE was pressed
    if strcmp(resp, 'ESCAPE')
        Screen('BeginOpenGL', win);
        break
    end
    
    if rtMs > 0
        averageRT = averageRT + rtMs;
    end
     
    % If defined show feedback of single trial for t = 500 ms
    if source.Feedback(trial)
        if correctAnswer
            for view = 0:1
                Screen('SelectStereoDrawbuffer', win, view);
                DrawFormattedText(win, double('Spr�vn�!'), 'center', 'center', [1 1 1]);
            end
        else
            for view = 0:1
                Screen('SelectStereoDrawbuffer', win, view);
                DrawFormattedText(win, double('�patn�!'), 'center', 'center', [1 1 1]);
            end
        end
        Screen('Flip', win);
        WaitSecs(0.5);
    end
    
    % Give feedback if training
    if source.BlockEnd(trial)
        instructionText = sprintf('O jak� blok �lo?\n %c      bl�e k V�m\n%c      bl�e ke �lut� zna�ce\n%c      �erven� koule\n MEZERN�K       nev�m',...
            8592, 8594, 8593);
        for view = 0:1
            Screen('SelectStereoDrawbuffer', win, view);
            DrawFormattedText(win, double(instructionText), 'center', 'center', [1 1 1], [], [], [], 5);
        end
        scoreText = sprintf('Sk�re: %.0f %% z %.0f pokus�\nVynechan�ch: %d\nPr�m�rn� �as reakce: %.0f ms',...
            (correct/blockIndex)*100, blockIndex, missed, averageRT/(blockIndex-missed));
        
        for view = 0:1
            Screen('SelectStereoDrawbuffer', win, view);
            DrawFormattedText(win, double(scoreText), 'center', winRect(4) - 150, [0 1 0], [], [], [], 2);
        end
        % Reset feedback variables
        correct = 0;
        blockIndex = 0;
        missed = 0;
        averageRT = 0;
        Screen('Flip', win);
       
        KbWait([], 2);
        while 1
            [keyIsDown, ~, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(KbName('RightArrow'))
                    blockAnswer = 'Mark';
                    break
                elseif keyCode(KbName('LeftArrow'))
                    blockAnswer = 'You';
                    break
                elseif keyCode(KbName('UpArrow'))
                    blockAnswer = 'Sphere';
                    break
                elseif keyCode(KbName('SPACE'))
                    blockAnswer = 'not sure';
                    break
                end
            end
        end
        Screen('Flip', win);  
    end
    
    Screen('BeginOpenGL', win);
 
    % Append to logfile experiment variables
    try
        fprintf(log, '%0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %0.4f, %s, %0.4f, %0.4f, %s, %d, %s, %d, %d, %s, %d\n',...
            source.RedX(trial), source.RedY(trial), source.RedZ(trial),...
            source.WhiteX(trial), source.WhiteY(trial),...
            source.WhiteZ(trial), source.Pitch(trial),...
            source.Roll(trial), source.Yaw(trial), resp,...
            rtMs, arenaOnset, source.Name{trial}, correctAnswer,...
            blockAnswer, miss, responseTimestamp, char(source.Type(trial)),...
            str2num(char(source.Stereo(trial))));
    catch
        sca;
        fclose(log);
        error('Cannot append to existing log file!');
    end
end

% Stop EEG recording
sendtag(255);

fclose(eeg);

Screen('EndOpenGL', win);

% Ending instructions
instructionText = 'Experiment je u konce\nUkon�ete jej stiknut�m LIBOVOLN� kl�vesy...';
for view = 0:1
    Screen('SelectStereoDrawbuffer', win, view);
    DrawFormattedText(win, double(instructionText), 'center', 'center', [1 1 1], [], [], [], 2);
end
Screen('Flip', win);
KbWait;

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

function drawarena(floorRotation)
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
glRotatef(floorRotation, 0, 0, 1);
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
glRotatef(180, 0, 0, 1);
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
    global eeg;
    try
        fwrite(eeg, tag);
    catch
        warning('Cannot write tag');
    end
end

function close_ports()
% In any case the port stays open CLOSE_PORTS
% shutdown all ports
%
     if ~isempty(instrfind)
         fclose(instrfind);
         delete(instrfind);
     end
end