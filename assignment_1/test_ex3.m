img = imread('butterfly.jpg');

levels = 10;
scale = 2;
k = 1.25;

scale_space = zeros(size(img,1),size(img,2),levels);

for i=1:10
    h = fspecial('log',2*floor(3*scale)+1,scale) * scale^2;
    scale_space(:,:,i) = imfilter(img, h, 'same', 'replicate');
    scale = scale * k;
end
