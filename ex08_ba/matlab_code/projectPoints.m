function [projected_points] = projectPoints(points_3d, K)
% Projects 3d points to the image plane (3xN), given the camera matrix
% (3x3).

% get image coordinates
projected_points = K * points_3d;
projected_points = projected_points  ./ projected_points (3,:);

end
