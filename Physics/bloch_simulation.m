function [Mall] = bloch_simulation(Mstart, T, B1, G, M0, T1, T2, df)
% bloch_simulation - compute Bloch simulation
%
% INPUTS
%	Mstart - initial magnetization
%	T - time vector [ms]  dt - time step between points in B1 and G [ms] 
%	B1 - RF vector, B1X + i B1Y [G], defined at each time point in T
%	G - Gradient field vector [G/cm], defined for Gx,Gy, and Gz at each time point in T
%	M0 - equilibrium magnetization (default = 1)
%	T1 - longitudinal relaxation time [ms]
%	T2 - transverse relaxation time [ms]
%	r - positions at which to evaluate simulation [cm]  (JUST POSITION)
%	df - off-resonance frequencies to evaluate simulation [kHz] (JUST one off-resonance
% OUTPUTS
%   Mall - magnetization


Nt = length(B1);
Mall = zeros(3,Nt);

for It = 1:Nt
	if It == 1
		Mtemp1 = Mstart;
	else
		Mtemp1 = Mall(:, It-1);
	end
	
	% rotate first
	Mtemp2 = bloch_rotate(Mtemp1, dt, [real(B1(It)), imag(B1(It)), G(:,It).*r + df])

	% the relax
	Mall(:,It) = bloch_relax(Mtemp1, dt, M0, T1, T2)

end





Nt = length(T);
Mall = zeros(3,Nt);
Mall(:,1) = Mstart;

for It = 1:Nt-1
	dt = T(It+1)-T(It);
	% RF first
	Mtemp1 = bloch_rftip(Mstart, dt, B1(It));  % df
	% off-resonance
	Mtemp2 = bloch_rotate(Mtemp1, dt, df + G.*r)

	% rotate first
	Mtemp1 = bloch_rotate(Mstart, dt, [B1X, B1Y, df + G.*r])

	% the relax
	Mall(:,It+1) = bloch_relax(Mtemp1, dt, M0, T1, T2)

end


