function y = ifftc(x, N)
% y = ifftc(x, [N])
% N - length of ifft (optional)
% ifftc performs a centered ifft
% will do ifft along first dimension (columns) if x is an array
% 
sx = size(x);
if (length(sx) == 1)
  x = x(:);
end

M1 = size(x,1);

if nargin == 1
  N = M1;
end

Nzeros = round((N-M1)/2); % split zeros on each size of x
y = fftshift(ifft(fftshift([zeros(Nzeros,size(x,2));x;zeros(Nzeros,size(x,2))])));
