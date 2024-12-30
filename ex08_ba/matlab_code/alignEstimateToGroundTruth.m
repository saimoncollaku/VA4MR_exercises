function p_G_C = alignEstimateToGroundTruth(...
    pp_G_C, p_V_C)
% Returns the points of the estimated trajectory p_V_C transformed into the
% ground truth frame G. The similarity transform Sim_G_V is to be chosen
% such that it results in the lowest error between the aligned trajectory
% points p_G_C and the points of the ground truth trajectory pp_G_C. All
% matrices are 3xN.

% Init
homo_init = eye(4);
initial_guess = [HomogMatrix2twist(homo_init); 1];
options = optimoptions('lsqnonlin', 'TolFun', 1e-12, 'MaxIterations', 1000);
error_function = @(x) alignmentError(x, pp_G_C, p_V_C); 

% Result
twist_model = lsqnonlin(error_function, initial_guess, [], [], options);
homo_model = twist2HomogMatrix(twist_model);
R_model = homo_model(1:3, 1:3);
t_model = homo_model(1:3, 4);
s_model = twist_model(length(twist_model));
p_G_C = s_model * R_model * p_V_C + t_model;

end
