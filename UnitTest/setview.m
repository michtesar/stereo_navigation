function setview(cameraAngle)
global GL;
global heightPoint viewPoint;
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
viewPoint = computeview(cameraAngle);
heightPoint = viewPointHeight(346, viewPoint);
gluLookAt(0.0, 1.8, -0.5, 0.0, 0.0, 0.0, 0, 1, 0);
glClear;
end