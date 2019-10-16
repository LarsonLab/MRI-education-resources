% y = fftc(x, [N])
% N - zeropad x to this length of fft (optional)
% fft wrt the center of the array, instead of the first sample
% will do ifft along first dimension (columns) if x is an array
%
%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University
  
function y=fftc(x, N)

sx = size(x);
if (sx(1) == 1) | (sx(2) == 1)
  x = x(:);
end

M1 = size(x,1);

if nargin == 1
  N = M1;
end

Nzeros_l = ceil((N-M1)/2); % split zeros on each size of x
Nzeros_r = floor((N-M1)/2); % split zeros on each size of x

y = fftshift(fft(fftshift([zeros(Nzeros_l,size(x,2));x;zeros(Nzeros_r,size(x,2))])));

