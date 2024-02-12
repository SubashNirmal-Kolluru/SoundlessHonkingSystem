function ahtSparse_botm(inpMat,thr,points,sep,fc_bot)

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
bool2 = zeros(2*n+1,1); 
featMat_bot = zeros(rows,cols);
data_count2 = 0;

% Feature matrix generation
for c=1:cols
    for k=(fc_bot-n*m):m:(fc_bot+n*m)
    % code for coefficients at the window
        for j = 1:rows
            yi(k,c) = yi(k,c) + inpMat(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + inpMat(j,c)*bq(j,k);
        end
    end
    
    y = yi + 1i*yq;                       % inphase + i*quad phase
%     figure('Name','AHT mat for botm');
%     imshow(abs(y));
    
    for k=(fc_bot-n*m):m:(fc_bot+n*m)
       bool2((k-fc_bot)/m +n+1) = (abs(y(k,c))>thr);
    end
    
    % Find the index of the upper feature point.
    
    index = botIndex(bool2);
    if index ~= 12
         fc_bot =  fc_bot - m*(n+1)+m*(index);
         featMat_bot(fc_bot,c) = 1;
         data_count2 = data_count2+1;
    end
        
    % include the out of bound protection code here
   if fc_bot<top_lim
       while(fc_bot<top_lim)
           fc_bot = fc_bot+m;
       end
   elseif fc_bot>bot_lim
       while(fc_bot>bot_lim)
           fc_bot = fc_bot-m;
       end
   end
 
end

figure('Name','AHT Sparse_Botm');
imshow(flip(featMat_bot));
fprintf('%s%d\n','Total_points: ',cols)
fprintf('%s%d\n','Missing_points: ',cols - data_count2)

end
