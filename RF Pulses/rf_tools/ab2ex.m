function mxy = ab2ex(a,b);

% mxy = ab2ex(a,b)    -- or --    mxy = ab2ex(ab)
%
% Computes the excitation profile 2*conj(a).b

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

if nargin == 1,
  [m n] = size(a);
  b = a(:,(n/2+1):n);
  a = a(:,1:n/2);
end;

mxy = 2*conj(a).*b;
