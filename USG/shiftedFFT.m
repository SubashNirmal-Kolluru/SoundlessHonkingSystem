
function outMat = shiftedFFT(inmat,x)
[rows, cols] = size(inmat);

invMat= ifft(inmat);

% zero matrix X for storing shifted inverse FFT
X = zeros(rows, cols-1);

x1 = invMat(x:rows, :);
x2 = invMat(1:x-1, 2:cols);

for i= 1:cols-1
    X(1:(rows-x+1), i) = x1(:, i);
    X(rows-x+2:end, i) = x2(:, i); 
end
outMat = fft(X);
outMat = Uint8(outMat);

