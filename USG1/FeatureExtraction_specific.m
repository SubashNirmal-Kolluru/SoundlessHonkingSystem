clc;
clear all;
close all;
a=imread('images\pp.jpg');
a1=rgb2gray(a);
[rows,columns]=size(a1);

 for c=1:columns
    max(c)=a1(1,c);                 %%%% maximum intensity
    max2(c)=a1(2,c);                %%%% second maximum intenity 
    for r=1:rows
        if(a1(r,c)>max(c))
           max(c)=a1(r,c);              
           x2(c)=r;                 %%% x2(c) row which represent the max intensity of respective column
        end
    end
       for r=1:rows
           if(a1(r,c)<max(c) && a1(r,c)>max2(c))
            max2(c)=a1(r,c);
            x1(c)=r;                %%% x1(c) row which represent the second max intensity of respective column
           end
       end
        
 end
  m=max2(1);                        %%%% m is minimum intensity in the second maximum column
for c=1:columns
    if(max2(c) < m)
        m = max2(c);
    end
end

    
 %%% for continuous Middle waveform %%%
 
 
 for c=1:columns-2
     for r=1:rows
         x1(c+1)=round((x1(c)+x1(c+2))/2);
         if(x1(c+2)>x1(c))
             for r=x1(c):x1(c+1)
             a2(r,c)=a1(r,c);
             a21(r,c)=a1(r,c);
            end         
         else
              for r=x1(c+1):x1(c)
                  a2(r,c)=a1(r,c);
                  a21(r,c)=a1(r,c);
              end
         end
     end
 end
     
   
     %%% For Top waveform %%%
     
     
for c=1:columns
    min(c)=max2(c);
     for r=1:x1(c)
        if(a1(r,c)>43 && a1(r,c)< min(c))
            min(c)=a1(r,c);
             x5(c)=r;                                                   %%%%% x5 -->  row which contain the threshold values of top waveform    %%%%
        end
    end
end

%%% for contineous waveform  %%


for c=1:columns-2
    for r=1:rows
        x5(c+1)=round((x5(c)+x5(c+2))/2);
        if(x5(c+2)>x5(c))
             for r=x5(c):x5(c+1)
             a2(r,c)=40;
             a11(r,c)=40;                                                                       %%%% a11 is matrix with top waveform
            end         
         else
              for r=x5(c+1):x5(c)
                  a2(r,c)=40;
                  a11(r,c)=40;
              end
         end
     end
end
% imshow(a11);
        
 

%%% For bottom waveform %%%

for c=1:columns
    min2(c)=max2(c);
     for r=x1(c):rows
        if(a1(r,c)>43 && a1(r,c)< min2(c))
            min2(c)=a1(r,c);
             x52(c)=r;                              %%%%% x52 -->  Row whichh contain the threshold value of bottom values %%%%
         end
     end
   
end
for c=1:columns
if(x52(c)==0)
        x52(c)=x1(c);
end
end

%%% for contineous waveform  %%%


for c=1:columns-2
    for r=1:rows
        x52(c+1)=round((x52(c)+x52(c+2))/2);
        if(x52(c+2)>x52(c))
             for r=x52(c):x52(c+1)
             a2(r,c)=40;
             a31(r,c)=40;                       %% a31 is matrix of bottom waveform   %%%
            end         
         else
              for r=x52(c+1):x52(c)
                  a2(r,c)=40;
                 a31(r,c)=40;
              end
         end
     end
