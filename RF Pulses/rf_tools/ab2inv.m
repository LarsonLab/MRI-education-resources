% mz = ab2inv(a,b)    -- or --    mz = ab2inv(ab)
%
% Computes the inversion profile 1-2*b.*conj(b)

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function mz = ab2inv(a,b);

if nargin == 1, 
  [m n] = size(a);
  b = a(:,(n/2+1):n);
  a = a(:,1:n/2);
end;
  
mz = 1-2*conj(b).*b;
