function [ C ] = BuildVocabulary( folder, num_clusters )
%BUILDVOCABULARY

if folder(size(folder,2)) ~= '/'
    folder = strcat(folder,'/');
end

img_folders = dir(folder);
img_folders = img_folders([img_folders.isdir]);
img_folders = img_folders(arrayfun(@(x) x.name(1), img_folders) ~= '.');
num_categories = length(img_folders([img_folders.isdir]));
num_images = 0;

% calculate number of images
for i=1:num_categories
    D = dir([folder,img_folders(i).name,'/*.jpg']);
    num_images = num_images + length(D);
end

% create feature matrix
features = zeros(128, 100 * num_images * num_categories);

for j=1:num_categories
    files = dir([folder,img_folders(j).name,'/*.jpg']);

    % iterate through image folder
    for i=1:length(files)
        img = im2double(imread([folder, img_folders(j).name, '/', files(i).name]));
        % extract features
        [~,D] = vl_dsift(single(img),'Fast','Step', 5);
        % select 100 features at random
        features(:,((i-1)*100)+1:i*100) = D(:,randsample(size(D,2),100));
    end
end

C = vl_kmeans(features, num_clusters);

end

