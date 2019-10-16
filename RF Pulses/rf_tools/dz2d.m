% function [rf, g] = dz2d(nt,bw,tbp,ns,mxg,mxs)
%
% Designs a 2D rf pulse with a inward spiral gradient
%
% Inputs:
%    nt  -- number of turns in spiral
%    bw  -- spatial bandwidth, cycles/cm
%    tbp -- "time-bandwdith" product for rf, 
%    ns  -- number of samples
%    mxg -- maximum gradient G/cm
%    mxs -- maximum slew rate G/cm/ms
%
% Outputs:
%    rf  -- rf waveform, scaled to unit area
%    g   -- gx+i*gy, scaled so cumsum(g) == k in cycles/cm
%    Also reports the pulse duration for the specified mxg and mxs
%
% Example: an 8 ms 8 turn spiral
%    [rf g] = dz2d(8,1,4,512,1,2);

% Written by John Pauly, Dec 15, 1993
% (c) Board of Trustees, Leland Stanford Jr. University

function [rf, g] = dz2d(nt,bw,tbp,ns,mxg,mxs)

t = [1:ns]/ns;

% prototype linear spiral
kl = t.*exp(i*2*pi*t*nt)*bw/2;

% amplitude and slew rate limited spiral, reports duration
k = csg(kl,mxg,mxs);

% essentially tau(t) from zero to one
kr = abs(k)/(bw/2);

% jinc RF weighting
rf = besselj(1,kr*pi*tbp/2+0.0001) ./ (kr*pi*tbp/2+0.0001);

% add Gaussian envelope smooth truncation
rf = rf.*exp(-kr.*kr*2);

% gradient waveform
g = diff([0, k]);

% rf weighting compensation
omt = 2*pi*nt;
w = (omt*kr) ./ sqrt(omt*omt*kr.*kr+1);
rf = rf .* w;
rf = rf .* abs(g);

% reverse pulse, scale rf to unity
rf = rf(ns:-1:1);
rf = rf/sum(rf);
g = g(ns:-1:1)*2*pi;


