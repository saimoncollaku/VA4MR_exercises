function [pts_tilda, T] = normalise2dpts(pts)
% NORMALISE2DPTS - normalises 2D homogeneous points
%
% Function translates and normalises a set of 2D homogeneous points
% so that their centroid is at the origin and their mean distance from
% the origin is sqrt(2).
%
% Usage:   [pts_tilda, T] = normalise2dpts(pts)
%
% Argument:
%   pts -  3xN array of 2D homogeneous coordinates
%
% Returns:
%   pts_tilda -  3xN array of transformed 2D homogeneous coordinates.
%   T      -  The 3x3 transformation matrix, pts_tilda = T*pts
%

pts = pts ./ pts(3, :);
N = width(pts);
mu = sum(pts, 2) / N;
sigma = sum(vecnorm(pts - mu, 2)) / N;
s = sqrt(2) / sigma;

T = [s, 0, - s * mu(1);
     0, s, - s * mu(2);
     0, 0, 1];

pts_tilda = [];

for i = 1 : width(pts)
    pts_t_i = T * pts(:, i);
    pts_tilda = cat(2, pts_tilda, pts_t_i);
end
