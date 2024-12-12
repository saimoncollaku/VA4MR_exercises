function descriptors = describeKeypoints(img, keypoints, r)
% Returns a (2r+1)^2xN matrix of image patch vectors based on image
% img and a 2xN matrix containing the keypoint coordinates.
% r is the patch "radius".

% TODO: Your code here
descriptors = [];
img = padarray(img, ones(2,1) * r, 0);
for i = 1 : width(keypoints)
    s_x = max(keypoints(2, i), 1) : min(keypoints(2, i) + 2 * r, width(img));
    s_y = max(keypoints(1, i), 1) : min(keypoints(1, i) + 2 * r, height(img));
    patch = img(s_y, s_x);
    desc = reshape(patch, [(2*r+1)^2, 1]);
    descriptors = cat(2, descriptors, desc);
end

end
