function [ homography, idx ] = ransac( points1, points2, N, threshold )
%RANSAC RANdom SAmple Consensus
%   points1 and points2 are the corresponding matching points.
%   point1(1) matches to point2(1)
%   N is the number of iterations
%   thrshold is the threshold for inliers
%
%   Returns:
%   homography - The homography constructed from the inliers of the run
%                with the most inliers.
%   idx        - The index of the inliers found

max_inliers = 0;
max_inliers_idx = zeros(1, size(points1,1));

i = 1;

while i <= N
    % Choose 4 random matches
    rnd_points_idx = randsample(1:size(points1,1), 4);
    pointsA = points1(rnd_points_idx,:);
    pointsB = points2(rnd_points_idx,:);

    % Estimate homography
    % If cp2tform fails, just try again
    try
        t = cp2tform(pointsA, pointsB, 'projective');
    catch ME
        continue
    end

    % Transform all other points
    transformed_points = tformfwd(t, points1);

    distance = sqrt(sum((transformed_points - points2).^2,2));
    inliers = distance < threshold;
    num_inliers = sum(inliers);

    if num_inliers > max_inliers
        % Save inliers
        max_inliers = num_inliers;
        max_inliers_idx = inliers;
    end
    i = i + 1;
end

% Step 4 - Estimate homography with found inliers

% get indices of inliers
idx = 1:size(points1,1);
idx = idx .* max_inliers_idx';
% remove zeros
idx(idx==0) = [];

% estimate homography with inliers
homography = cp2tform(points1(idx,:), points2(idx,:), 'projective');

end

