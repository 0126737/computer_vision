clear

min_ratio = 1.5;
K = 10;

%segment_img = imread('simple.PNG');
segment_img = imread('future.jpg');

% reshape image to RGB datapoints
rgb_data = double(reshape(segment_img,size(segment_img,1)*size(segment_img,2),3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. choose centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: Select centroids random + distance (k-means++ algorithm -- Arthur
% and Vassilvitskii, 2007)

% choose first point randomly (random point of rgb_data)
c1 = rgb_data(round(rand * (size(rgb_data,1)-1)+1),:);
% compute euclidean distance to first point
[max_ind,max_ind] =max(sum(bsxfun(@minus,rgb_data,c1).^2,2));
c2 = rgb_data(max_ind,:);

% compute mean of first two points
mid = (c1+c2)/2;
% compute euclidean distance to mean of first and second point
[max_ind,max_ind] =max(sum(bsxfun(@minus,rgb_data,mid).^2,2));
c3 = rgb_data(max_ind,:);

centroids = [c1; c2; c3];

% Choose random centroids
%centroids = round(rand(K,3) .* 255);

ratio = min_ratio + 1;
while ratio > min_ratio

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Assign all data points to their nearest cluster centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % compute squared euclidean distances
    euclidean_dists = zeros(size(rgb_data,1),K);
    for i=1:K
        euclidean_dists(:,i) = sum(bsxfun(@minus,rgb_data,centroids(i,:)).^2,2);
    end

    % generate nearest distance matrix
    r_n_k = bsxfun(@eq,euclidean_dists, min(euclidean_dists.')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute J
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    J = 0;
    for i=1:K
        J = J + sum(sum(bsxfun(@minus,rgb_data,centroids(i,:)).^2,2) .* r_n_k(:,i));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Compute new centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:K
        centroids(i,:) = sum(bsxfun(@times,r_n_k(:,i),rgb_data)) / sum(r_n_k(:,i));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Compute J_new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    J_new = 0;
    for i=1:K
        J_new = J_new + sum(sum(bsxfun(@minus,rgb_data,centroids(i,:)).^2,2) .* r_n_k(:,i));
    end

    if J+J_new==0
       ratio = 0;
    else
        ratio = J/J_new;
    end

end

% Color image with mean color value
temp_img = zeros(size(rgb_data,1),3);
for i=1:K
    temp_img(find(r_n_k(:,i)==1),1:3) = repmat(centroids(i,1:3),size(find(r_n_k(:,i)==1),1),1);
end

% visual representation
k_colored_image = reshape(temp_img, size(segment_img,1), size(segment_img,2), 3);
imshow(uint8(k_colored_image));
