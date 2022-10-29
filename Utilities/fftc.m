function im = fftc(d, N)
% im = fftc(d)
%
% fftc performs a centered fft
%
if (nargin < 2)
  im = fftshift(fft(fftshift(d)));
else
  im = fftshift(fft(fftshift(d), N));
end