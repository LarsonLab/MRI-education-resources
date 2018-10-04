function Mend = spoil_magnetization(Mstart)
% spoil the transverse magnetization.
Mend = Mstart;
Mend(1:end-1,:) = 0;

end