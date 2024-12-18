function image_pyramid = computeImagePyramid(image, num_octaves)
% TODO: Your code here


image_pyramid = cell(1, num_octaves);

for o = 1 : num_octaves
    image_pyramid(o) = {imresize(image, 1 / 2^ (o-1) )};
end


end