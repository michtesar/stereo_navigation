function heightPoint = viewPointHeight(angle, viewPoint)
c = viewPoint;
beta = angle;
alpha = 180-(90+beta);
heightPoint = c * sind(beta)/sind(alpha);
end