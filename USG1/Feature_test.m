clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\subashnirmal\Documents\+ USG\Kaushal\Data\Modified abnormal');
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
thr_percent = 0.5;
BL_factor = 1.9;
thr = threshold(a,BL,thr_percent);
% y = ahtFull(a0,thr);
waves = ahtSparse(a0,thr,13,2,ceil(rows/3),ceil(2*rows/3));
figure('Name','Top and Botm waveforms');
c = 1:1:cols;
plot(c,waves(1,:),c,waves(2,:));

% feature extraction. 
sep = 50;
toler = 0.1;
% First find whether the waves are inverted.
BL = rows - BL;
result = inv_test(waves,sep,toler,BL);

if result == 0
    BL = BL*BL_factor;
    output = features(waves, sep, toler, BL, BL_factor);
    output(10) = result;
    output(11) = thr_percent;
    output(12) = BL_factor;
else
    BL = rows - BL;
    BL = BL*BL_factor;
    b = flipud(a);
    b0 = ifft(b);
    waves_inv = ahtSparse(b0,thr,11,2,ceil(rows/3),ceil(2*rows/3));  
    figure('Name','Top and Botm waveforms iNVERTED');
    c = 1:1:cols;
    plot(c, waves_inv(1,:),c,waves_inv(2,:));
    output = features(waves_inv, sep, toler, BL,BL_factor);
    output(10) = result;
    output(11) = thr_percent;
    output(12) = BL_factor;
end
% modify the systolic window to include the shift.
%(2) = output(2) + 2*(BL_factor - 1)*BL/output(3);
