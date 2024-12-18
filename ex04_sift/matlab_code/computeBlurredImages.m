function blurred_images = computeBlurredImages(image_pyramid, num_scales, sigma)
% Infer number of octaves from length of image pyramid

num_octaves = length(image_pyramid);

blurred_images = cell(num_scales + 2, num_octaves);
for o = 1 : num_octaves
    for s = 1 : num_scales + 2
        blur_sigma = 2 ^ ((s-1) / num_scales) * sigma;
        blurred_images(s, o) = {imgaussfilt(image_pyramid{o}, blur_sigma)};
    end
end

end
