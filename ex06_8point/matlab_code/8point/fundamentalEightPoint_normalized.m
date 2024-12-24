function F = fundamentalEightPoint_normalized(p1, p2)
% estimateEssentialMatrix_normalized: estimates the essential matrix
% given matching point coordinates, and the camera calibration K
%
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%
% Output:
%  - F(3,3) : fundamental matrix
%

% Normalise px coordinates
[p1, T1] = normalise2dpts(p1);
[p2, T2] = normalise2dpts(p2);


% Build the kronecker matrix
Q = [];
for i = 1 : width(p1)
    Q_i = kron(p1(:, i), p2(:, i));
    Q = cat(1, Q, Q_i');
end

% Find F with minimized det
[~, ~, V] = svd(Q);
vec_F = V(:, width(V));
F = reshape(vec_F, [3, 3]);

% Find F with enforced det = 0
[U, S, V] = svd(F);
S(3, 3) = 0;
F = U * S * V';

% Denormalize F
F = T2' * F * T1;

end

