function opWave = Smoothen(inpWave)
   [rows,cols] = size(inpWave);
   opWave = zeros(rows,cols);
   %Smoothened Waveforms
   for r = 1:rows
       for c = 2:cols-1
           count = (inpWave(r,c-1)~=0)+ (inpWave(r,c)~=0) +(inpWave(r,c+1)~=0);
           opWave(r,c) = (inpWave(r,c-1)+inpWave(r,c)+inpWave(r,c+1))/count;
       end
   end
end