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

%{
im_size = size(r);
num_rows = im_size(1);
num_cols = im_size(2);

for i = -15:15
    if i <= 0
        rows_r = [1:(num_rows+i)];
        rows_g = [(1-i):num_rows];
    else
        rows_r = [(1+i):num_rows];
        rows_g = [1:(num_rows-i)];
    end
    for j = -15:15
        if j <= 0
            cols_r = [1:(num_cols+j)];
            cols_g = [(1-j):num_cols];
        else
            cols_r = [(1+j):num_cols];
            cols_g = [1:(num_cols-j)];
        end
t        
        A = r(rows_r, cols_r);
        B = circshift(g,[i,j]);
        B = B(rows_g, cols_g);
        %temp = corr2(r, circshift(g,[i,j]));
        temp = corr2(A, B);
        if temp > max
            max = temp;
            i_g = i;
            j_g = j;
        end
    end
end

max = 0;

for i = -15:15
    if i <= 0
        rows_r = [1:(num_rows+i)];
        rows_b = [(1-i):num_rows];
    else
        rows_r = [(1+i):num_rows];
        rows_b = [1:(num_rows-i)];
    end
    for j = -15:15
        if j <= 0
            cols_r = [1:(num_cols+j)];
            cols_b = [(1-j):num_cols];
        else
            cols_r = [(1+j):num_cols];
            cols_b = [1:(num_cols-j)];
        end
        
        A = r(rows_r, cols_r);
        B = circshift(b,[i,j]);
        B = B(rows_b, cols_b);

        temp = corr2(A, B);
        if temp > max
            max = temp;
            i_b = i;
            j_b = j;
        end
    end
end
%}

%{
for i = -15:15
   for j = -15:15
      temp = corr2(r, circshift(g,[i,j]));
      if temp > max
          max = temp;
          i_g = i;
          j_g = j;
      end
   end
end

max = 0;

for i = -15:15
   for j = -15:15
      temp = corr2(r, circshift(b,[i,j]));
      if temp > max
          max = temp;
          i_b = i;
          j_b = j;
      end
   end
end
%}