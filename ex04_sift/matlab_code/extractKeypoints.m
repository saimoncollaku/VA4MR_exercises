function kpt_locations = extractKeypoints(DoGs, contrast_threshold)



num_octaves = width(DoGs);
kpt_locations = cell(1, num_octaves);

for o = 1 : num_octaves
    volume = [];
    for i = 1 : height(DoGs)
        volume = cat(3, volume, DoGs{i, o});
    end

    % Noise suppression
    volume(volume < contrast_threshold) = 0;

    % Non-maxima suppression
    se = strel('square', 3);
    kpt = imdilate(volume, se, 'same');
    kpt(kpt ~= volume) = 0;

    kpt(:, :, 1) = [];
    kpt(:, :, size(kpt, 3)) = [];
    kpt_locations(o) = {kpt};
end


% for w = 1 : width(DoGs)
%     for h = 2 : height(DoGs) - 1
%         dog1 = DoGs{h - 1, w};
%         dog2 = DoGs{h, w};
%         dog3 = DoGs{h + 1, w};
%         scale = cat(3, dog1, dog2, dog3);
% 
%         % Noise suppression
%         scale(scale < contrast_threshold) = 0;
% 
%         % Non-maxima suppression
%         se = strel('square', 3);
%         kpt = imdilate(scale, se, 'same');
%         kpt(kpt ~= scale) = 0;
%         kpt_locations(h - 1, w) = {kpt};
%     end
% end




end
