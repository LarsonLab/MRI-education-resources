function S = MRsignal_inversion_recovery(TE, TI, TR, M0, T1, T2)
% S = MRsignal_inversion_recovery(TE, TI, TR, M0, T1, T2)
%   Simulates the MRI signal in an inversion recovery pulse sequence

S = M0 .* (1 - 2*exp(-TI./T1) + exp(-TR./T1) ) * exp(-TE./T2);