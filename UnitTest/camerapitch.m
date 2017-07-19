function viewPoint = camerapitch(angle)
% Using sine law to compute AAS triangle
% then add a lower part of circle x axe
% to get the view point.
a = 0.302;
beta = 180 - angle;
alpha = 180 - (90 + beta);
b = a * sind(beta) / sind(alpha);
offset = -0.350-(-0.5);
viewPoint = b+offset;
end