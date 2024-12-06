function p_reproj = reprojectPoints(P, M_tilde, K)
% Reproject 3D points given a projection matrix
%
% P: [nx3] coordinates of the 3d points in the world frame
% M_tilde: [3x4] projection matrix
% K: [3x3] camera matrix
%
% p_reproj: [nx2] coordinates of the reprojected 2d points

P = cat(2, P, ones(height(P), 1));
p_lambda = K * M_tilde * P';
p_reproj = p_lambda(1:2,:) ./ p_lambda(3,:);
p_reproj = p_reproj';

end

