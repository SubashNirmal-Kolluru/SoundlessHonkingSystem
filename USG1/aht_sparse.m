clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Kaushal');
path = fullfile(pathname,filename);
a0 = imread(path);

[rows, cols, layers] = size(a0);
if layers ==3
    a0 = rgb2gray(a0);
end

 figure('Name', 'Original')
 imshow(a0);
 
 a1 = ifft(a0);    % raw data generated.
 %  thr = 110;
 BL = baseline(a0);
 thr =  threshold(a0,BL,0.85);   % percent  = 60 
 fprintf('%s%3.0f\n','Threshold:  ',thr);
 ahtFull = ahtFull(a1,thr);
%  figure('Name','AHT Output');
%  imshow(Uint8(ahtFull));     
%  
%   % Smooth waves is the Smoothened wave output.
%  Smooth_Waves = ahtSparse(a1,thr,11,2,ceil(rows/3),ceil(2*rows/3));
%  c = 1:1:cols;
%   figure('Name','Waves');
%   plot(c,Smooth_Waves(1,:),c,Smooth_Waves(2,:));
%   
