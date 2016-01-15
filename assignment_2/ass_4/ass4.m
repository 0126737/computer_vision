% Assignment 4
%
% Q: Absolute difference between 2 images?
% Q: Warnings when executing cp2tform?
% Q: Ignore all errors when executing cp2tform?
% Q: panorma image without blending (black borders)? - average?
%

clear
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A. SIFT Interest Point Detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = im2double(imread('campus1.jpg'));
gray_img = single(rgb2gray(img));
frame = vl_sift(gray_img);

figure;
h = imshow(img); 
vl_plotframe(frame);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B. Interest Point Matching and Image Registration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
trans_img = imtransform(img1, homography, ...
                        'XData', [1 size(img2,2)], ...
                        'YData', [1 size(img2,1)], ...
                        'XYScale', [1 1]);

figure;
subplot(1,2,1);
imshow(trans_img);
subplot(1,2,2);
imshow(img2);

% Show absolute difference
diff_img = imabsdiff(trans_img,img2);
figure;
imshow(diff_img);

%%
% Repeat B with img2 scaled and rotated
img2 = imresize(img2,2);
img2 = imrotate(img2,30);
gray_img2 = single(rgb2gray(img2));

% Step 1+2 - SIFT keypoints and Matching
[points_a, points_b] = matching(gray_img1, gray_img2);
match_plot(img1,img2,points_a,points_b);

% Step 3+4 - RANSAC
[homography, idx] = ransac(points_a,points_b, 1000, 5);

% Step 5 - transform first image to the second image (Image Registration)
trans_img = imtransform(img1, homography, ...
                        'XData', [1 size(img2,2)], ...
                        'YData', [1 size(img2,1)], ...
                        'XYScale', [1 1]); 
figure;
subplot(1,2,1);
imshow(trans_img);
subplot(1,2,2);
imshow(img2);

% Show absolute difference
diff_img = imabsdiff(trans_img,img2);
figure;
imshow(diff_img);                    

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% C. Image Stitching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgs = cat(4, im2double(imread('campus1.jpg')), ...
              im2double(imread('campus2.jpg')), ...
              im2double(imread('campus3.jpg')), ...
              im2double(imread('campus4.jpg')), ...
              im2double(imread('campus5.jpg')));

[timg, H, xdata, ydata] = create_panorama(imgs);

% Show first image set without feathering
map = create_overlap_map(timg);

% Show panorama image without blending
canvas = zeros(size(timg{1}));
for i = 1:size(timg,2)
   if bitget(i,1) % odd
       canvas = canvas + timg{i};
   else % even
       canvas(not(map)) = canvas(not(map)) + timg{i}(not(map));
   end
end
figure;
imshow(canvas);

% Show panorama image (max of image colors)
canvas = zeros(size(timg{1}));
for i = 1:size(timg,2)
   canvas = max(canvas, timg{i}); 
end
figure;
imshow(canvas);

% Show image with feathering
canvas = feathering(imgs, timg, H, xdata, ydata);
figure;
imshow(canvas);

% Show second provided image set and 2 image sets made by us
for i=1:3
    if i==1
        imgs = cat(4, im2double(imread('officeview1.jpg')), ...
              im2double(imread('officeview2.jpg')), ...
              im2double(imread('officeview3.jpg')), ...
              im2double(imread('officeview4.jpg')), ...
              im2double(imread('officeview5.jpg')));
    elseif i==2
        imgs = cat(4, im2double(imread('karls1.jpg')), ...
              im2double(imread('karls2.jpg')), ...
              im2double(imread('karls3.jpg')), ...
              im2double(imread('karls4.jpg')), ...
              im2double(imread('karls5.jpg')));
    elseif i==3
        imgs = cat(4, im2double(imread('karlsplatz1.jpg')), ...
              im2double(imread('karlsplatz2.jpg')), ...
              im2double(imread('karlsplatz3.jpg')), ...
              im2double(imread('karlsplatz4.jpg')), ...
              im2double(imread('karlsplatz5.jpg')));          
    end
    
    [timg, H, xdata, ydata] = create_panorama(imgs);
    canvas = feathering(imgs, timg, H, xdata, ydata);
    figure;
    imshow(canvas);
end
