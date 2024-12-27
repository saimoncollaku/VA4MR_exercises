function [best_guess_history, max_num_inliers_history] = ...
    parabolaRansac(data, max_noise)
% data is 2xN with the data points given column-wise, 
% best_guess_history is 3xnum_iterations with the polynome coefficients 
%   from polyfit of the BEST GUESS SO FAR at each iteration columnwise and
% max_num_inliers_history is 1xnum_iterations, with the inlier count of the
%   BEST GUESS SO FAR at each iteration.

max_k = 100;
best_guess = zeros(3, 1);
best_inliers = -1;
best_guess_history = [];
max_num_inliers_history = [];


for k = 1 : max_k
    % Sampling 
    sample = datasample(data, 3, 2, "Replace", false);
    m_k = polyfit(sample(1, :), sample(2, :), 2);

    % Counting inliers
    error = abs(data(2, :) - polyval(m_k, data(1, :)));
    n_inliers = nnz(error <= max_noise);

    % Compare to best sample so far
    if n_inliers > best_inliers
        best_inliers = n_inliers;
        best_guess = m_k;
    end
    
    % Save history
    best_guess_history = cat(2, best_guess_history, best_guess');
    max_num_inliers_history = cat(2, max_num_inliers_history, best_inliers);
end





end

