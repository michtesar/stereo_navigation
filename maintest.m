clear;

g = Graphic;

a = Arena(0, 0, 0);

g.setView(0, 0, 5, 1, 0, 0);
g.drawSphere(-1.0, 0.0, 0.0);
g.drawSphere(1.0, 0.0, 0.0);
g.drawTeapot(0.0, 0.0, -9.0);
g.drawSphere(0.0, 0.0, 0.0);
g.drawText('Hello, world!');
g.wait;

g.drawInstruction('Zmáèknìte libovolné tlaèítko pro pokraèování!');
g.wait;

g.setView(0, 0, 5, 0, 0, 0);
g.drawPlanet('venusmeb.jpg', -1.0, 0.0, 0.0);
g.drawPlanet('dirt.png', 1.0, 0.0, 0.0);
g.drawSphere(0.3, 1.0, 0.0);
g.wait;

g.close;