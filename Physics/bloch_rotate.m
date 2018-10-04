function [Mend] = bloch_rotate(Mstart, T, B)
% bloch_rotate - compute the rotation of the net magnetization for a given magnetic field
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B = [Bx, By, Bz] - magnetic field [G]
% OUTPUTS
%   Mend - final magnetization

GAMMA = 4.257; % kHz/G

flip = 2*pi*GAMMA * norm(B) * T;

eta = acos(B(3) / norm(B));

theta = atan2(B(2), B(1));

Mend = Rz(-theta)*Ry(-eta)*Rz(flip)*Ry(eta)*Rz(theta)* Mstart;

end

