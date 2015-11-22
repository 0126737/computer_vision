function [ k_colored_image ] = k_means_3D( img, K, centroids )
    data = double(reshape(img,size(img,1)*size(img,2),3));
    if nargin < 3
        temp_img = k_means(data, K);
    else
        temp_img = k_means(data, K, centroids);
    end
    
    % visual representation
    
    k_colored_image = uint8(reshape(temp_img, size(img,1), size(img,2), 3));
    
end

