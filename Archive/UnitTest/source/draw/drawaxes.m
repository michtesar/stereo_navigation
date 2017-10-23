function drawaxes
global GL;
glLineWidth(6.0);
glBegin(GL.LINES);
    glVertex3f(0.5, 0.05, 0.0);
    glVertex3f(-0.5, 0.05, 0.0);
glEnd();

glLineWidth(6.0);
glBegin(GL.LINES);
    glVertex3f(0.0, 0.05, 0.5);
    glVertex3f(0.0, 0.05, -0.5);
glEnd();
end