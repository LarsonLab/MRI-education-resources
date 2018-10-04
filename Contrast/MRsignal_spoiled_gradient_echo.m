function S = MRsignal_spoiled_gradient_echo(flip, TE, TR, M0, T1, T2)

E1 = exp(-TR./T1);
S = M0 .* sin(flip) .* exp(-TE/T2) .* (1-E1) ./ (1-E1*cos(flip)); 