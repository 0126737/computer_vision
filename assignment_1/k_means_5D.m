function [ k_colored_image ] = k_means_5D( img, K )

    data = double(reshape(img,size(img,1)*size(img,2),3));
    
    % Add coordinates

    % Tony's Trick
    temp = (1:size(img,1))';
    cc=temp(:,ones(size(img,2),1));
    y = cc(:);
    % Normalize the y coordinate
    y = y ./ size(img,1);

    temp = (1:size(img,2));
    cc=temp(ones(size(img,1),1),:);
    x = cc(:);
    % Normalize the x coordinate
    x = x ./ size(img,2);

    % Normalize the colors
    data = data ./ 255;

    data = [data, x, y];

    temp_img = k_means(data, K);
    
    % De-normalize colors
    temp_img = temp_img .* 255;
    
    % visual representation
    k_colored_image = uint8(reshape(temp_img, size(img,1), size(img,2), 3));
end

