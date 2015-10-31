function [ x, y, r ] = find_maxima( scale_space, k, scale, threshold )

maxima = [1,1,1;1,0,1;1,1,1];
x=0; y=0; r=0;

for i=2:size(scale_space,3)-1
    % find local maxima
    % Q: what about maxima at the edges? There are no neighbours
    [row,col] = find(scale_space(:,:,i)>threshold);
    
    for j=1:size(row,1)
        if row(j) == 1 || col(j) == 1 || row(j) == size(scale_space,1) || col(j) == size(scale_space,2)
            continue
        end
        temp = scale_space(row(j)-1:row(j)+1,col(j)-1:col(j)+1,i);
        temp = temp(2,2)>temp;
        if isequal(temp,maxima)
            % check scale-1
            max = scale_space(row(j),col(j),i);
            temp = scale_space(row(j)-1:row(j)+1,col(j)-1:col(j)+1,i-1);
            temp = max>temp;
            if all(all(temp))
                % check scale+1
                temp = scale_space(row(j)-1:row(j)+1,col(j)-1:col(j)+1,i+1);
                temp = max>temp;
                if all(all(temp))
                    %local maximum found
                    x = [x;col(j)];
                    y = [y;row(j)];
                    r = [r;scale * k^(i-1) * sqrt(2)];
                end
            end
        end
    end
end

x = x(2:end);
y = y(2:end);
r = r(2:end);

end

