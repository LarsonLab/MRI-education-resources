function Mend = spoil_magnetization(Mstart)
% spoil the transverse magnetization.
% this is idealized spoiling
Mend = Mstart;
Mend(1:end-1,:) = 0;

end