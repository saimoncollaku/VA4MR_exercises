function error = errorBA(hidden_state, observations, K)

% Manipulating hidden state to obtain twist, 3D points and m/n
n = observations(1);

observations(1:2) = [];
twist = hidden_state(1 : 6 * n);
hidden_state(1 : 6 * n) = [];

% Optimization data
twist = reshape(twist, 6, []);
world_pts = reshape(hidden_state, 3, []);
error = [];

for k = 1 : n
    % Manipulating k-frame data
    n_landmarks = observations(1);
    observations(1) = [];
    px_landmarks = observations(1 : 2 * n_landmarks)';
    px_landmarks = reshape(px_landmarks, 2, []);
    observations(1 : 2 * n_landmarks) = [];
    id_landmarks = observations(1 : n_landmarks)';
    observations(1 : n_landmarks) = [];
    px_landmarks = flipud(px_landmarks);

    % Obtaining R, t for k-frame
    homo = twist2HomogMatrix(twist(:, k)) ^ -1;
    R = homo(1:3, 1:3);
    t = homo(1:3, 4);

    % Obtaining available landmarks - f(x)
    P_w = world_pts(:, id_landmarks);
    P_c = R * P_w + t;
    p_reproj = projectPoints(P_c, K);
    p_reproj(3, :) = [];

    % Error
    error = [error, px_landmarks - p_reproj];
end