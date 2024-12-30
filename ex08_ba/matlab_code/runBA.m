function hidden_state = runBA(hidden_state, observations, K)
% Update the hidden state, encoded as explained in the problem statement,
% with 20 bundle adjustment iterations.


M = patternMaker(hidden_state, observations);
options = optimoptions('lsqnonlin', 'MaxIterations', 20, 'Display', 'iter');
options.JacobPattern = M;

error_function = @(hidden_state) errorBA(hidden_state, observations, K);



hidden_state = lsqnonlin(error_function, hidden_state, [], [], options);





end

 
