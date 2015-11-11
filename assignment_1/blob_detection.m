function [] = blob_detection( orig, k, scale, levels, threshold )
    % If image is RGB, convert to grayscale
    if size(orig,3) == 3
        img = double(rgb2gray(orig));
    else
        img = double(orig);
    end
    
    % Blob dedection for original image
    scale_space = create_scale_space(img, k, scale, levels);
    [x,y,r] = find_maxima(scale_space, k, scale, threshold);
    figure;
    show_all_circles(orig,x,y,r);

    keypoint = zeros(2,levels);
    % Choose random point
    x_rnd = 1;
    y_rnd = 1;
    while mod(x_rnd,2) + mod(y_rnd,2) > 0
        rnd = randi(size(x,1),1,1);
        x_rnd = x(rnd);
        y_rnd = y(rnd);
    end
    keypoint(1,:) = reshape(scale_space(y_rnd,x_rnd,:),1,10);


    % Blob dedection for half sized image
    % If image is RGB, convert to grayscale
    if size(orig,3) == 3
        img = double(rgb2gray(imresize(orig,0.5)));
    else
        img = double(imresize(orig,0.5));
    end
    
    scale = scale;
    scale_space = create_scale_space(img, k, scale, levels);
    [x,y,r] = find_maxima(scale_space, k, scale, threshold);
    figure;
    show_all_circles(imresize(orig,0.5),x,y,r);
    keypoint(2,:) = reshape(scale_space(y_rnd/2,x_rnd/2,:),1,10);

    figure;
    plot(1:10,keypoint(1,:),1:10,keypoint(2,:),'LineWidth',2);
    title('Filter Response for random keypoint')
    xlabel('scale')
    ylabel('filter response')
end

