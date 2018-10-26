function [Mall] = bloch_simulation(Mstart, dt, B1, G, M0, T1, T2, r, df)
% bloch_simulation - compute Bloch simulation for a pulse sequence
%
% INPUTS
%	Mstart - initial magnetization
%	dt - time step between points in B1 and G [ms] 
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
	Mtemp2 = bloch_rotate(Mtemp1, dt, [real(B1(It)), imag(B1(It)), G(:,It)'*r + df]);

	% then relax
	Mall(:,It) = bloch_relax(Mtemp2, dt, M0, T1, T2);

end


