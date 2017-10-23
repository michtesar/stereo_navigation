function setview(cameraAngle, view)
% SETVIEW sets a view point of where to look
%   and also specify camera position and where
%   to look at.
%
% Camera pitch - angle at X axe (left/right)
% Camera yaw - angle at Z axe (up/down)
%
% Coordinate system:
%   X - backwards (negative goes right, positive goes left)
%   Y - is up and down
%   Z - far or close the object
%
global GL;
global heightPoint viewPoint;
global topView;
global CameraX CameraY CameraZ
global cameraYaw

glMatrixMode(GL.MODELVIEW);
glLoadIdentity;

if view == 0
    eyePosition = -0.08;
else
    eyePosition = 0.08;
end
eyesDistance = 0.04;

viewPoint = camerapitch(cameraAngle);
heightPoint = camerayaw(cameraYaw, viewPoint);

if topView
    gluLookAt(eyePosition * eyesDistance, 1.8, -0.5, 0.0, 0.0, 0.0, 0, 1, 0);
else
   gluLookAt(-CameraX + (eyePosition * eyesDistance), CameraZ, CameraY, heightPoint, 0.0,...
       viewPoint, 0, 1, 0);
end
glClear;
end