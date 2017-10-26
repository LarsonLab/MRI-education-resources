function [Mend] = bloch_rftip(Mstart, T, B1)
% bloch_rftip - compute the rotation due to RF (B1) on the net magnetization
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B1 - RF amplitude [G]
% OUTPUTS
%   Mend - final magnetization


% eventually need to add off-resonance?