function [Mend] = bloch_rotate(Mstart, T, B)
% bloch_rotate - compute the rotation of the net magnetization for a given magnetic field
%
% INPUTS
%	Mstart - initial magnetization
%	T - duration [ms]
%	B = [Bx, By, Bz] - magnetic field [G]
% OUTPUTS
%   Mend - final magnetization

xi = pi/2;

theta = atan()

Rx2 = [cos(alpha2) sin(alpha2) 0; -sin(alpha2) cos(alpha2) 0; 0 0 1];
Ry2 = [cos(-xi) 0 -sin(-xi); 0 1 0; sin(-xi) 0 cos(-xi)];
Rz3 = [cos(-theta) sin(-theta) 0; -sin(-theta) cos(-theta) 0; 0 0 1];
%??

theta = -117*pi/180;  % need to negate for left-handed rotation
phi = (133)*pi/180;
ux = cos(phi); uy= sin(phi); uz = 0;

R = [cos(theta) + ux^2 * (1-cos(theta)), ux*uy*(1-cos(theta)) - uz*sin(theta), ux*uz *(1-cos(theta)) + uy*sin(theta); ...
    ux*uy *(1-cos(theta)) + uz*sin(theta), cos(theta)+uy^2 *(1-cos(theta)), uy*uz*(1-cos(theta)) - ux*sin(theta); ...
    ux*uz *(1-cos(theta)) - uy*sin(theta), uz*uy *(1-cos(theta)) + ux*sin(theta), cos(theta)+uz^2 *(1-cos(theta))]
