function [ k_colored_image ] = k_means_3D( img, K )
    data = double(reshape(img,size(img,1)*size(img,2),3));
    temp_img = k_means(data, K);
    % visual representation
    k_colored_image = uint8(reshape(temp_img, size(img,1), size(img,2), 3));
end

