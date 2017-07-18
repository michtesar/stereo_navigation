function drawarena()
global GL;
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
        glMatrixMode(GL.TEXTURE);
            glScalef(1.0, 1.0, 1.0);
        glMatrixMode(GL.MODELVIEW);
        gluCylinder(qobj, size, size, height, 40, 40);
    glDisable(GL.TEXTURE_2D);
glPopMatrix;
end