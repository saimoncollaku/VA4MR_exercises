function scores = harris(img, patch_size, kappa)

% TODO: Your code here
f_sum = (patch_size ^ 2) * fspecial("average",[patch_size, patch_size]);
I_x = conv2(img, fspecial("sobel")', 'valid');
I_y = conv2(img, fspecial("sobel"), 'valid'); 

I_x2 = I_x.^2;
I_y2 = I_y.^2;
I_xy = I_x .* I_y;

E_x2 = conv2(I_x2, f_sum, "valid");
E_y2 = conv2(I_y2, f_sum, "valid");
E_xy = conv2(I_xy, f_sum, "valid");

lambda_1 = 0.5 .* (E_x2 + E_y2 + sqrt(4 .* E_xy .* E_xy + (E_x2 - E_y2).^2));
lambda_2 = 0.5 .* (E_x2 + E_y2 - sqrt(4 .* E_xy .* E_xy + (E_x2 - E_y2).^2));

R = lambda_1 .* lambda_2 - kappa * (lambda_1 + lambda_2).^2;
R = max(R, 0);
scores = padarray(R, ones(2,1) * floor(patch_size / 2), 0);


end
