function S = MRsignal_spoiled_gradient_echo(flip, TE, TR, M0, T1, T2)
% S = MRsignal_spoiled_gradient_echo(flip, TE, TR, M0, T1, T2)
%   Simulates the MRI signal in an spoiled gradient echo pulse sequence

E1 = exp(-TR./T1);
S = M0 .* sin(flip) .* exp(-TE/T2) .* (1-E1) ./ (1-E1*cos(flip)); 