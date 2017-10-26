function im = fft2c(d, N)
% im = fft2c(d)
%
% fft2c performs a centered fft2
%
if (nargin < 2)
  im = fftshift(fft2(fftshift(d)));
else
  im = fftshift(fft2(fftshift(d), N, N));
end