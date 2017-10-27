function [Mend] = bloch_rftip(Mstart, T, B1)
% bloch_rftip - compute the rotation due to RF (B1) on the net magnetization
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B1 - RF amplitude, B1X+iB1Y [G]
% OUTPUTS
%   Mend - final magnetization


Mend = bloch_rotate(Mstart, T, [real(B1) imag(B1), 0]);