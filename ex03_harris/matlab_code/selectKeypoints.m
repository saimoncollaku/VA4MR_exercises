function keypoints = selectKeypoints(scores, num, r)
% Selects the num best scores as keypoints and performs non-maximum 
% supression of a (2r + 1)*(2r + 1) box around the current maximum.

% TODO: Your code here


keypoints = [];
for i = 1:num
    [~, k] = max(scores(:));
    [k_x, k_y] = ind2sub(size(scores),k);
    keypoints = cat(2, keypoints, [k_x; k_y]);
    s_x = max(k_x-r, 1) : min(k_x+r, size(scores, 1));
    s_y = max(k_y-r, 1) : min(k_y+r, size(scores, 2));
    scores(s_x, s_y) = 0;
end

end

