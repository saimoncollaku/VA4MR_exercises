function disp_img = getDisparity(...
    left_img, right_img, patch_radius, min_disp, max_disp)
% left_img and right_img are both H x W and you should return a H x W
% matrix containing the disparity d for each pixel of left_img. Set
% disp_img to 0 for pixels where the SSD and/or d is not defined, and for d
% estimates rejected in Part 2. patch_radius specifies the SSD patch and
% each valid d should satisfy min_disp <= d <= max_disp.

disp_img = zeros(size(left_img));
d_array = min_disp : max_disp;

for patch_idx = 1 : numel(left_img)
    [v_0, u_0] = ind2sub(size(left_img), patch_idx);

    % Out of bounds checks
    if u_0 - patch_radius - max_disp < 1
        continue
    end

    if v_0 - patch_radius < 1
        continue
    end

    if u_0 + patch_radius > width(disp_img)
        continue
    end

    if v_0 + patch_radius > height(disp_img)
        continue
    end
    % Fetch patch around p_0
    rw_indexes = v_0 - patch_radius : v_0 + patch_radius;
    cw_indexes = u_0 - patch_radius : u_0 + patch_radius;
    patch_0 = single(left_img(rw_indexes, cw_indexes));
    patch_0 = patch_0(:);
    patches_to_cmp = [];

    % Candidate patches building
    for d = min_disp : max_disp
        patch_1 = single(right_img(rw_indexes, cw_indexes - d));
        patch_1 = patch_1(:);
        patches_to_cmp = cat(2, patches_to_cmp, patch_1);
    end
    
    [ssd, best_d_idx] = pdist2(patches_to_cmp', patch_0', 'squaredeuclidean', 'Smallest', 4);
    
    
    % Filtering
    best_ssd = ssd(1);
    ssd_filter = ssd(4);

    if ssd_filter <= best_ssd * 1.5
        continue
    end

    if d_array(best_d_idx(1)) == min_disp
        continue
    end

    if d_array(best_d_idx(1)) == max_disp
        continue
    end

    % Sub-pixel refinement
    x = d_array(best_d_idx(1 : 3));
    y = ssd(1 : 3);
    p = polyfit(x, y, 2);
    x_range = min(x) : 0.1 : max(x);
    y_fitted = polyval(p, x_range);
    [~, min_idx] = min(y_fitted);
    best_d = x_range(min_idx);

    disp_img(v_0, u_0) = best_d;
end
