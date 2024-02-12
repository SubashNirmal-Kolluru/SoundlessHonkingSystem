function result = inv_test(waves, sep, thr, BL )

wave_top = waves(1,:);
wave_bot = waves(2,:);
flag = 1;

[period, peak_value, peak_location] = data(wave_top);

len = length(wave_top);
max_top = 0;      
max_location = peak_location + period;   % start with a big value.
S = zeros(1,16);   % S is the array of points corrosponding to systolic window.
i = 1 ;           % array initializing.

peak_count = 0; 
min_bot  =  peak_value;
min_bot_location = 0;
pre_peak_location = peak_value;
pre_peak_value = peak_location;
new_peak_location = peak_location;
new_peak_value = peak_value;

result = 0;

for c = peak_location : len

  % Define new_period_location as the column at which the
  %(1 - thr/2)*peak_value   < wave_top(c)< (1 + thr/2)*peak_value and it is
  % the maximum value in vicinity. 
  if (wave_top(c) < (1 + thr/2)*peak_value && wave_top(c) > (1 - thr/2)*peak_value)
      
     if wave_top(c) > max_top
         max_top = wave_top(c);
         max_location  = c;
     end
  end
  
  if c - max_location > sep/2
      flag = 1;  
      peak_count  = peak_count + 1;
      pre_peak_value = new_peak_value;
      pre_peak_location = new_peak_location;
      new_peak_value = max_top;
      new_peak_location = max_location;
      % Updating parameters.
      max_top = 0;
      max_location  =  max_location + period;
      
  end
  
   if flag == 1 && peak_count > 1        % To avoid the first peak.
       
     if peak_count == 2  
         if min_bot ~= 0 && (BL - min_bot > pre_peak_value - BL)
             result = 1;
             break
         end
     elseif peak_count == 3
         break
     end
         
        % Update the systolic window.    
      i = i - 1;    % To compensate the extra increments.
      
      for j = i:-1:1
         if S(j) > new_peak_location
             continue
         else
             S = S(j : end);
             S(length(S)+1 : 8) = 0;
             i = length(S) + 1;
             break
         end
      end
      
      % Assign min_bot for previous period to Diastole.
      Diastole = min_bot;
      min_bot = new_peak_value;
      
      % Peak for the wave_bot
      peak_bot = wave_bot(pre_peak_location);
      flag = 0;
      
   end
    
   if (wave_top(c) > BL && wave_top(c-1) <= BL) || (wave_top(c) <= BL && wave_top(c-1) > BL)
       S(i) = c;
       i = i + 1;
   end
      
   % Trough for the wave_bot 
  if wave_bot(c) < min_bot
      min_bot = wave_bot(c);
      min_bot_location = c;      
  end
    
end