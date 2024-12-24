function F = fundamentalEightPoint(p1,p2)
% fundamentalEightPoint  The 8-point algorithm for the estimation of the fundamental matrix F
%
% The eight-point algorithm for the fundamental matrix with a posteriori
% enforcement of the singularity constraint (det(F)=0).
% Does not include data normalization.
%
% Reference: "Multiple View Geometry" (Hartley & Zisserman 2000), Sect. 10.1 page 262.
%
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%
% Output:
%  - F(3,3) : fundamental matrix

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



