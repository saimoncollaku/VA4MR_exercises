function DoGs = computeDoGs(blurred_images)
  % Infer the number of octaves from the length of blurred_image
num_octaves = width(blurred_images);
num_scales_p2 = height(blurred_images);
DoGs = cell(num_scales_p2 - 1, num_octaves);


for o = 1 : num_octaves
    for s = 2 : num_scales_p2
        DoGs(s - 1, o) = {blurred_images{s, o} - blurred_images{s - 1, o}};
    end
end

end
