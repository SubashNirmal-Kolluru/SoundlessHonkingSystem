% FOR NOW THIS HAS BEEN DIFFERENTIATED FOR WAVE INPUTS
% This is a function that performs AHT Full on the imput matrix. 
% Input required is the matrix and the thresold of filtering.
% Ouputs the AHT matrix.
 
function a_out = ahtFull_wav(a1,thr)
[rows,cols] = size(a1);
N =rows;
k = 1:1:rows;                       %  k denotes frequency 


% Quadrature basis functions
bi = zeros(rows);
bq = zeros(rows);
for j = 1:rows                  % j denotes time in discrete
   bi(j,:) = sign(cos(2*(pi/N).*j.*k));
   bq(j,:) = sign(sin(2*(pi/N).*j.*k));   
end

% Projection onto the basis functions
yi = zeros(rows,cols);
yq = zeros(rows,cols);
for c = 1:cols
    for k = 1:rows
        yi(k,c) = 0;                  % k > N-k +1 
        yq(k,c) = 0;
        for j = 1:rows
            yi(k,c) = yi(k,c) + a1(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + a1(j,c)*bq(j,k);
        end
    end    
end


y = yi + 1i*yq;
% thresolding
y_thr = zeros(rows,cols);
for c=1:cols
    for r=1:rows
        if abs(y(r,c)) > thr
            y_thr(r,c) = abs(y(r,c));
        end
    end
end
 a_out = Uint8(y_thr);
 figure('Name', 'AHT thresolded output')
 imshow(Uint8(y_thr));

end