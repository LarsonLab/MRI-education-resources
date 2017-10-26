function im = ifft2c(d, N)
% im = ifft2c(d, N)
%
% ifft2c performs a centered ifft2
%
if (nargin < 2)
  im = fftshift(ifft2(fftshift(d)));
else
  im = fftshift(ifft2(fftshift(d), N, N));
end  
