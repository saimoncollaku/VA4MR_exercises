% function p_reproj = reprojectPoints(P, M_tilde, K)
% % Reproject 3D points given a projection matrix
% %
% % P: [nx3] coordinates of the 3d points in the world frame
% % M_tilde: [3x4] projection matrix
% % K: [3x3] camera matrix
% %
% % p_reproj: [nx2] coordinates of the reprojected 2d points
% 
% p_homo = (K*M_tilde*[P';ones(1,length(P))])';
% p_homo(:,1) = p_homo(:,1) ./ p_homo(:,3);
% p_homo(:,2) = p_homo(:,2) ./ p_homo(:,3);
% 
% p_reproj = p_homo(:,1:2);
% end
% 

function p = reprojectPoints(P, M, K)
    % P nx3
    % p nx2

    n = size(P,1);
    p = [];
    for i=1:n
        Pi = P(i, :);
        pi = K*M*[Pi 1]' ;
        pi = pi/pi(3);
        pi = pi(1:2);

        p = [p;
             pi'];
    end
end
