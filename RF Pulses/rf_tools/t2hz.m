%
%  Takes dimensionless x used by abr, and scales it to kHz based
%  on pulse duration t (ms), using a particularly mysterious algorithm.
%
%   fs = t2hz(x,t)
%
%     x  -- normalized frequency x vector used by abr
%     t  -- pulse duration in ms
%
%     fs -- scaled frequency axis, in kHz
%

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function fs = t2hz(x,t)

fs = x/t;
