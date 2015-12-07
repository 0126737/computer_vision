function [ points_a, points_b ] = matching( img1, img2 )
%MATCHING Summary of this function goes here
%   Detailed explanation goes here

% Get SIFT keypoints
[F1, D1] = vl_sift(img1);
[F2, D2] = vl_sift(img2);

% Matching
matches = vl_ubcmatch(D1, D2);
points_a = F1(1:2, matches(1,:))';
points_b = F2(1:2, matches(2,:))';

end

