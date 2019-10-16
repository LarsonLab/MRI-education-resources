% mxy = ab2se(a,b)    -- or --    mxy = ab2se(ab)
%
% Computes the "straight through" term a.*a
 
%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University
 
function mxy = ab2st(a,b);
 
if nargin == 2,
  mxy = i*a.*a;
elseif nargin == 1,
  mxy = i*a(:,1).*a(:,1);
else
  ab2xx
end
 
