clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Test data\Spectrogram');
path = fullfile(pathname,filename);
a0 = imread(path);

[rows, cols, layers] = size(a0);
if layers ==3
    a0 = rgb2gray(a0);
end

a1 = abs(ifft(a0));    % raw data generated.

% Basis function. 
k = 1:1:rows;                       %  k denotes frequency 
N = rows;
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
y = abs(yi + 1i*yq);  % Absolute value of magnitude for each harmonic.

 a1 = abs(a1);
 % Sum all the rows in a column and store to an array.
 sum_A = zeros(1,cols);
 sumabs_A = zeros(1,cols);
 
 for i=1:cols
    sum_A(i) = sum(a1(:,i));
    sumabs_A(i) = sumabs(a1(:,i));
 end
 
 max_harmonics = zeros(1,cols);
 for i = 1:cols
    max_harmonics(i) = max(y(5:rows-4,i)); 
 end

c = 1:1:cols;
figure('Name','Max_harmnoics vs the DC comp');
plot(c,max_harmonics,c,sum_A,'LineWidth',2);
legend('MaxOfHarmonics','DC Comp');