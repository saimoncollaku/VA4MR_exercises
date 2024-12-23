function [points, intensities] = disparityToPointCloud(...
    disp_img, K, baseline, left_img)
% points should be 3xN and intensities 1xN, where N is the amount of pixels
% which have a valid disparity. I.e., only return points and intensities
% for pixels of left_img which have a valid disparity estimate! The i-th
% intensity should correspond to the i-th point.


K_1 = inv(K);
b_vector = [baseline; 0; 0];
points = [];
intensities = [];

for px_idx = 1 : numel(disp_img)
    [v, u] = ind2sub(size(disp_img), px_idx);
    d = disp_img(px_idx);

    if d == 0
        continue
    end

    % Triangulate world point
    A_1 = K_1 * [u, v, 1]';
    A_2 = K_1 * [u - d, v, 1]';
    A = cat(2, A_1, A_2);
    lambda = inv(A' * A) * A' * b_vector;
    P = lambda(1) * K_1 * [u, v, 1]';

    % Fill data matrices
    points = cat(2, points, P);
    I = left_img(px_idx);
    intensities = cat(2, intensities, I);
end
