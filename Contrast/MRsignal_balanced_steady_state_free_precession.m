function S = MRsignal_balanced_steady_state_free_precession(flip, TE, TR, M0, T1, T2)
% S = MRsignal_balanced_steady_state_free_precession(flip, TE, TR, M0, T1, T2)
%   Simulates the MRI signal in a balanced steady-state free-precession
%   (bSSFP) sequence
%   Typically TE = TR/2
%   flip in radians

% Reference: Haacke E, Brown R, Thompson M, Venkatesan R. Magnetic resonance imaging: physical principles and sequence design. Wiley; 1999.

E1 = exp(-TR./T1);
E2 = exp(-TR./T2);
S = M0 .* sin(flip) .* (1-E1) ./ (1-(E1-E2).*cos(flip) - E1.*E2)  .* exp(-TE./T2); 