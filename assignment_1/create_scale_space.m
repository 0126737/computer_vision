function [ scale_space ] = create_scale_space( img, k, scale, levels )

scale_space = zeros(size(img,1),size(img,2),levels);

for i=1:levels
    sigma = scale * k^(i-1);
    % Create the kernel
    h = fspecial('log',2*floor(3*sigma)+1,sigma) * sigma^2;
    % apply the kernel
    % same: The output is the same size as the image
    % replicate: pixels outside the borders are replicated (set to the
    % value of the nearest border pixel)
    scale_space(:,:,i) = abs(imfilter(img, h, 'same', 'replicate'));
end

end

