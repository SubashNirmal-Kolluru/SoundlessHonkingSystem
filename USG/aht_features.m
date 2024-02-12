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
 Smooth_Waves = ahtSparse(a1,150,11,2,ceil(rows/3),ceil(2*rows/3));
 
 c = 1:1:cols;
 figure('Name','Waves');
 plot(c,Smooth_Waves(1,:),c,Smooth_Waves(2,:));
 
 yt = round(Smooth_Waves(2,:));
 yb = round(Smooth_Waves(1,:));
 
pixel_x1 = 1;
pixel_x2 = 1; 
pixel_x3 = 1;
pixel_x4 = 1;
pixel_x5 = 1;

pixel_y1 = 1;
pixel_y2 = 1; 
pixel_y3 = 1;
pixel_y4 = 1;
pixel_y5 = 1;

m11 = yt(1);
  for c=2:(cols-2)/2
      if(yt(c)<m11)
          m11 = yt(c);          % Row containig the max point/systole point
          pixel_x2 = c+1;       % Systole point column value
      end
  end
  
  pixel_y2 = m11;
  pixel_y1 = yb(1);
  
  M12 = yt(pixel_x1);
for c=3:(cols-2)
    if(yt(c) <= (M12+2) && yt(c)>= (M12-2))
        M12=yt(c);
        pixel_x3=c;
        pixel_y3=M12;
        break;
    end
end

% Acceleration slope 

acc_slope=-(pixel_y2-pixel_y1)/(pixel_x2-pixel_x1);
fprintf('\n%s %d','The accelration slope is = ',acc_slope);

% Deceleration 
  
dec_slope=-(pixel_y2-pixel_y3)/(pixel_x2-pixel_x3);
fprintf('\n%s %d','The deccelration slope is = ',dec_slope);

% Systolic window %
sys_window= pixel_x3-pixel_x1;
fprintf('\n%s %d','The Systolic window = ',sys_window);

for c=4:cols-7
       first_der(c)=(yt(c+1)-yt(c-1)+yt(c+2)-yt(c-2))/2;
      second_der(c)=(yt(c+1)+yt(c-1)+yt(c+2)+yt(c-2)+yt(c+3)+yt(c-3)-6*yt(c));
end
   
for c=pixel_x3:(cols-4)
       if(first_der(c)==0)
           pixel_x4=c;
           break;
       end
end
   
pixel_y4 = yt(pixel_x4);

% Systolic to Diastolic ratio %
Sys_Dia_ratio= (rows-pixel_y2)/(rows-pixel_y4);
fprintf('\n %s %d','Systolic to diastolic ratio is = ', Sys_Dia_ratio);

for c=3:cols-5
    first_der22(c)=(yb(c+1)-yb(c-1))/2;
    second_der22(c)=(yb(c+1)+yb(c-1)+yb(c-2)+yb(c+2)-4*yb(c))/1;
end

present =0;
      for c=1:(cols-3)/2
      if(first_der22(c)==0 && second_der22(c)<0 && y399(c)>=(pixel_x3+rows)/2)
       present=1;          
      end
  end
if(present ==1)
    fprintf('\n %s','The negative peak is present');
else
    fprintf('\n %s','The negative peak is absent');
end

m12 = yt(1);
  for c=pixel_x3:(cols-5)
      if(yt(c)<m12)
          m12 = yt(c);
          pixel_x5 = c+1;
      end
  end

period= pixel_x5 - pixel_x2;
fprintf('\n%s %d','The peroid is = ',period);
  

 
 
 
