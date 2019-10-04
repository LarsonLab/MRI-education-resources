function [Mend] = bloch_rotate(Mstart, T, B)
% bloch_rotate - compute the rotation of the net magnetization for a given magnetic field
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B = [Bx, By, Bz] - magnetic field [mT]
% OUTPUTS
%   Mend - final magnetization
%
% T and B can also be in units of [us] and [T], respectively

GAMMA = 42.58; % kHz/mT

flip = 2*pi*GAMMA * norm(B) * T;

eta = acos(B(3) / (norm(B)+eps));

theta = atan2(B(2), B(1));

Mend = Rz(-theta)*Ry(-eta)*Rz(flip)*Ry(eta)*Rz(theta)* Mstart;

end

