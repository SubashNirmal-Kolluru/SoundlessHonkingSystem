function output = features(waves, sep, thr, BL )

wave_top = waves(1,:);
wave_bot = waves(2,:);
flag = 1;

[period, peak_value, peak_location] = data(wave_top);

len = length(wave_top);
max_top = 0;      
max_location = peak_location + period;   % start with a big value.
S = zeros(1,16);   % S is the array of points corrosponding to systolic window.
i = 1 ;           % array initializing. 
output = zeros(1,7);            % Will increase the length 

peak_count = 0; 
min_bot  =  peak_value;
min_bot_location = 0;
pre_peak_location = peak_value;
pre_peak_value = peak_location;
new_peak_location = peak_location;
new_peak_value = peak_value;

% Write the results in the file.

for c = peak_location : len

  % Define new_period_location as the column at which the
  %(1 - thr/2)*peak_value   < wave_top(c)< (1 + thr/2)*peak_value and it is
  % the maximum value in vicinity. 
  if (wave_top(c) < (1 + thr)*peak_value && wave_top(c) > (1 - thr)*peak_value)
      
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
       % Ouput the features concerning the systolic window.

       for j = 2: length(S)
           
          if S(j) > pre_peak_location
%               pre_peak_value            % debug
%               pre_peak_location
%               S(1)
              if peak_count == 3
                  
                  decel = (pre_peak_value - BL)/(S(j) - pre_peak_location );
                  output(1) = decel;
                  fprintf('\n%s%f\n','Deceleration: ',decel);
                  sys_window = (S(j) - S(1))*1.15;
                  output(2) = sys_window;
                  fprintf('%s%f\n','Systolic Winodow:', sys_window);
                  break     
              end
          else
              continue
          end
       end
      
      % Assign min_bot for previous period to Diastole.
      Diastole = min_bot;
      min_bot = new_peak_value;
      
      % Peak for the wave_bot
      peak_bot = wave_bot(pre_peak_location);
      flag = 0;
      
      
%       fprintf('\n\n%s%d\n','Features for peak No:     ',peak_count - 1);
      accel = (pre_peak_value - BL)/(pre_peak_location - S(1));
      SBI = (pre_peak_value - peak_bot)/pre_peak_value;
      SDR = (pre_peak_value - BL)/(BL - Diastole);
      fprintf('\n%s%f\n','Acceleration: ',accel);   
      fprintf('%s%3.0f\n','Period: ',period);
      fprintf('%s%f\n','SBI: ',SBI);
      fprintf('%s%f\n','SDR: ',SDR);
      if peak_count ==3
          output(3) = accel;
          output(4) = period;
          output(5) = SBI;
          output(6) = SDR;
      end
      if BL > Diastole && Diastole ~= 0
          fprintf('%s\n', 'Negative Peak:  Present');
          if peak_count == 3
            output(7) = 1;    
          end
      else
          fprintf('%s\n\n', 'Negative Peak:  Absent');
          if peak_count == 3
             output(7) = 0;
          end
      end
      
        % Update the systolic window.    
%       i = i - 1;
      for j = i:-1:1
          
         if S(j) < new_peak_location && S(j) ~= 0
             i = i -( j - 1);   
             S = S(j : end);
             S(length(S)+1 : 16) = 0;
             break
         end
      end
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