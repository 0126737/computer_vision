clear

K = 3;

segment_img = imread('simple.PNG');
%segment_img = imread('future.jpg');

% reshape image to RGB datapoints
rgb_data = double(reshape(segment_img,size(segment_img,1)*size(segment_img,2),3));

% Add coordinates
% Tony's Trick
temp = (1:size(segment_img,1))';
cc=temp(:,ones(size(segment_img,2),1));
y = cc(:);
% Normalize the y coordinate
y = y ./ size(segment_img,1);

temp = (1:size(segment_img,2));
cc=temp(ones(size(segment_img,1),1),:);
x = cc(:);
% Normalize the x coordinate
x = x ./ size(segment_img,2);

% Normalize the colors
rgb_data = rgb_data ./ 255;

rgb_data = [rgb_data, x, y];

temp_img = k_means(rgb_data, K);

% visual representation
k_colored_image = reshape(temp_img, size(segment_img,1), size(segment_img,2), 3);

% Denormalize colors
k_colored_image = k_colored_image .* 255;

imshow(uint8(k_colored_image));
