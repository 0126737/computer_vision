function [ canvas ] = feathering( imgs, timg, H, xdata, ydata )

% Step 5 - Feathering

% Create overlap map
map = create_overlap_map(timg);

canvas = zeros(size(timg{1}));
for i = 1:size(timg,2)
    canvas = canvas + timg{i};
end

% Create alpha channels and transform to plane
Alpha = cell(1,size(timg,2));
for i=1:size(timg,2)
    h = size(imgs(:,:,:,1),1);
    w = size(imgs(:,:,:,1),2);
    temp = zeros(h,w);
    temp(:,1) = 1; temp(:,w) = 1; temp(h,:) = 1; temp(1,:) = 1;
    Alpha{i} = bwdist(temp);
    Alpha{i} = Alpha{i} / max(max(Alpha{i}));
    Alpha{i} = imtransform(Alpha{i}, H{i}, 'XData', xdata, 'YData', ydata, 'XYScale', 1);
    % If OUT OF MEMORY ERROR use the following line, instead of above
    %Alpha{i} = imtransform(Alpha{i}, H{i}, 'XData', xdata, 'YData', ydata);
end

% Calculate alpha weighted sum of colors
overlap = cell(1,size(timg,2));
sumlap = zeros(size(canvas));
sumcolors = zeros(size(canvas));
for i=1:size(timg,2)
    overlap{i} = map .* cat(3,Alpha{i},Alpha{i},Alpha{i});
    sumcolors = sumcolors + timg{i} .* overlap{i};
    sumlap = sumlap + overlap{i};
end
blended = sumcolors ./ sumlap;

% Set overlapping color values
canvas(map) = blended(map);

end

