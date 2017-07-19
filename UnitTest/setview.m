function setview(cameraAngle)
% SETVIEW sets a view point of where to look
%   and also specify camera position and where
%   to look at.
% Camera pitch - angle at X axe (left/right)
% Camera yaw - angle at Z axe (up/down)
%
global GL;
global heightPoint viewPoint;
global topView;

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

viewPoint = camerapitch(cameraAngle);
heightPoint = camerayaw(346, viewPoint);

if topView
    gluLookAt(0.0, 1.8, -0.5, 0.0, 0.0, 0.0, 0, 1, 0);
else
    gluLookAt(0.0, 0.5, -0.5, 0.0, 0.0, 0.0, 0, 1, 0);
end
glClear;
end