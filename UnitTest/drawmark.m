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