function rfs = rfscaleg(rf, pulseduration, GAMMA)
% RFSCALEG Converts a normalized RF waveform to Gauss
%   RF_G = RFSCALEG(RF, PW, [GAMMA])
% Inputs:
%   RF - scaled to sum to the desired flip angle in radians
%   PW - Pulse duration in ms
%   GAMMA (optional) - Gyromagnetic ratio in Hz/G
%          default is 4257 for protons
% Outputs:
%   RF_G - rf pulse scaled to Gauss
%
% Peder Larson 10/6/04, updated 8/15/07

if (nargin < 3)
    GAMMA = 4258; % Hz/G
end

rfs = rf*length(rf)/(2*pi*GAMMA*pulseduration*1e-3);