clc;
clear all;
close all;

 % Read the audio file
 [filename, pathname] = uigetfile({ '*.wav','WAV File'; '*.*','All Files'},...
 'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Test data\Audio');
 path = fullfile(pathname,filename);
 a = audioread(path);
 
 [row_a, col_a] = size(a);
 
 row_b = 512;
 N = row_b;
 col_b = floor(row_a/row_b);            % new matrix b with fft of a 
 if col_b>1000                              
     col_b = 1000;                      % cropping the data to <=512 cols
 end
 
 b = zeros(row_b,col_b);
 a1 = zeros(row_b,col_b);
 
 for i = 1:col_b
     dataset = a((i-1)*row_b+1:i*row_b,1);
     a1(:,i)= dataset;
 end
 
   figure('Name','Audio Plot')
   plot(a)

 % Sum all the rows in a column and store to an array.
 sum_A = zeros(1,col_b);
 sumabs_A = zeros(1,col_b);
 
 for i=1:col_b
    sum_A(i) = sum(a1(:,i));
    sumabs_A(i) = sumabs(a1(:,i));
 end
 
% Basis function. 
k = 1:1:row_b;                       %  k denotes frequency 
bi = zeros(row_b);
bq = zeros(row_b);
for j = 1:row_b                  % j denotes time in discrete
   bi(j,:) = sign(cos(2*(pi/N).*j.*k));
   bq(j,:) = sign(sin(2*(pi/N).*j.*k));   
end

% Projection onto the basis functions
yi = zeros(row_b,col_b);
yq = zeros(row_b,col_b);
for c = 1:col_b
    for k = 1:row_b
        yi(k,c) = 0;                  % k > N-k +1 
        yq(k,c) = 0;
        for j = 1:row_b
            yi(k,c) = yi(k,c) + a1(j,c)*bi(j,k);
            yq(k,c) = yq(k,c) + a1(j,c)*bq(j,k);
        end
    end   
end
y = abs(yi + 1i*yq);  % Absolute value of magnitude for each harmonic.

max_harmonics = zeros(1,col_b);
for i = 1:1:col_b
   max_harmonics(i) = max(y(2:row_b-1,i)); 
end

c = 1:1:col_b;
figure('Name','Max of harmonics vs. DC comp');
plot(c,max_harmonics,c,sum_A,'LineWidth',2);
legend('MaxOfHarmonics','DC Comp');