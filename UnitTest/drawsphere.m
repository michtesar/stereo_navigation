function drawsphere(x, y, z, color)
% DRAWSPHERE draws a sphere into a arena
%   defined by a coordinates in X, Y and Z.
%   With color declared as RGB(0-255) vector.
%
size = 0.03;
global GL

glPushMatrix;
    glTranslatef(x, y, z);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, color);
    qobj = gluNewQuadric();
    gluQuadricTexture(qobj, GL.TRUE);
    gluSphere(qobj, size, 60, 60);
glPopMatrix;
end