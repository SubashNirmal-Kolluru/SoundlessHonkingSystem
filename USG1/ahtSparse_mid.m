
function ahtSparse_mid(inpMat,thr,points,sep,fc)

[rows,cols] = size(inpMat);
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

% PARAMETERS
n = (points-1)/2;% sparse points 2n+1
m = sep;   % spacing between the cells 
top_lim = m*n+1 ; % uppermost value the window can attain without overflow.
bot_lim = N - m*n;   % bottom limit
Max = zeros(1,cols);  % maximum value array
Max2 = zeros(1,cols); % max2 value array
Max_diff = zeros(1,cols); % percentage difference array
bool = zeros(2*n+1,1); 
featMat = zeros(rows,cols);
Wave = zeros(1,cols);
data_count2 = 0;

% Feature matrix generation
for c=1:cols
    for k=(fc-n*m):m:(fc+n*m)
    % code for coefficients at the window
        for j = 1:rows
            yi(k,c) = yi(k,c) + inpMat(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + inpMat(j,c)*bq(j,k);
        end
    end
    
    y = yi + 1i*yq;                       % inphase + i*quad phase
    y_abs = abs(y);
   
    for k=(fc-n*m):m:(fc+n*m)
       bool((k-fc)/m +n+1) = abs(y(k,c));
    end
    
  % compare with thresold & Find the maximum in the window
    i = 0; % i is the index
    max = 0;
    max2 = 0;
    for k = 1:1:2*n+1
        if bool(k)>thr 
            if bool(k)>max
                max2 = max;
                max = bool(k);
                i =k;
            elseif bool(k)>max2
                max2 = bool(k);
            end
        end
    end
    
    % the difference in the peak value of max and second max
    Max(c) = max;
    Max2(c) = max2;
    Max_diff(c) = (1 - max2/max)*100;
     
    % feature matrix containing the peak value only.
   if max>thr
       fc = fc+(i-(n+1))*m;
       featMat(rows+1-fc,c) = 1;
       data_count2 = data_count2 +1;
   end
       % include the out of bound protection code here
   if fc<top_lim
       while(fc<top_lim)
           fc = fc+m;
       end
   end
   if fc>bot_lim
       while(fc>bot_lim)
           fc = fc-m;
       end
   end
   Wave(c) = fc;
   
end

 c= 1:cols;
%  figure('Name','Max Difference plot');
%  %hold on
%  %plot(c, Max(c),'r*-',c,Max2(c),'g+-','LineWidth',2);
%  plot(c,Max_diff(c),'bd-','LineWidth',2);
%  %hold off
figure('Name', 'WaveformPoints')
plot(c,Wave(c),'r*-','LineWidth',2);

disp('Sampling freq: 40kHz')
fprintf('%s%d\n','The delta f is: ',(2E4/rows)*m)

figure('Name', 'Feature matrix')
imshow(featMat)

fprintf('%s%d\n','Total_points: ',cols)
fprintf('%s%d\n','Missing_points: ',cols - data_count2)

end



