function P = linearTriangulation(p1,p2,M1,M2)
% LINEARTRIANGULATION  Linear Triangulation
%
% Input:
%  - p1(3,N): homogeneous coordinates of points in image 1
%  - p2(3,N): homogeneous coordinates of points in image 2
%  - M1(3,4): projection matrix corresponding to first image
%  - M2(3,4): projection matrix corresponding to second image
%
% Output:
%  - P(4,N): homogeneous coordinates of 3-D points

P = [];

for i = 1 : width(p1)
    p_1x_i = skewMatrix(p1(:, i));
    p_2x_i = skewMatrix(p2(:, i));

    A = cat(1, p_1x_i * M1, p_2x_i * M2);
    [~, ~, V] = svd(A);

    P_i = V(:, width(V));
    P_i = P_i / P_i(length(P_i));
    P = cat(2, P, P_i);
end

end


function X = skewMatrix(x)
X = [0 -x(3) x(2) ; x(3) 0 -x(1) ; -x(2) x(1) 0 ];
end


