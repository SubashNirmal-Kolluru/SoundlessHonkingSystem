function x = Uint8(a)
[row,col] = size(a);
b = abs(a);
for i = 1:col
    x(:,i) = uint8(((b(:,i) - min(b(:,i)))./(max(b(:,i))- min(b(:,i))))*256);
end
