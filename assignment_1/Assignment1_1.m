clear

set(0,'units','pixels');
screen_size = get(0,'screensize');


fig_width = round(screen_size(3) / 2);
fig_height = round(screen_size(4) / 3);

% Computer Vision Assignment 1.1

% Image names
str_img = {'00125v','00149v','00153v','00351v','00398v','01112v'};

for i=1:size(str_img,2)
    % Read R, G and B image
    r = imread(char(strcat(str_img(i),'_R.jpg')));
    g = imread(char(strcat(str_img(i),'_G.jpg')));
    b = imread(char(strcat(str_img(i),'_B.jpg')));
    
    % get shift for G image
    [i_g, j_g] = getShift(r,g);
    % get shift for B image
    [i_b, j_b] = getShift(r,b);
    
    % combine to RGB image
    img = cat(3, r, circshift(g,[i_g, j_g]), circshift(b,[i_b, j_b]));

    % show RGB image
    f = figure; 
    set(f, 'Position', [20,screen_size(4)-fig_height-100,fig_width, fig_height]);
    subplot(1, 2, 1);
    imshow(cat(3, r, g, b));
    title(char(str_img(i)),'Fontsize',16);
    xlabel('unaligned','Fontsize',14);
    subplot(1, 2, 2);
    imshow(img);
    title(char(str_img(i)),'Fontsize',16);
    xlabel('aligned','Fontsize',14);
end