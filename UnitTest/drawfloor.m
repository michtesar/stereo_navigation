function drawfloor()
global GL
readtexture('source/floor.jpg');
glPushMatrix;
    glRotatef(90, 1, 0, 0);
    glMaterialfv(GL.FRONT, GL.DIFFUSE, [1, 1, 1, 0]);
    qobj = gluNewQuadric();
    gluQuadricTexture(qobj, GL.TRUE);
    glEnable(GL.TEXTURE_2D);
        gluDisk(qobj, 0, 0.5, 60, 60);
    glDisable(GL.TEXTURE_2D);
glPopMatrix;
end