function [ conf ] = ClassifyOwnImages( folder, C, training, group )
%CLASSIFYOWNIMAGES Summary of this function goes here
%   Detailed explanation goes here

if folder(size(folder,2)) ~= '/'
    folder = strcat(folder,'/');
end

files = dir([folder,'*.jpg']);

conf = zeros(1, 8);
% iterate through image folder
for i=1:length(files)
    img = rgb2gray(im2double(imread([folder, files(i).name])));
    % extract features
    [~,D] = vl_dsift(single(img),'Fast','Step', 1);
    % build historgram
    n = histc(knnsearch(C',double(D)'),1:size(C,2));
    % normalize historgram
    n = n / sum(n);
    g = knnclassify(n', training, group, 3);
    conf(1,g) = conf(1,g) + 1;
end

end

