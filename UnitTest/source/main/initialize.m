function initialize(fieldOfView)
% INITIALIZE initilize a OpenGL with lighting
%   and perspective for PsychToolBox enviroment.
% Input:
%   fieldOfView - double - field of visual angle
%                 default is 30 degreese
%   
if nargin < 0
    fieldOfView = 30;
end

global win;
global GL;
global winRect;

Screen('BeginOpenGL', win);
    ar = RectHeight(winRect) / RectWidth(winRect);
    glViewport(0, 0, RectWidth(winRect), RectHeight(winRect));
    glColor3f(1, 1, 0);
    glEnable(GL.LIGHT0);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    gluPerspective(fieldOfView, 1/ar, 0.03, 100);
    glLightfv(GL.LIGHT0, GL.POSITION, [1 2 3 4]);
    glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE, GL.TRUE);
    glClearColor(0.0, 0.0, 0.0, 0.0);   
    glEnable(GL.LIGHTING);
    glEnable(GL.DEPTH_TEST);
Screen('EndOpenGL', win);
end