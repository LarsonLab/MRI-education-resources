function im = ifftc(d, N)
% im = ifftc(d)
%
% ifftc performs a centered ifft
%
if (nargin < 2)
  im = fftshift(ifft(fftshift(d)));
else
  im = fftshift(ifft(fftshift(d), N));
end