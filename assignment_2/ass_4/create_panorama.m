function [timg, H, xdata, ydata] = create_panorama( imgs )

ref_img = round(size(imgs,4)/2);
num_imgs = size(imgs,4);
          
% Step 1 - Create homographies
H = cell(1,num_imgs);
for i = 1:ref_img-1
    [points_a, points_b] = matching(single(rgb2gray(imgs(:,:,:,i))), ...
                                    single(rgb2gray(imgs(:,:,:,i+1))));
    H{1,i} = ransac(points_a,points_b, 1000, 5);
end
H{1,ref_img} = maketform('projective',eye(3));
for i = ref_img+1:num_imgs
    [points_a, points_b] = matching(single(rgb2gray(imgs(:,:,:,i-1))), ...
                                    single(rgb2gray(imgs(:,:,:,i))));
    H{1,i} = ransac(points_a,points_b, 1000, 5);
end

% Step 2 - Align Homographies to reference image
% Align left images
for i= ref_img-2:-1:1
    H{i}.tdata.T = H{i+1}.tdata.T * H{i}.tdata.T;
    H{i}.tdata.Tinv = H{i+1}.tdata.Tinv * H{i}.tdata.Tinv;    
end
% Align right images
for i = ref_img+2:num_imgs
    H{i}.tdata.T = H{i-1}.tdata.T * H{i}.tdata.T;
    H{i}.tdata.Tinv = H{i-1}.tdata.Tinv * H{i}.tdata.Tinv; 
end
for i = ref_img+1:num_imgs
    temp = H{i}.tdata.Tinv;
    H{i}.tdata.Tinv = H{i}.tdata.T;
    H{i}.tdata.T = temp;    
end

% Step 3 - Determine size of panorama image
corners = zeros(4*num_imgs,2);
for i = 1:num_imgs
    corners((i-1)*4+1:i*4,:) = tformfwd(H{i}, [1, 1; ...
        1, size(imgs(:,:,:,i),1); ...
        size(imgs(:,:,:,i),2), 1; ...
        size(imgs(:,:,:,i),2), size(imgs(:,:,:,i),1)]);
end
xdata = [min(corners(:,1)) max(corners(:,1))];
ydata = [min(corners(:,2)) max(corners(:,2))];

% Step 4 - Transform images
timg = cell(1,num_imgs);
for i=1:num_imgs
    timg{i} = imtransform(imgs(:,:,:,i), H{i}, 'XData', xdata, 'YData', ydata, 'XYScale', 1);
    % If OUT OF MEMORY ERROR use the following line, instead of above
    %Alpha{i} = imtransform(Alpha{i}, H{i}, 'XData', xdata, 'YData', ydata);
end

end

