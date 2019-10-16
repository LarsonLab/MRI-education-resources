% dzmp -- design a minimum phase filter by first designing a linear phase
%         filter and factoring it into two terms
%
%  function h = dzmp(n,tb,d1,d2)
%
%  inputs
%    n  - filter length
%    tb - time-bandwidth product
%    d1 - passband ripple
%    d2 - stopband ripple
%
%  outputs
%    h - minimum phase equal-ripple filter
%
%  requires
%    fmp, mag2mp
%

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function h = dzmp(n,tb,d1,d2)

n2 = 2*n-1;
di = 0.5*dinf(2*d1,0.5*d2.*d2);
w = di/tb;
f = [0 (1-w)*(tb/2) (1+w)*(tb/2) (n/2)]/(n/2);;
m = [1 1 0 0];
w = [1 2*d1/(0.5*d2*d2)];
hl = firpm(n2-1,f,m,w);
h = fmp(hl);

