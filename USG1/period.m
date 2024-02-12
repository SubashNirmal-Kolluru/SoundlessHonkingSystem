
function [period,peak_value,peak_location] = period(wave)
 
len = length(wave);
count = 1;
max = wave(1);
peak = zeros(10, 2);
peak(1,:) = [1, wave(1)];
thr = 0.1;
sep = 50;

for c = 2:len
   if wave(c) > (1-thr)*max                     % this is the maximum value of waveform.
       if ((c - peak(count,1) < sep) && (wave(c) > max ))     % if they lie within a seperation.
           peak(count,:) = [c, wave(c)];      % update the recent peak.
           max =  wave(c);                      % update max.
       elseif (c - peak(count,1) > sep)           % for more seperated.  
           for i = 1: count                       % erase all the previous peaks below threshold.  
               if peak(i,2) < (1-thr)*max;
                   peak = [peak(1:i-1, :) peak(i+1:end, :)] ;                  
                   count = count - 1 ;
                   i = i - 1;
               end
           end
           count = count + 1;
           peak(count,:) = [c, wave(c)];    % add a peak.
       end
   end
end

period = peak(2,1) - peak(1,1);
peak_value = peak(2,2);
peak_location  = peak(1,1);
% add the code for finding the gcd of the peaks here.
end