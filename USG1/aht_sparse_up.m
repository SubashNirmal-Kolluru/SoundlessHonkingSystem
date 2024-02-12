clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG');
path = fullfile(pathname,filename);
a0 = imread(path);

%convert to single layer matrix
[rows, cols, layers] = size(a0);
if layers ==3
    a0 = rgb2gray(a0);
end
figure('Name','Original Image')
imshow(a0)

a1 = ifft(a0);    % raw data generated.
% figure('Name','Raw Image')
% imshow(a1)
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
n = 5;   % sparse points 2n+1
m = 2;   % spacing between the cells 
thr = 70; % thresold for the boundry
fc = m*n+1;  % choosing as starting point
top_lim = m*n+1 ; % uppermost value the window can attain without overflow.
bot_lim = N - m*n;   % bottom limit
Z = zeros(1,cols);    % feature output matrix

% Feature matrix generation
for c=1:cols
    for k=(fc-n*m):m:(fc+n*m)
    % code for coefficients at the window
        for j = 1:rows
            yi(k,c) = yi(k,c) + a1(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + a1(j,c)*bq(j,k);
        end
    end
    
    y = yi + 1i*yq;                       % inphase + i*quad phase
    y_abs = abs(y);
    % compare with thresold
    bool = zeros(2*n+1,1); 
    for k=(fc-n*m):m:(fc+n*m)
       bool((k-fc)/m +n+1) = (abs(y(k,c)) > thr); 
       
    end
      
    if all(bool==1)
        i =0;
        while i<=n;
           if fc-(n-i)*m >=top_lim
               fc = fc-(n-i)*m;
               break;
           else
               i = i+1;
           end
        end
    
    elseif all(bool==0)
        i=0;
         while i<=n;
           if fc+(n-i)*m <=bot_lim
               fc = fc+(n-i)*m;
               break;
           else
               i = i+1;
           end
        end
        
    elseif any(bool==1)
        for k=n*2+1:-1:1
            if bool(k)==1
                continue
            elseif bool(k) ==0
                Z(c) = fc-m*n+m*(k+1);                 % the index for the upper feature
                fc =  fc -m*n+m*k;
                break;                             %test case for error      
            end
        end

    end
          
end

figure('Name','Multiplied Output')
imshow(yi)
figure('Name','Feature Matrix')
plot(Z(:))


