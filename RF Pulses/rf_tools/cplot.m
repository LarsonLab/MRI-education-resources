%
% cplot([x,] y) - plot complex function; optional specification of x-axis
%

%  written by John Pauly, 1989
%  modified by Peder Larson, 2006
%  (c) Board of Trustees, Leland Stanford Junior University

function  cplot(x,y,s)

if nargin == 1
  y = x;
  l = length(x);
  x = [1:l]/(l+1);
end
  
if nargin < 3
    plot(x,real(y),x,imag(y));
elseif nargin == 3
    plot(x,real(y),s,x,imag(y),s);
end


