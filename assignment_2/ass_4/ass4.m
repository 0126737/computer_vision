% Assignment 4
%
% Q: Warnings when executing cp2tform?
% Q: Ignore all errors when executing cp2tform?
% Q: What about XYScale?
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
H{1}.tdata.Tinv = H{2}.tdata.Tinv * H{1}.tdata.Tinv;
H{4}.tdata.T = H{3}.tdata.T * H{4}.tdata.T;
H{4}.tdata.Tinv = H{3}.tdata.Tinv * H{4}.tdata.Tinv;

temp = H{3}.tdata.Tinv;
H{3}.tdata.Tinv = H{3}.tdata.T;
H{3}.tdata.T = temp;

temp = H{4}.tdata.Tinv;
H{4}.tdata.Tinv = H{4}.tdata.T;
H{4}.tdata.T = temp;

% Step 3 - Determine size of panorama image
corners = zeros(4,2,size(imgs,4)-1);

for i = 1:2
    corners(:,:,i) = tformfwd(H{i}, [1, 1; ...
                    1, size(imgs(:,:,:,i),1); ...
                    size(imgs(:,:,:,i),2), 1; ...
                    size(imgs(:,:,:,i),2), size(imgs(:,:,:,i),1)]);
end

for i = 3:4
    corners(:,:,i) = tformfwd(H{i}, [1, 1; ...
                    1, size(imgs(:,:,:,i+1),1); ...
                    size(imgs(:,:,:,i+1),2), 1; ...
                    size(imgs(:,:,:,i+1),2), size(imgs(:,:,:,i+1),1)]);
end

max_xy = max(reshape(max(corners),2,4)');
min_xy = min(reshape(min(corners),2,4)');

xdata = [min_xy(1) max_xy(1)];
ydata = [min_xy(2) max_xy(2)];

timg1 = imtransform(imgs(:,:,:,1), H{1}, 'XData', xdata, 'YData', ydata);
timg2 = imtransform(imgs(:,:,:,2), H{2}, 'XData', xdata, 'YData', ydata);
timg_ref = imtransform(imgs(:,:,:,3), maketform('projective',eye(3)), 'XData', xdata, 'YData', ydata);
timg3 = imtransform(imgs(:,:,:,4), H{3}, 'XData', xdata, 'YData', ydata);
timg4 = imtransform(imgs(:,:,:,5), H{4}, 'XData', xdata, 'YData', ydata);

canvas = max(timg1, timg2);
canvas = max(canvas, timg_ref);
canvas = max(canvas, timg3);
canvas = max(canvas, timg4);
figure;
imshow(canvas);

canvas2 = timg1 + timg2 + timg_ref + timg3 + timg4;
figure;
imshow(canvas2);

% Feathering
h = size(img(:,:,:,1),1);
w = size(img(:,:,:,1),2);
temp = zeros(h,w);
temp(:,1) = 1;
temp(:,w) = 1;
bw = bwdist(temp);
bw = bw / max(max(bw));

tbw1 = imtransform(bw, H{1}, 'XData', xdata, 'YData', ydata);
tbw2 = imtransform(bw, H{2}, 'XData', xdata, 'YData', ydata);

t1 = rgb2gray(timg1)~=0;
t2 = rgb2gray(timg2)~=0;

map = t1+t2;
map = map==2;

canvas = timg1+timg2;

R1 = timg1(:,:,1);
R2 = timg2(:,:,1);
R = canvas(:,:,1);
R(map) = R1(map) .* tbw1(map) + R2(map) .* tbw2(map) ./ (tbw1(map) + tbw2(map));

G1 = timg1(:,:,2);
G2 = timg2(:,:,2);
G = canvas(:,:,2);
G(map) = G1(map) .* tbw1(map)+ G2(map) .* tbw2(map) ./ (tbw1(map) + tbw2(map));

B1 = timg1(:,:,3);
B2 = timg2(:,:,3);
B = canvas(:,:,3);
B(map) = B1(map) .* tbw1(map) + B2(map) .* tbw2(map) ./ (tbw1(map) + tbw2(map));

imshow(cat(3, R,G,B));

figure;
imshow(tbw1.*map);

figure;
imshow(canvas);
figure;
imshow(map);

