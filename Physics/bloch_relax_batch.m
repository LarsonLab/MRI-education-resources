function [Mend] = bloch_relax_batch(Mstart, Ts, M0, T1, T2)
% bloch_relax_batch - compute the effect of relaxation on the net magnetization
%                     on a batch of timepoints. 
%
% INPUTS
%	Mstart - initial magnetization
%	Ts - time points [ms]
%	M0 - equilibrium magnetization (default = 1)
%	T1 - longitudinal relaxation time [ms]
%	T2 - transverse relaxation time [ms]
% OUTPUTS
%   Mend - final magnetization

Mx = exp(-Ts/T2) .* Mstart(1);
My = exp(-Ts/T2) .* Mstart(2);
Mz = exp(-Ts/T1) .* Mstart(3) + M0*(1-exp(-Ts/T1));
Mend = cat(1, Mx, My, Mz);