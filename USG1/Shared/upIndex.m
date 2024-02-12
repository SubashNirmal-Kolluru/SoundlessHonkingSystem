% algorithm for finding the index of the point of the upper feature for the
% column. 'bool' is the array of datapoints after comparison with
% threshold. 'n' is the window size.

function index = upIndex(bool)

i = 1;
low_conseq = 0;   % consecutive 0's
index = 0;
highs = 0;
n= length(bool);
while(i<n+1 && bool(i) == 0)
    i = i+1;
end

if i<n+1
    index = i;
    net = 1;
    if ( i+2<n+1 && bool(i+1) == 0 && bool(i+2) ==1)
        index = index +1;
    end
    if i+1<n+1
        i = i+1;
    end
    while(i<n+1)
       if (net>0 && low_conseq <3)
          if bool(i)==1
              net = net+1;
              low_conseq = 0;
          else 
              low_conseq = low_conseq + 1;
              net = net -1;
          end
       else
           while(i<n+1 && bool(i) == 0)
               i = i+1;
           end
           if i+1<n+1
               index_2 = i;
           end
           while(i<n+1)
               if bool(i) == 1;
                   highs = highs + 1;
               end
               i = i+1;
           end
       end
       i = i+1;
    end
end

if highs>2
    index= index_2;
end

end