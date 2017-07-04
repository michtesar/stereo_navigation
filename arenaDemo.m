function arenaDemo
% Weird axis
% X - backwards (minus goes right, plus goes left)
% Y - is up and down
% Z - far or close the object

% TODO:
%   [ ] Fix wrong coordinate system
%   [ ] Read table and loop over trials
%   [ ] Implement 346 degrees of camera pitch
%   [ ] Logfile
%   [ ] LPT integration
%   [ ] Check viewPointHeight if computes camera pitch OK

RedX = 0.243;
RedY = 0.339;
RedZ = 0.014;
WhiteX = 0.111;
WhiteY = 0.070;
WhiteZ = 0.014;
CameraAngle = 134;

global GL;

AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 1);
InitializeMatlabOpenGL;
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', 0, 0, [], [], [],...
    0, 0);

Screen('BeginOpenGL', win);
    ar = RectHeight(winRect) / RectWidth(winRect);
    glViewport(0, 0, RectWidth(winRect), RectHeight(winRect));
    glColor3f(1, 1, 0);
    glEnable(GL.LIGHT0);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    gluPerspective(30, 1/ar, 0.03, 100);
    glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 4]);
    glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);
    glClearColor(0.0, 0.0, 0.0, 0.0);   
    glEnable(GL.LIGHTING);
    glEnable(GL.DEPTH_TEST);
Screen('EndOpenGL', win);

Screen('BeginOpenGL', win);
    glMatrixMode(GL.MODELVIEW);
	glLoadIdentity;
    viewPoint = computeview(CameraAngle);
    heightPoint = viewPointHeight(346, viewPoint);
    
    % Axes:
    %   Eyes - left/right = X, up/down = Y, close/far = Z
    gluLookAt(0.302, 0.125, -0.350,...
              heightPoint, 0.0, viewPoint,...
              0, 1, 0);
    glClear;
    try
        drawsphere(RedX, RedZ, RedY, [1.0, 0.0, 0.0, 1.0]);
        drawsphere(WhiteX, WhiteZ, WhiteY, [1.0, 1.0, 1.0, 1.0]);
        
        % Show from where and where we look
        % In objects position are axes:
        %   left/right inverse = X, up/down = Y, close/far = Z
        %drawsphere(0.302, 0.125, -0.350, [0.0, 1.0, 0.0, 1.0]);
        %drawsphere(heightPoint, 0.0, viewPoint, [0.0, 1.0, 0.0, 1.0]);
        
%         glLineWidth(6.0);
%         glBegin(GL.LINES);
%             glVertex3f(0.302, 0.125, -0.350);
%             glVertex3f(heightPoint, 0.0, viewPoint);
%         glEnd();
%         
%         glLineWidth(6.0);
%         glBegin(GL.LINES);
%             glVertex3f(0.5, 0.05, 0.0);
%             glVertex3f(-0.5, 0.05, 0.0);
%         glEnd();
%         
%         glLineWidth(6.0);
%         glBegin(GL.LINES);
%             glVertex3f(0.0, 0.05, 0.5);
%             glVertex3f(0.0, 0.05, -0.5);
%         glEnd();
        
        drawmark(0.017, 0.483);
        drawfloor();
        drawarena();
    catch
        psychlasterror;
        sca;
    end
Screen('EndOpenGL', win);
Screen('Flip', win);
KbWait;
sca;
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

function drawsphere(x, y, z, color)
size = 0.02;
global GL
glPushMatrix;
    glTranslatef(x, y, z);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, color);
    qobj = gluNewQuadric();
    gluQuadricTexture(qobj, GL.TRUE);
    gluSphere(qobj, size, 60, 60);
glPopMatrix;
end

function drawarena()
global GL
height = 0.7;
size = 0.5;
readtexture('source/wall.jpg');
glPushMatrix;
    glRotatef(90, 1, 0, 0);
    glRotatef(90, 0, 0, 1);
    glTranslatef(0, 0, -height);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
    qobj = gluNewQuadric();
    gluQuadricTexture(qobj, GL.TRUE);
    glEnable(GL.TEXTURE_2D);
        gluCylinder(qobj, size, size, height, 40, 40);
    glDisable(GL.TEXTURE_2D);
glPopMatrix;
end

function drawfloor()
global GL
readtexture('source/floor.jpg');
glPushMatrix;
    glRotatef(90, 1, 0, 0);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
    qobj = gluNewQuadric();
    gluQuadricTexture(qobj, GL.TRUE);
    glEnable(GL.TEXTURE_2D);
        gluDisk(qobj, 0, 0.5, 60, 60);
    glDisable(GL.TEXTURE_2D);
glPopMatrix;
end

function drawmark(x, y)
global GL
size = 0.05;
diameter = 0.02;
glPushMatrix;
    glRotatef(90, 1, 0, 0);
    glTranslatef(x, y, -size);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 0, 0]);
    qobj = gluNewQuadric();
    gluCylinder(qobj, diameter, diameter, size, 60, 60);
glPopMatrix;
end

function viewPoint = computeview(angle)
% Using sine law to compute AAS triangle
% then add a lower part of circle x axe
% to get the view point.
a = 0.302;
beta = 180 - angle;
alpha = 180 - (90 + beta);
b = a * sind(beta) / sind(alpha);
offset = -0.350-(-0.5);
viewPoint = b+offset;
end

function heightPoint = viewPointHeight(angle, viewPoint)
c = viewPoint;
beta = angle;
alpha = 180-(90+beta);
heightPoint = c * sind(beta)/sind(alpha);
end