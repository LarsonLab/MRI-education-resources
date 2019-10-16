% mxy = ab2se(a,b)    -- or --    mxy = ab2se(ab)
%
% Computes the spin-echo profile i*b.*b

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function mxy = ab2se(a,b);

if nargin == 1,
  [m n] = size(a);
  b = a(:,(n/2+1):n);
  a = a(:,1:n/2);
end

mxy = i*b.*b;