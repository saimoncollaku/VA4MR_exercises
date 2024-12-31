function I = warpImage(I_R, W)

I = zeros(size(I_R));

for idx = 1 : numel(I_R)
    % Obtaining original coordinates
    [y, x] = ind2sub(size(I_R), idx);
    orig_coord = [x, y, 1];

    % Warping and feasibility check
    warped_coord = floor(W * orig_coord');

    if warped_coord(1) < 1 || warped_coord(2) < 1
        continue;
    end

    if warped_coord(1) > width(I_R) || warped_coord(2) > height(I_R)
        continue;
    end

    I(y, x) = I_R(warped_coord(2), warped_coord(1));
end


% I = zeros(size(I_R));
%
% % Somehow pre-calculating this resulted in major speedup.
% max_coords = fliplr(size(I_R));
%
% % Careful with indexing!
% for x = 1:size(I_R, 2)
%     for y = 1:size(I_R, 1)
%         warped = (W * [x y 1]')';
%         if all(warped < max_coords & warped > [1 1])
%             I(y, x) = I_R(int32(warped(2)), int32(warped(1)));
%         end
%     end
% end


end

