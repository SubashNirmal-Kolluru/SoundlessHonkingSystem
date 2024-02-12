% Input the absolution AHT matrix.
function thr = threshold(inpMat, BL, percent)

total = 0;
for i = BL - 10  : BL - 5
    total = total + double(max(inpMat(i,:)));   
    
end

thr = percent*total/6;
end

