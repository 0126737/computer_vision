img = double(imread('butterfly.jpg'));

img = imresize(img,0.5);

levels = 10;
scale = 2;
k = 1.25;
% Q: how to choose threshold
threshold = 100.0;

scale_space = zeros(size(img,1),size(img,2),levels);

sigma = scale;
for i=1:levels
    h = fspecial('log',2*floor(3*sigma)+1,sigma) * sigma^2;
    scale_space(:,:,i) = abs(imfilter(img, h, 'same', 'replicate'));
    sigma = sigma * k;
end

maxima = [1,1,1;1,0,1;1,1,1];

cxi=0;
cyi=0;
ri=0;
sigma = scale*k;
for i=2:levels-1
    % find local maxima
    % Q: what about maxima at the edges? There are no neighbours
    [r,c] = find(scale_space(:,:,i)>threshold);
    
    for j=1:size(r,1)
        temp = scale_space(r(j)-1:r(j)+1,c(j)-1:c(j)+1,i);
        temp = temp(2,2)>temp;
        if isequal(temp,maxima)
            % check scale-1
            max = scale_space(r(j),c(j),i);
            temp = scale_space(r(j)-1:r(j)+1,c(j)-1:c(j)+1,i-1);
            temp = max>temp;
            if all(all(temp))
                % check scale+1
                temp = scale_space(r(j)-1:r(j)+1,c(j)-1:c(j)+1,i-1);
                temp = max>temp;
                if all(all(temp))
                    %local maximum found
                    cxi= [cxi;c(j)];
                    cyi= [cyi;r(j)];
                    ri = [ri;sigma*sqrt(2)];
                end
            end
        end
    end
    sigma = sigma*k;
end

cxi = cxi(2:end);
cyi = cyi(2:end);
ri = ri(2:end);

show_all_circles(uint8(img),cxi,cyi,ri);

