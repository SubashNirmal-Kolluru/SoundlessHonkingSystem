clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\subashnirmal\Documents\+ USG\Kaushal\Data\Modified Abnormal');
path = fullfile(pathname,filename);
a = imread(path);
%a = imread('C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Test data\Spectrogram\01 Clean\M crop b datta 103 - Copy.jpg');
[rows,cols,layers]=size(a);

if layers == 3
    a = rgb2gray(a);
end
a0 = ifft(a);
% thr  = 10;
BL =  baseline(a);
thr_percent = 0.55;
thr = threshold(a,BL,thr_percent);
% y = ahtFull(a0,thr);
waves = ahtSparse(a0,thr,11,2,ceil(rows/3),ceil(2*rows/3));
figure('Name','Top and Botm waveforms');
c = 1:1:cols;
plot(c,waves(1,:),c,waves(2,:));
