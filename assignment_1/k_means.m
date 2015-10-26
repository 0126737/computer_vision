function [ k_data, centroids ] = k_means( data, K )
%K_MEANS Summary of this function goes here
%   Detailed explanation goes here

% WARNING K must not be bigger than the number of colors in the image
% If K is bigger, the algorithm will not terminate!

min_ratio = 1.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. choose centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: Select centroids random + distance (k-means++ algorithm -- Arthur
% and Vassilvitskii, 2007)

% Choose k centroids randomly, if a centroid is the same as a chosen one,
% choose another centroid.
centroids = zeros(K,size(data,2));
% choose first point randomly
centroids(1,:) = data(round(rand * (size(data,1)-1)+1),:);
i=2;
while i <= K
    centroids(i,:) = data(round(rand * (size(data,1)-1)+1),:);
    if( max(sum(bsxfun(@eq,centroids(1:i-1,:),centroids(i,:)),2)) < size(data,2) )
        i = i + 1;
    end
end

ratio = min_ratio + 1;
while ratio > min_ratio

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Assign all data points to their nearest cluster centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % compute squared euclidean distances
    euclidean_dists = zeros(size(data,1),K);
    for i=1:K
        euclidean_dists(:,i) = sum(bsxfun(@minus,data,centroids(i,:)).^2,2);
    end

    % generate nearest distance matrix
    r_n_k = bsxfun(@eq,euclidean_dists, min(euclidean_dists.')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute J
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    J = 0;
    for i=1:K
        J = J + sum(sum(bsxfun(@minus,data,centroids(i,:)).^2,2) .* r_n_k(:,i));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Compute new centroids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:K
        centroids(i,:) = sum(bsxfun(@times,r_n_k(:,i),data)) / sum(r_n_k(:,i));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Compute J_new
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    J_new = 0;
    for i=1:K
        J_new = J_new + sum(sum(bsxfun(@minus,data,centroids(i,:)).^2,2) .* r_n_k(:,i));
    end

    if J+J_new==0
       ratio = 0;
    else
        ratio = J/J_new;
    end

end

% Color image with mean color value
k_data = zeros(size(data,1),3);
for i=1:K
    k_data(find(r_n_k(:,i)==1),1:3) = repmat(centroids(i,1:3),size(find(r_n_k(:,i)==1),1),1);
end

end

