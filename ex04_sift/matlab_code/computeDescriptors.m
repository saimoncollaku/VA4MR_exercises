function [descriptors, final_kpt_locations] = ...
    computeDescriptors(blurred_images, kpt_locations, rot_invariant)
num_octaves = width(blurred_images);
assert(num_octaves == width(kpt_locations));

final_kpt_locations = cell(1, num_octaves);
descriptors = cell(1, num_octaves);

l_left = 7;
l_right = 8;
l_up = 7;
l_down = 8;
sigma_w = 1.5 * 16;
edges = 0 : pi / 4 : 2 * pi - pi / 4;

for o = 1 : num_octaves
    lin_idx = find(kpt_locations{o});
    [d1, d2, d3] = ind2sub(size(kpt_locations{o}), lin_idx);
    kpt_coord = [d1, d2, d3];
    num_keypoints = height(kpt_coord);

    for h = 1 : num_keypoints
        % 1
        s = kpt_coord(h, 3);
        image = blurred_images{s, o};

        % 2
        [img_n, img_dir] = imgradient(image);
        y = kpt_coord(h, 1);
        x = kpt_coord(h, 2);
        if x + l_right > width(img_n) || x - l_left < 1
            continue
        end
        if y + l_down > height(img_n) || y - l_up < 1
            continue
        end
        patch_n = img_n(y - l_up : y + l_down, x - l_left : x + l_right);
        patch_dir = img_dir(y - l_up : y + l_down, x - l_left : x + l_right);

        % 3
        weight_n = patch_n .* fspecial("gaussian", [16, 16], sigma_w);

        % 4
        descriptor = [];
        for c = 1 : 4 : width(patch_dir)
            for r = 1 : 4 : height(patch_dir)
                orient = patch_dir(r : r + 3, c : c + 3);
                orient = orient(:);
                weight = weight_n(r : r + 3, c : c + 3);
                weight = weight(:);
                histo = weightedhistc(orient, weight, edges);
                descriptor = cat(2, descriptor, histo);
            end
        end

        % 5 
        descriptor = descriptor / norm(descriptor);
        descriptors(o) = {cat(1, descriptors{o}, descriptor)};
        final_kpt_locations(o) = {cat(1, final_kpt_locations{o}, kpt_coord(h, :))};
    end
end

end
