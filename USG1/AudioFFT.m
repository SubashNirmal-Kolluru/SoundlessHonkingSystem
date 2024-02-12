clc;
clear all;
close all;

%Read the audio file
[filename, pathname] = uigetfile({ '*.wav','WAV File'; '*.*','All Files'},...
'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Test data\Audio');
path = fullfile(pathname,filename);
a = audioread(path);

 [row_a, col_a] = size(a);
 
 col_b = floor(row_a/512);            % new matrix b with fft of a 
 if col_b>512                              
     col_b = 512;                      % cropping the data to <=512 cols
 end
 
 b = zeros(512,col_b);
 a1 = zeros(512,col_b);
 
 for i = 1:col_b
     dataset = a((i-1)*512+1:i*512,1);
     a1(:,i)= dataset;
     b(:,i) = fft(dataset);              % b is FFT of a1 
 end
 
 c = zeros(100,col_b);
 for i=1:col_b
     c(:,i) = b(413:512,i);
 end
%   figure('Name','Audio Plot')
%   plot(a)
%  figure('Name','Matrix Converted')
%  imshow(Uint8(a1))
 figure('Name','FFT ')
 imshow(Uint8(b));
%  figure('Name','Cropped')
%  imshow(Uint8(c))
  
 % Perform AHT on the cropped raw data
 [a_out,yi,yq] = ahtFull_wav(a1,5);
 
 % Shift it to the mid.
%  [rows, cols] = size(a_out);
%  a_shifted = zeros(rows, cols);  % scaled to 8 bit for better results.
%  for i= 1:1:256
%  	a_shifted(i,:) = a_out(i+256,:);
%  end
%  figure('Name', 'Mid_Shifted AHT');
%  imshow(a_shifted);
%  ahtSparse_mid_plus(a_shifted,3,7,2,256);
% 
%  % Hilbert Transform of the raw data
 % ah = hilbert(a1);
 % ahtFull_wav(ah,10);
 % ahtSparse_mid(ah,5,7,2,20)