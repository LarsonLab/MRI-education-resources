function Rz = Rz(flip) 
% rotation matrix about the z-axis
% Note these are left-handed rotation matrices for MRI

Rz = [cos(flip) -sin(flip) 0; sin(flip) cos(flip) 0; 0 0 1];

end
