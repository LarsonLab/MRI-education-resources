function Ry = Ry(flip) 
% rotation matrix about the y-axis
% Note these are left-handed rotation matrices for MRI

Ry = [cos(flip)  0 sin(flip); 0 1 0; -sin(flip) 0 cos(flip)];

end
