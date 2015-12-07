% Assignment 4
%
% Q: Warnings when executing cp2tform?
% Q: Ignore all errors when executing cp2tform?
% Q: Image Registration - should that be that way? What about XYScale?
%
% TODO: Repeat B with img2 scaled and rotated

clear
% A. SIFT Interest Point Detection
img = im2double(imread('campus1.jpg'));
gray_img = single(rgb2gray(img));
frame = vl_sift(gray_img);

figure;
h = imshow(img); 
vl_plotframe(frame);

% B. Interest Point Matching and Image Registration
img1 = im2double(imread('campus1.jpg'));
gray_img1 = single(rgb2gray(img1));
img2 = im2double(imread('campus2.jpg'));
gray_img2 = single(rgb2gray(img2));

% Step 1+2 - SIFT keypoints and Matching
[points_a, points_b] = matching(gray_img1, gray_img2);
match_plot(img1,img2,points_a,points_b);

% Step 3+4 - RANSAC
[homography, idx] = ransac(points_a,points_b, 1000, 5);

% plot matches of inliers
match_plot(img1,img2,points_a(idx,:), points_b(idx,:));

% Step 5 - transform first image to the second image (Image Registration)
timg = imtransform(img1, homography, 'XData', [1 size(img2,2)], 'YData', [1 size(img2,1)], 'XYScale', [1 1]);

% C. Image Stitching

imgs = cat(4, im2double(imread('campus1.jpg')), ...
              im2double(imread('campus2.jpg')), ...
              im2double(imread('campus3.jpg')), ...
              im2double(imread('campus4.jpg')), ...
              im2double(imread('campus5.jpg')));

% Step 1 - Create homographies
H = cell(1,size(imgs,4)-1);
for i = 1:size(imgs,4)-1
    [points_a, points_b] = matching(single(rgb2gray(imgs(:,:,:,i))), single(rgb2gray(imgs(:,:,:,i+1))));
    H{1,i} = ransac(points_a,points_b, 1000, 5);
end

% Step 2 - Choose reference image
%ref_img = round(size(imgs,4)/2);
H{1}.tdata.T = H{2}.tdata.T * H{1}.tdata.T;
H{4}.tdata.T = H{3}.tdata.T * H{4}.tdata.T;

[X1, xdata1, ydata1] = imtransform(imgs(:,:,:,1), H{1});
[X2, xdata2, ydata2] = imtransform(imgs(:,:,:,2), H{2});
[X3, xdata3, ydata3] = imtransform(imgs(:,:,:,4), H{3});
[X4, xdata4, ydata4] = imtransform(imgs(:,:,:,5), H{4});


figure;
imshow(X1);
figure;
imshow(X2);
figure;
imshow(imgs(:,:,:,3));
figure;
imshow(X3);
figure;
imshow(X4);






