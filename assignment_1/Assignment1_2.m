clear

% Computer Vision Assignment 1.2

% Q: which values of K for first part?
% Q: Does the 5D version look right?

% Image names
str_img = {'simple.PNG','future.jpg','mm.jpg'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show 3D and 5D k-means for all 3 images and fixed k
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = 3;
for i=1:size(str_img,2)
    img = imread(char(str_img(i)));
    figure('Name',char(str_img(i)),'NumberTitle','off');
    subplot(1, 2, 1);
    imshow(k_means_3D(img,K));
    subplot(1, 2, 2);
    imshow(k_means_5D(img,K));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show 3D and 5D k-means for mm.jpg and various values for k
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = imread('mm.jpg');
K = [5,10,15,20];
for i = K
    figure('Name','mm.jpg','NumberTitle','off');
    subplot(1, 2, 1);
    imshow(k_means_3D(img,i));
    subplot(1, 2, 2);
    imshow(k_means_5D(img,i));
end