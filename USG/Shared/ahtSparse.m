
function Smooth_Waves = ahtSparse(inpMat,thr,points,sep,fc_up,fc_botm)

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
botm_lim = N - m*n;   % bottom limit
bool1 = zeros(2*n+1,1); 
bool2 = zeros(2*n+1,1);
featMat_up = zeros(rows,cols);
featMat_botm = zeros(rows,cols);
featMat = zeros(rows,cols);
Wave = zeros(2,cols);
data_count1 = 0;
data_count2 = 0;

% Feature matrix generation
for c=1:cols
    for k=(fc_up-n*m):m:(fc_up+n*m)
    % code for coefficients at the window
        for j = 1:rows
            yi(k,c) = yi(k,c) + inpMat(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + inpMat(j,c)*bq(j,k);
        end
    end
    
    y = yi + 1i*yq;                       % inphase + i*quad phase
   
    for k=(fc_up-n*m):m:(fc_up+n*m)
       bool1((k-fc_up)/m +n+1) = (abs(y(k,c))>thr);
    end
    
    % Find the index of the upper feature point.
  
    index = upIndex(bool1);
    if index ~= 0
         fc_up =  fc_up -m*(n+1)+m*index;
         featMat_up(fc_up,c) = 1;
         featMat(fc_up,c) = 1;
         Wave(2,c) = fc_up;
         data_count1 = data_count1+1;
    end
        
    % include the out of bound protection code here
   if fc_up<top_lim
       while(fc_up<top_lim)
           fc_up = fc_up+m;
       end
   end
   if fc_up>botm_lim
       while(fc_up>botm_lim)
           fc_up = fc_up-m;
       end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % For fc_bottom
    for k=(fc_botm-n*m):m:(fc_botm+n*m)
    % code for coefficients at the window
        for j = 1:rows
            yi(k,c) = yi(k,c) + inpMat(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + inpMat(j,c)*bq(j,k);
        end
    end
    
    y = yi + 1i*yq;                       % inphase + i*quad phase
    
    for k=(fc_botm-n*m):m:(fc_botm+n*m)
       bool2((k-fc_botm)/m +n+1) = (abs(y(k,c))>thr);
    end
    
    % Find the index of the upper feature point.

    index = botIndex(bool2);
    if index ~= 12
         fc_botm =  fc_botm -m*(n+1)+ m*index;
         featMat_botm(fc_botm,c) = 1;
         featMat(fc_botm,c) = 1;
         Wave(1,c) = fc_botm;
         data_count2 = data_count2+1;
    end
        
    % include the out of bound protection code here
   if fc_botm<top_lim
       while(fc_botm<top_lim)
           fc_botm = fc_botm+m;
       end
   end
   if fc_botm>botm_lim
       while(fc_botm>botm_lim)
           fc_botm = fc_botm-m;
       end
   end  
end
 c = 1:1:cols;
 Smooth_Waves = Smoothen(Wave);
 Smooth_Waves(isnan(Smooth_Waves)) = 0; % removes nan.
 
%  figure('Name','AHT Sparse');
%  imshow(flip(featMat));          %Straightens the result by inverting the inverted AHT.
%  figure('Name','AHT Sparse_Botm');
%  imshow(flip(featMat_up));          %Straightens the result by inverting the inverted AHT.
%  figure('Name','AHT Sparse_Up');
%  imshow(flip(featMat_botm));  %Straightens the result by inverting the inverted AHT.

disp('Sampling freq:      40kHz')
fprintf('%s%3.1f\n','The delta f is:     ',(2E4/rows)*m)
fprintf('%s%d\n','Total_points:       ',cols)
fprintf('%s%d\n','Missing_points_top:     ',cols - data_count2)
fprintf('%s%d\n','Missing_points_botm:    ',cols - data_count1)

end