end
  imshow(a2);
  
  
  
  
  %%%%%%% Feature Extraction using derivative method %%%%%
 
  %%%% Derivative Method %%%%
  
  %%% 1. Accelration Slope %%%
  for c=4:columns-5
      for r=1:rows-1
          if(a11(r,c)~=0)
              y1(c)=r;
          for r=1:rows-1
              if(a11(r,c+1)~=0)
                  y1(c+1)=r;
                  break;
              end
              for r=1:rows-1
               if(a11(r,c-1)~=0)
                  y1(c-1)=r;
                  break;
               end
              end
              for r=1:rows-1
               if(a11(r,c-2)~=0)
                  y1(c-2)=r;
                  break;
               end
              end
              for r=1:rows-1
               if(a11(r,c+2)~=0)
                  y1(c+2)=r;
                  break;
               end
              end
              for r=1:rows-1
               if(a11(r,c+3)~=0)
                  y1(c+3)=r;
                  break;
               end
              end
              for r=1:rows-1
               if(a11(r,c-3)~=0)
                  y1(c-3)=r;
                  break;
               end
              end
          end
          end
      end
     
  end

  for c=4:columns-5
       first_der(c)=(y1(c+1)-y1(c-1)+y1(c+2)-y1(c-2))/2;
      second_der(c)=(y1(c+1)+y1(c-1)+y1(c+2)+y1(c-2)+y1(c+3)+y1(c-3)-6*y1(c));
  end
  for c=1:(columns-3)/2
      if(first_der(c)==0 && second_der(c)>0)
          pixel_x2=c;
      end
  end
  
%%%% lower point for accelration slope %%%
      for r=1:rows-1
         if(a31(r,1)~=0)
             pixel_y1=r;
             pixel_x1=1;
         end         
      end
      for r=1:rows-1
      if(a11(r,pixel_x2)~=0)
             pixel_y2=r;
             break;
      end
      end
      
      acc_slope=-(pixel_y2-pixel_y1)/(pixel_x2-pixel_x1);
      fprintf('\n%s %d','The accelration slope is = ',acc_slope);
      
%%%% Decellration Slope lower point%%%%
for c=4:(columns-2)/2
    if(a31(pixel_y1,c)~=0)
        pixel_x3=c;
        pixel_y3=pixel_y1;
        break
    end
end
 dec_slope=-(pixel_y2-pixel_y3)/(pixel_x2-pixel_x3);
 fprintf('\n%s %d','The deccelration slope is = ',dec_slope);
 
 
%%%  Systolic window %%
sys_window= pixel_x3-pixel_x1;
fprintf('\n%s %d','The Systolic window = ',sys_window);

%%%  Diastolic %%%%


  for c=pixel_x3:(columns-4)
      if(first_der(c)==0 )
          pixel_x4=c;
          break;
      end
  end
  for r=1:rows-1
      if(a11(r,pixel_x4)~=0)
          pixel_y4=r;
      end
  end
 Sys_Dia_ratio= (rows-pixel_y2)/(rows-pixel_y4);
 fprintf('\n %s %d','Systolic to diastolic ratio is = ', Sys_Dia_ratio);
 
%%%% Negative Peak %%%
 for c=3:columns-4
      for r=1:rows
          if(a31(r,c)~=0)
              y399(c)=r;
          for r=1:rows
              if(a31(r,c+1)~=0)
                  y399(c+1)=r;
                 
              end
              for r=1:rows
               if(a31(r,c-1)~=0)
                  y399(c-1)=r;
                 
               end
              end
             for r=1:rows
               if(a31(r,c-2)~=0)
                  y399(c-2)=r;
               
               end
             end
               for r=1:rows
               if(a31(r,c-2)~=0)
                  y399(c-2)=r;
                  
               end
               end
              
          end
          end
      end
      
 end
  
for c=3:columns-5
    first_der22(c)=(y399(c+1)-y399(c-1))/2;
    second_der22(c)=(y399(c+1)+y399(c-1)+y399(c-2)+y399(c+2)-4*y399(c))/1;
end
present =0;
      for c=1:(columns-3)/2
      if(first_der22(c)==0 && second_der22(c)<0 && y399(c)>=(pixel_x3+rows)/2)
       present=1;          
      end
  end
if(present ==1)
    fprintf('\n %s','The negative peak is present');
else
    fprintf('\n %s','The negative peak is absent');
end
    
%%%%% Period %%%%%
for c=1:columns-5
    if(first_der22(c)==0 && second_der22(c)<0)
        pixel_x5=c;
    end
end

period=pixel_x5-pixel_x1;
fprintf('\n%s %d','The peroid is = ',period);