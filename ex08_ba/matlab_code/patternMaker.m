function M = patternMaker(hidden_state, observations)
n_frames = observations(1);
observations(1:2) = [];
n_errors = (length(observations) - n_frames) * 2 / 3;
M = spalloc(n_errors, length(hidden_state), n_errors * 9);

obs_idx = 1;
err_idx = 1;

for k = 1 : n_frames
    % Indexing poses
    n_landmarks = observations(obs_idx);
    errors_affected = err_idx : (err_idx - 1) + 2 * n_landmarks;
    affecting_pose = 6 * (k-1) + 1 : 6 * k;
    M(errors_affected, affecting_pose) = 1;

    % Indexing world points
    ids = observations(obs_idx + n_landmarks * 2 + 1 : obs_idx + n_landmarks * 3);
    for i = 1:numel(ids)
        errors_affected = err_idx + (i-1) * 2 : err_idx + i*2 - 1;
        affecting_points = 1 + n_frames*6 + (ids(i)-1)*3 : n_frames*6 + ids(i)*3;
        M(errors_affected, affecting_points) = 1;
    end

    % Updating idx
    err_idx = err_idx + 2 * n_landmarks;
    obs_idx = obs_idx + 3 * n_landmarks + 1;
end


end