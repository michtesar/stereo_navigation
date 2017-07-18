function drawsphere(x, y, z, color)
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