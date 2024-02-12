clc;
clear all;
close all;

% read the input.this time it is fft image
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },...
'Pick a file','C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Kaushal\Data');
path = fullfile(pathname,filename);
a = imread(path);
figure('Name','Original Spectrogram')
imshow(a);
% a = imread('C:\Users\Arvind Srivastav\Desktop\VLSI SU\+ USG\Test data\Spectrogram\01 Clean\M crop b datta 103 - Copy.jpg');
[rows,cols,layers]=size(a);

if layers == 3
    a = rgb2gray(a);
end

% open the file to write the results.
fileID = fopen('feature_results.txt','a');
fprintf(fileID,'\n%s\n',filename);

a0 = ifft(a);
BL = baseline(a);         % Baseline depends on the spectrogram.
thr = threshold(AHT(a0),BL,0.6);
% thr  = 90;
waves = ahtSparse(a0,thr,11,2,ceil(rows/3),ceil(2*rows/3));
figure('Name','Top and Botm waveforms');
c = 1:1:cols;
plot(c,waves(1,:),c,waves(2,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part corrosponds to finding the period of the waveform & the peak value.

% parameters
sep = 50;
margin = 0.1; 

% Adjust the baseline for robustness.
% % if waveform is Non-inverted, then BL = rows - BL for arrays.
BL = rows - BL;
BL = BL*1.2;
result = inv_test(waves,sep,margin,BL);

if result == 0
disp('Waveform is Non-Inverted');   
    features(waves,sep,margin,BL);
else
    disp('Waveform is Inverted');
    fprintf(fileID,'%s','The waveform is inverted');
    fclose(fileID);
    % Invert the spectrogram matrix.
    b = flipud(a);
    b0 = ifft(b);
    waves_inv = ahtSparse(b0,thr,11,2,ceil(rows/3),ceil(2*rows/3));
%     waves_inv(2,:) = rows - waves(1,:);
%     waves_inv(1,:) = rows - waves(2,:);
    c = 1:1:cols;
    plot(c,waves_inv(1,:),c,waves_inv(2,:));
    BL = BL*1.15;
    features(waves_inv,sep,margin,BL);
end


 


    