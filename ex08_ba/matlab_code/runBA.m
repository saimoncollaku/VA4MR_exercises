function hidden_state = runBA(hidden_state, observations, K)
% Update the hidden state, encoded as explained in the problem statement,
% with 20 bundle adjustment iterations.

options = optimoptions('lsqnonlin', 'MaxIterations', 20, 'Display', 'iter');

error_function = @(hidden_state) errorBA(hidden_state, observations, K);

hidden_state = lsqnonlin(error_function, hidden_state, [], [], options);





end

 
