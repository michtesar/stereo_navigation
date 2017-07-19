function drawviewline
% DRAWLINE draws a testing lines to see
%   from and where camera looks also with
%   axes X and Y in space.
%
global GL;
global heightPoint viewPoint;

% Draw camera lines
drawsphere(0.302, 0.125, -0.350, [0.0, 1.0, 0.0, 1.0]);
drawsphere(heightPoint, 0.0, viewPoint, [0.0, 1.0, 0.0, 1.0]);

% Draw axes lines
glLineWidth(6.0);
glBegin(GL.LINES);
    glVertex3f(0.302, 0.125, -0.350);
    glVertex3f(heightPoint, 0.0, viewPoint);
glEnd();
end