function rfs = rfscale(rf,t)

% takes an RF waveform and scales it to kHz if played for time
% t (ms).  Signa can handle at most 1 kHz.  700 Hz is better,
% and 500 Hz seems to be what product psd's use.

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

rfs = rf*length(rf)/(2*pi*t);


