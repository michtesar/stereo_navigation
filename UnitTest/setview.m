function setview(cameraAngle)
% SETVIEW sets a view point of where to look
%   and also specify camera position and where
%   to look at.
% Camera pitch - angle at X axe (left/right)
% Camera yaw - angle at Z axe (up/down)
%
global GL;
global heightPoint viewPoint;

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

viewPoint = camerapitch(cameraAngle);
heightPoint = camerayaw(346, viewPoint);

gluLookAt(0.0, 1.8, -0.5, 0.0, 0.0, 0.0, 0, 1, 0);
glClear;
end