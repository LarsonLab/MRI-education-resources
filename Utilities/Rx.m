function Rx = Rx(flip) 
% rotation matrix about the x-axis
% Note these are left-handed rotation matrices for MRI

Rx = [1 0 0; 0 cos(flip)  sin(flip); 0 -sin(flip)  cos(flip)];

end
