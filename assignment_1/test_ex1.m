%r = imread('00125v_R.jpg');
%g = imread('00125v_G.jpg');
%b = imread('00125v_B.jpg');

%r = imread('00149v_R.jpg');
%g = imread('00149v_G.jpg');
%b = imread('00149v_B.jpg');

%r = imread('00153v_R.jpg');
%g = imread('00153v_G.jpg');
%b = imread('00153v_B.jpg');

r = imread('00351v_R.jpg');
g = imread('00351v_G.jpg');
b = imread('00351v_B.jpg');

%r = imread('01112v_R.jpg');
%g = imread('01112v_G.jpg');
%b = imread('01112v_B.jpg');

[i_g, j_g] = getShift(r,g);
[i_b, j_b] = getShift(r,b);

img = cat(3, r, circshift(g,[i_g, j_g]), circshift(b,[i_b, j_b]));
