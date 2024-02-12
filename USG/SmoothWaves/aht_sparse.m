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

a1 = ifft(a0);    % raw data generated.

 % Smooth waves is the Smoothened wave output.
 Smooth_Waves = ahtSparse(a1,120,11,2,ceil(rows/3),ceil(2*rows/3));
 
 c = 1:1:cols;
 figure('Name','Waves');
 plot(c,Smooth_Waves(1,:),c,Smooth_Waves(2,:));
 
