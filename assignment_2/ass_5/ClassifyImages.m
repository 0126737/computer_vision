function [ conf_matrix ] = ClassifyImages( folder,C,training,group )
%CLASSIFYIMAGES

if folder(size(folder,2)) ~= '/'
    folder = strcat(folder,'/');
end

img_folders = dir(folder);
img_folders = img_folders([img_folders.isdir]);
img_folders = img_folders(arrayfun(@(x) x.name(1), img_folders) ~= '.');

num_categories = length(img_folders([img_folders.isdir]));

conf_matrix = zeros(num_categories, num_categories);

for j=1:num_categories
    files = dir([folder,img_folders(j).name]);
    files = files(not([files.isdir]));

    % iterate through image folder
    for i=1:length(files)
        img = im2double(imread([folder, img_folders(j).name, '/', files(i).name]));
        % extract features
        [~,D] = vl_dsift(single(img),'Fast','Step', 1);
        % build historgram
        n = histc(knnsearch(C',double(D)'),1:size(C,2));
        % normalize historgram
        n = n / sum(n);
        g = knnclassify(n', training, group, 3);
        conf_matrix(j,g) = conf_matrix(j,g) + 1;
    end
    disp(['    Finished classifying: ', img_folders(j).name, ' ID = ', num2str(j)]);
end

end

