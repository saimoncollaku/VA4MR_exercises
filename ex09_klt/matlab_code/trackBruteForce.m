function [dx, ssds] = trackBruteForce(I_R, I, x_T, r_T, r_D)
% I_R: reference image, I: image to track point in, x_T: point to track,
% expressed as [x y]=[col row], r_T: radius of patch to track, r_D: radius
% of patch to search dx within; dx: translation that best explains where
% x_T is in image I, ssds: SSDs for all values of dx within the patch
% defined by center x_T and radius r_D.

range = -r_D : r_D;
numElements = numel(range);
W_0 = getSimWarp(0, 0, 0, 1);
T = getWarpedPatch(I_R, W_0, x_T, r_T);
ssds = zeros(2 * r_D + 1);

for idx = 1 : ((2 * r_D +1)^2)
    % Obtaining dx and dy
    [row, col] = ind2sub([numElements, numElements], idx);
    dx = range(col);
    dy = range(row);
    
    % Warping query with dx
    W = getSimWarp(dx, dy, 0, 1);
    I_w = getWarpedPatch(I, W, x_T, r_T);

    % Computing and storing error
    ssd = sum((I_w - T).^2, "all");
    ssds(dx + r_D + 1, dy + r_D + 1) = ssd;
end

[~ , idx] = min(ssds);
[dx, dy] = ind2sub(size(ssds), idx);
dx = [dx, dy] - r_D - 1;

