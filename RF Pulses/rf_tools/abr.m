% abr - compute the Cayley-Klein parameters for the rotation produced
%   by an RF pulse.  Uses Le Roux's convention on beta
%
% [a b] = abr(rf,<g,> x);
%   a, b = Cayley-Klein paramters
%   rf   = n point rf waveform
%   g    = optional gradient waveform
%   x    = vectors of spatial positions to compute a and b.
%
% useful identities:
%   mxy = 2*conj(a).*b);		     selective excitation
%   mz  = 1 - 2*b.*conj(b);	             inversion
%   mxy = i(b.*b);		             spin echo profile
%

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function [a, b] = abr(rf, g, x, y)

l = length(rf);

if nargin == 2,
  x = g;
  g = ones(1,l)*2*pi/l;
end;

if nargin == 4,
    [a b] = abrx(rf, g, x, y);
elseif (nargin==2) || (nargin==3),
    [a b] =  abrx(rf, g, x);
end;

b = -conj(b);
if nargout == 1,
  a = [a b];
end;


