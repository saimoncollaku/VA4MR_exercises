function W = getSimWarp(dx, dy, alpha_deg, lambda)
% alpha given in degrees, as indicated

alpha = deg2rad(alpha_deg);

rot = [cos(alpha) sin(alpha);
       sin(alpha) cos(alpha)];

delta = [dx; dy];

W = lambda * [rot  delta];

end