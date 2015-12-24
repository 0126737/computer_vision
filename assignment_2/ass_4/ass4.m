% Assignment 4
%
% Q: Warnings when executing cp2tform?
% Q: Ignore all errors when executing cp2tform?
% Q: panorma image without blending (black borders)?
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

figure;
imshow(timg);

% C. Image Stitching
imgs = cat(4, im2double(imread('campus1.jpg')), ...
              im2double(imread('campus2.jpg')), ...
              im2double(imread('campus3.jpg')), ...
              im2double(imread('campus4.jpg')), ...
              im2double(imread('campus5.jpg')));

ref_img = round(size(imgs,4)/2);
num_imgs = size(imgs,4);
          
% Step 1 - Create homographies
H = cell(1,num_imgs);
for i = 1:ref_img-1
    [points_a, points_b] = matching(single(rgb2gray(imgs(:,:,:,i))), single(rgb2gray(imgs(:,:,:,i+1))));
    H{1,i} = ransac(points_a,points_b, 1000, 5);
end
H{1,ref_img} = maketform('projective',eye(3));
for i = ref_img+1:num_imgs
    [points_a, points_b] = matching(single(rgb2gray(imgs(:,:,:,i-1))), single(rgb2gray(imgs(:,:,:,i))));
    H{1,i} = ransac(points_a,points_b, 1000, 5);
end

% Step 2 - Align Homographies to reference image
% Align left images
for i= ref_img-2:-1:1
    H{i}.tdata.T = H{i+1}.tdata.T * H{i}.tdata.T;
    H{i}.tdata.Tinv = H{i+1}.tdata.Tinv * H{i}.tdata.Tinv;    
end
% Align right images
for i = ref_img+2:num_imgs
    H{i}.tdata.T = H{i-1}.tdata.T * H{i}.tdata.T;
    H{i}.tdata.Tinv = H{i-1}.tdata.Tinv * H{i}.tdata.Tinv; 
end
for i = ref_img+1:num_imgs
    temp = H{i}.tdata.Tinv;
    H{i}.tdata.Tinv = H{i}.tdata.T;
    H{i}.tdata.T = temp;    
end

% Step 3 - Determine size of panorama image
corners = zeros(4*num_imgs,2);
for i = 1:num_imgs
    corners((i-1)*4+1:i*4,:) = tformfwd(H{i}, [1, 1; ...
        1, size(imgs(:,:,:,i),1); ...
        size(imgs(:,:,:,i),2), 1; ...
        size(imgs(:,:,:,i),2), size(imgs(:,:,:,i),1)]);
end
xdata = [min(corners(:,1)) max(corners(:,1))];
ydata = [min(corners(:,2)) max(corners(:,2))];

% Step 4 - Transform images
timg = cell(1,num_imgs);
for i=1:num_imgs
   timg{i} = imtransform(imgs(:,:,:,i), H{i}, 'XData', xdata, 'YData', ydata);
end

% Create overlap map
map = zeros(size(timg{1},1),size(timg{1},2));
for i=1:num_imgs
    map = map + (rgb2gray(timg{i})~=0);
end
map = map>=2;
map = cat(3, map, map, map);

% Show panorama image without blending
canvas = zeros(size(timg{1}));
for i = 1:num_imgs
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
for i = 1:num_imgs
   canvas = max(canvas, timg{i}); 
end
figure;
imshow(canvas);

% Step 5 - Feathering
canvas = zeros(size(timg{1}));
for i = 1:num_imgs
    canvas = canvas + timg{i};
end

% Create alpha channels and transform to plane
Alpha = cell(1,num_imgs);
for i=1:num_imgs
    h = size(imgs(:,:,:,1),1);
    w = size(imgs(:,:,:,1),2);
    temp = zeros(h,w);
    temp(:,1) = 1; temp(:,w) = 1; temp(h,:) = 1; temp(1,:) = 1;
    Alpha{i} = bwdist(temp);
    Alpha{i} = Alpha{i} / max(max(Alpha{i}));
    Alpha{i} = imtransform(Alpha{i}, H{i}, 'XData', xdata, 'YData', ydata);
end

% Calculate alpha weighted sum of colors
overlap = cell(1,num_imgs);
sumlap = zeros(size(canvas));
sumcolors = zeros(size(canvas));
for i=1:num_imgs
    overlap{i} = map .* cat(3,Alpha{i},Alpha{i},Alpha{i});
    sumcolors = sumcolors + timg{i} .* overlap{i};
    sumlap = sumlap + overlap{i};
end
blended = sumcolors ./ sumlap;

% Set overlapping color values
canvas(map) = blended(map);

figure;
imshow(canvas);
