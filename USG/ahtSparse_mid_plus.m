%The code is updated with suggestion for new fc if the operation doesn't
%find any new fc. It will help as per the value of trace.
function ahtSparse_mid_plus(inpMat,thr,points,sep,fc)

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
trace0 =2;
trace = trace0; % for helping in new fc in case of failure.
del_fc = 0; 
correction_count = 0;
data_count = 0;
Wave = zeros(1,cols);
RangeA = 0;
RangeB = 0;
RangeC = 0;
RangeD = 0;

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
    
    % Statistical distribution of peak difference
    if Max_diff(c) <=5
        RangeA = RangeA+1;
    elseif Max_diff(c)>5 && Max_diff(c)<=10
        RangeB = RangeB+1;
    elseif Max_diff(c)>10 && Max_diff(c)<=15
        RangeC = RangeC+1;
    elseif Max_diff(c)>15 
        RangeD = RangeD+1;
    end
     
    % feature matrix containing the peak value only.
   if max>thr
       del_fc = fc;
       fc = fc+(i-(n+1))*m;
       del_fc = fc - del_fc;
       featMat(rows+1-fc,c) = 1;  % Inverting the features.  
       trace =trace0;
       data_count  = data_count + 1;
   elseif max< thr && trace>0
       correction_count = correction_count+1;
       fc = fc + del_fc;
       trace = trace -1;
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
  figure('Name','Max Difference plot');
 
 figure('Name','Difference Plot')
 plot(c,Max_diff(c),'bd-','LineWidth',2);
% 
% figure('Name','WaveformPlot');
% plot(c,Wave(c),'r*-','LineWidth',2);
disp('Sampling freq:     40kHz')
fprintf('%s%3.1f\n','The delta f is:    ',(2E4/rows)*m)

figure('Name', 'Feature matrix')
imshow(featMat)

fprintf('%s%d\n','Correction_count:  ',correction_count)
fprintf('%s%d\n','Total_points:      ',cols)
fprintf('%s%d\n','Missing_points:    ',cols - data_count)

fprintf('\n%s%\n','Statistical Max Diff Distribution:')
fprintf('\n%s%2.2f\n','0-5%:    ',RangeA*100/data_count)
fprintf('%s%2.2f\n','5-10%:   ',RangeB*100/data_count)
fprintf('%s%2.2f\n','10-15%:  ',RangeC*100/data_count)
fprintf('%s%2.2f\n\n','>15%:    ',RangeD*100/data_count)
 
end



