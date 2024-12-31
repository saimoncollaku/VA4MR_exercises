function patch = getWarpedPatch(I, W, x_T, r_T)
% x_T is 1x2 and contains [x_T y_T] as defined in the statement. patch is
% (2*r_T+1)x(2*r_T+1) and arranged consistently with the input image I.

patch = zeros(2 * r_T + 1);

for idx = 1 : numel(patch)
    [y, x] = ind2sub(size(patch), idx);
    orig_coord = [x, y, 1];
    warp_coord = x_T + (orig_coord - r_T - 1) * W';

    if warp_coord(1) < 1 || warp_coord(2) < 1
        continue;
    end

    if warp_coord(1) > width(I) || warp_coord(2) > height(I)
        continue;
    end

    patch(y, x) = I(warp_coord(2), warp_coord(1));
end

end

