clc;
clear all;
close all;

a=imread('images\bh_70_4.jpg');
[rows,columns,layers]=size(a);

if layers ==3
    a1=rgb2gray(a);
else
    a1 = a;
end

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

figure('Name','Features')
  imshow(a2);
  
  
  
