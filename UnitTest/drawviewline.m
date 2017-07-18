function drawviewline
global GL;
global heightPoint viewPoint;
drawsphere(0.302, 0.125, -0.350, [0.0, 1.0, 0.0, 1.0]);
drawsphere(heightPoint, 0.0, viewPoint, [0.0, 1.0, 0.0, 1.0]);
        
glLineWidth(6.0);
glBegin(GL.LINES);
    glVertex3f(0.302, 0.125, -0.350);
    glVertex3f(heightPoint, 0.0, viewPoint);
glEnd();
end