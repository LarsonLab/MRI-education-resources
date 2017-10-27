function [Mend] = bloch_rotate(Mstart, T, B)
% bloch_rotate - compute the rotation of the net magnetization for a given magnetic field
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B = [Bx, By, Bz] - magnetic field [G]
% OUTPUTS
%   Mend - final magnetization

%% UNTESTED
GAMMA = 4.257; % kHz/G

flip = 2*pi*GAMMA * norm(B) * T;

eta = acos(B(3) / norm(B));

theta = atan2(B(2), B(1));

Mend = Rz(-theta)*Ry(-eta)*Rz(flip)*Ry(eta)*Rz(theta)* Mstart;

end


function Rx = Rx(flip) 

Rx = [1 0 0; 0 cos(flip)  -sin(flip); 0 sin(flip)  cos(flip)];

end

function Ry = Ry(flip) 

Ry = [cos(flip)  0 -sin(flip); 0 1 0; sin(flip) 0 cos(flip)];

end

function Rz = Rz(flip) 

Rz = [cos(flip) sin(flip) 0; -sin(flip) cos(flip) 0; 0 0 1];

end