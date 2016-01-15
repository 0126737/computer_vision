function [ map ] = create_overlap_map( timg )

% Create overlap map
map = zeros(size(timg{1},1),size(timg{1},2));
for i=1:size(timg,2)
    map = map + (rgb2gray(timg{i})~=0);
end
map = map>=2;
map = cat(3, map, map, map);

end

