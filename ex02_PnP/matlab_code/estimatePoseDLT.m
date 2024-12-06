function M_tilde = estimatePoseDLT(p, P, K)
% Estimates the pose of a camera using a set of 2D-3D correspondences and a
% given camera matrix
%
% p: [nx2] vector containing the undistorted coordinates of the 2D points
% P: [nx3] vector containing the 3D point positions
% K: [3x3] camera matrix
%
% M_tilde: [3x4] projection matrix under the form M_tilde=[R_tilde|alpha*t] where R is a rotation
%    matrix. M_tilde encodes the transformation that maps points from the world
%    frame to the camera frame

% Convert 2D points to normalized coordinates
p = cat(2, p, ones(height(p), 1));
p_n = (K \ p')';
assert(all(p_n(:,3) == ones(size(p, 1), 1)))
p_n(:,3) = [];
P = cat(2, P, ones(height(P), 1));

% Build the measurement matrix Q
Q = [];
for i = 1:height(P)
    p_kron = cat(2,eye(2), -p_n(i,:)');
    Q = cat(1, Q, kron(p_kron, P(i,:)));
end

% Solve for Q.M_tilde = 0 subject to the constraint ||M_tilde||=1
[~, ~, V] = svd(Q);
M_tilde =  V(:,12);

%% Extract [R|t] with the correct scale from M_tilde ~ [R|t]
M_tilde = reshape(M_tilde,4, 3)';
if M_tilde(3,4) < 0
    M_tilde = -1 * M_tilde;
end

% Find the closest orthogonal matrix to R
% https://en.wikipedia.org/wiki/Orthogonal_Procrustes_problem
R = M_tilde(1:3,1:3);
[U, ~, V] = svd(R);
R_tilde = U * V';

% Normalization scheme using the Frobenius norm:
% recover the unknown scale using the fact that R_tilde is a true rotation matrix
alpha = norm(R_tilde, "fro") / norm(R, "fro");

% Build M_tilde with the corrected rotation and scale
t_tilde = alpha * M_tilde(:, width(M_tilde));
M_tilde = cat(2, R_tilde, t_tilde);
assert(ismembertol(det(R_tilde), 1, 1e-5))

end

