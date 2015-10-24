% Function getShift
% takes two images A and B as inputm, shifts the B image in a range of 
% [-15 15] in x and y direction and calculates the normalized 
% cross-correlation (NCC) to A.
% Returns the x and y shift, where the NCC is max.
function [h,v] = getShift(A,B)
    corr_max = 0;
    for i = -15:15
       for j = -15:15
          temp = corr2(A, circshift(B,[i,j]));
          if temp > corr_max 
              corr_max = temp;
              h = i;
              v = j;
          end
       end
    end
end
