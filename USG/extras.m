 % Print the results. In the file also.
      if peak_count == 3
          fileID = fopen('feature_results.txt','a');
          fprintf(fileID,'\n%s%f\n','Acceleration: ',(pre_peak_value - BL)/(pre_peak_location - S(1)));      
          fprintf(fileID,'%s%3.0f\n','Period: ',period);
          fprintf(fileID,'%s%f\n','SBI: ',pre_peak_value - peak_bot);
          fprintf(fileID,'%s%f\n','SDR: ',(pre_peak_value - BL)/(BL - Diastole));
          if BL > Diastole && Diastole ~= 0
              fprintf(fileID,'%s\n', 'Negative Peak:  Present');
          else
              fprintf(fileID,'%s\n', 'Negative Peak:  Absent');
          end
          fclose(fileID);

      end
     