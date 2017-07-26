function drawviewline
% DRAWLINE draws a testing lines to see
%   from and where camera looks also with
%   axes X and Y in space.
%
global GL;
global heightPoint viewPoint;
global CameraX CameraY CameraZ

% Draw camera lines
drawsphere(-CameraX, CameraZ, CameraY, [0.0, 1.0, 0.0, 1.0]);
drawsphere(-heightPoint, 0.0, viewPoint, [0.0, 1.0, 0.0, 1.0]);

% Draw axes lines
glLineWidth(6.0);
glBegin(GL.LINES);
    glVertex3f(-CameraX, CameraZ, CameraY);
    glVertex3f(-heightPoint, 0.0, viewPoint);
glEnd();
end