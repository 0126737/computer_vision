function [ training, group ] = BuildKNN( folder, C )
%BUILDKNN

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

training = zeros(num_images, size(C,2));
group = zeros(1,num_images);
index = 1;

for j=1:num_categories
    files = dir([folder,img_folders(j).name,'/*.jpg']);

    % iterate through image folder
    for i=1:length(files)
        img = im2double(imread([folder, img_folders(j).name, '/', files(i).name]));
        % extract features
        [~,D] = vl_dsift(single(img),'Fast','Step', 1);
        % build historgram
        n = histc(knnsearch(C',double(D)'),1:size(C,2));
        % normalize historgram
        n = n / sum(n);
        training(index,:) = n';
        group(index) = j;
        index = index + 1;
    end
    disp(['    Finished processing: ', img_folders(j).name, ' ID = ', num2str(j)]);
end

end

