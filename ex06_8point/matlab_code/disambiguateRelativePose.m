function [R,T] = disambiguateRelativePose(Rots,u3,points0_h,points1_h,K1,K2)
% DISAMBIGUATERELATIVEPOSE- finds the correct relative camera pose (among
% four possible configurations) by returning the one that yields points
% lying in front of the image plane (with positive depth).
%
% Arguments:
%   Rots -  3x3x2: the two possible rotations returned by decomposeEssentialMatrix
%   u3   -  a 3x1 vector with the translation information returned by decomposeEssentialMatrix
%   p1   -  3xN homogeneous coordinates of point correspondences in image 1
%   p2   -  3xN homogeneous coordinates of point correspondences in image 2
%   K1   -  3x3 calibration matrix for camera 1
%   K2   -  3x3 calibration matrix for camera 2
%
% Returns:
%   R -  3x3 the correct rotation matrix
%   T -  3x1 the correct translation vector
%
%   where [R|t] = T_C2_C1 = T_C2_W is a transformation that maps points
%   from the world coordinate system (identical to the coordinate system of camera 1)
%   to camera 2.
%

M1 = K1 * eye(3, 4);
best = 0;

% Case 1
current_R = Rots(:, :, 1);
current_T = u3;
current_count = return_n_pts_in_front(current_R, current_T, points0_h, points1_h, M1, K2);
if  current_count > best
    R = current_R;
    T = current_T;
    best = current_count;
end

% Case 2
current_R = Rots(:, :, 1);
current_T = -u3;
current_count = return_n_pts_in_front(current_R, current_T, points0_h, points1_h, M1, K2);
if  current_count > best
    R = current_R;
    T = current_T;
    best = current_count;
end

% Case 3
current_R = Rots(:, :, 2);
current_T = u3;
current_count = return_n_pts_in_front(current_R, current_T, points0_h, points1_h, M1, K2);
if  current_count > best
    R = current_R;
    T = current_T;
    best = current_count;
end

% Case 4
current_R = Rots(:, :, 2);
current_T = -u3;
current_count = return_n_pts_in_front(current_R, current_T, points0_h, points1_h, M1, K2);
if  current_count > best
    R = current_R;
    T = current_T;
end

end

function count = return_n_pts_in_front(R, T, p1, p2, M1, K2)
M2 = K2 * cat(2, R, T);
P = linearTriangulation(p1, p2, M1, M2);
count = nnz(P(3, :) > 0);
end

