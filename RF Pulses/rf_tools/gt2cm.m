%
%  Takes dimensionless x used by abr, and scales it to cm based
%  on a gradient strength g (G/cm) and pulse duration t (ms)
%
%   xs = gt2cm(x,g,t)
%
%     x  -- normalized frequency x vector used by abr
%     g  -- Gradient strength, G/cm
%     t  -- pulse duration in ms
%
%     xs -- scaled spatial axis, in cm
%

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

function xs = gt2cm(x,g,t)

xs = x/(4.257*g*t);
