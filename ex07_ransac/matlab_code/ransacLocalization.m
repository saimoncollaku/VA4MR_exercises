function [R_C_W, t_C_W, best_inlier_mask, max_num_inliers_history, num_iteration_history] ...
    = ransacLocalization(matched_query_keypoints, corresponding_landmarks, K)
% query_keypoints should be 2x1000
% all_matches should be 1x1000 and correspond to the output from the
%   matchDescriptors() function from exercise 3.
% best_inlier_mask should be 1xnum_matched (!!!) and contain, only for the
%   matched keypoints (!!!), 0 if the match is an outlier, 1 otherwise.

max_k = 2000;
best_inliers = -1;
max_num_inliers_history = [];
matched_query_keypoints = flipud(matched_query_keypoints);
admissible_error = 10;

for k = 1 : max_k
    [p, idx] = datasample(matched_query_keypoints, 6, 2, "Replace", false);
    P = corresponding_landmarks(:, idx);

    M = estimatePoseDLT(p', P', K);
    landmarks_reproj = reprojectPoints(corresponding_landmarks', M, K)';
    errors = vecnorm(matched_query_keypoints - landmarks_reproj(1:2, :), 2, 1);
    inliers_mask = errors < admissible_error;
    n_inliers = nnz(inliers_mask);

    if n_inliers > best_inliers
        best_inliers = n_inliers;
        best_inlier_mask = inliers_mask;
    end
    max_num_inliers_history = cat(2, max_num_inliers_history, best_inliers);
end

M = estimatePoseDLT(...
        matched_query_keypoints(:, best_inlier_mask>0)', ...
        corresponding_landmarks(:, best_inlier_mask>0)', K);
R_C_W = M(:, 1:3);
t_C_W = M(:, end);
num_iteration_history = 1 : max_k;

end

