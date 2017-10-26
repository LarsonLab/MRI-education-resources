% spectral-spatial RF pulse design

%%
GAMMA = 4257; % Hz/G

slewmax = 15e3; % G/cm/s
gmax = 4; % G/cm
T = 20e-3; % ms
TBW = 3;
SBW = 6;
dz = 0.5; % cm, max spatial resolution
Nspec = 10;
DT = T/Nspec;
dt = 10e-6; % us
flip = pi/4;

%%
gamp = (SBW/DT)/(GAMMA*dz); % gradient for spatial resolution

rfspec = dzrf(Nspec, TBW);

verse_frac = 0.8;
Nlobe = DT/dt;
Nspat = round(Nlobe * verse_frac);
Nwait = (Nlobe - Nspat)/2;
rfspat = dzrf(Nspat, SBW);

% Uses a slew rate that can't be violated
% IE gamp = gmax would be ok (so can change slice thickness on console)
Nramp = min( ceil(gmax/slewmax / dt), floor(Nlobe/2));
ramp = [.5:Nramp-.5]/Nramp;
g1 = [ramp, ones(1,Nlobe-2*Nramp), ramp(end:-1:1)]; 
rfspatv = verse(g1, [zeros(1, floor(Nwait)), rfspat, zeros(1,ceil(Nwait))]).';
  
rf = []; g = [];
for k = 1:Nspec
   rf = [rf, rfspatv*rfspec(k)];
   g = [g, (mod(k,2)*2 - 1)*gamp*g1];
end

Nrw = round((Nlobe - Nramp)/2 + Nramp);
grw = [ramp, ones(1,Nrw-2*Nramp), ramp(end:-1:1)];

g = [g, (mod(Nspec+1,2)*2-1)*gamp*grw];
rf = [rf, zeros(1,Nrw)];

flip_scale = flip/sum(rf);
rf = flip_scale*rf;
rfs = rfscaleg(rf, T);

%%
z = linspace(-0.8, 0.8, 201);
gz = 2*pi*GAMMA*dt * g;

df = linspace(-500, 500, 201);
gf = 2*pi*dt * ones(1,length(rf));

mxy_z = ab2ex(abr(rf, gz, z));
mxy_f = ab2ex(abr(rf, gf, df));
mxy_2d = ab2ex(abr(rf, gz + i*gf, z, df));


%%
figure
subplot(421)
plot([0:Nspec-1]*DT*1e3, real(rfspec), '-x')
ylabel('RF')
title('Spectral Pulse Design')
subplot(423)
plot([0:Nspec-1]*DT*1e3, ones(1,Nspec))
ylabel('G_f')
xlabel('Time (ms)')
subplot(222)
plot(df, abs(mxy_f))
xlabel('Frequency (Hz)'), ylabel('M_{XY}')
title('Spectral Profile (z=0)')

subplot(425)
plot([0:Nlobe-1]*dt*1e3, real(rfspatv))
ylabel('RF')
title('Spatial Pulse Design')

subplot(427)
plot([0:Nlobe-1]*dt*1e3, gamp*g1)
ylabel('G_z')
xlabel('Time (ms)')
subplot(224)
plot(z, abs(mxy_z))
xlabel('Position (cm)'), ylabel('M_{XY}')
title('Spatial Profile (f=0)')


figure
subplot(421)
plot([0:length(rf)-1]*dt*1e3, real(rf), ...
    [0.5:1:Nspec-0.5]*DT*1e3, real(rfspec)/max(real(rfspec)) * max(real(rf)), '--')
ylabel('RF')
title('Spectral-Spatial RF Pulse')
subplot(423)
plot([0:length(rf)-1]*dt*1e3, g)
ylabel('G_z')
xlabel('Time (ms)')

subplot(222)
plot([0:length(rf)-1]*dt*1e3, GAMMA*dt*(cumsum(g) - sum(g)))
xlabel('k_f = t'), ylabel('k_z')
title('k-space trajectory')

subplot(223)
plot3([0:length(rf)-1]*dt*1e3, GAMMA*dt*(cumsum(g) - sum(g)), real(rf))
xlabel('k_f = t'), ylabel('k_z')
title('B_1(k)')

subplot(224)
imagesc(df,z,abs(mxy_2d))
xlabel('Frequency (Hz)'), ylabel('Position (cm)')
title('Spectral-spatial Profile')
colormap(gray)

return
%% true-null design

rfspec = rfspec .* exp(i*pi*[1:length(rfspec)]);

rf = []; g = [];
for k = 1:Nspec
   rf = [rf, rfspatv*rfspec(k)];
   g = [g, (mod(k,2)*2 - 1)*gamp*g1];
end

g = [g, (mod(Nspec+1,2)*2-1)*gamp*grw];
rf = [rf, zeros(1,Nrw)];

rf = flip_scale*rf;
rfs = rfscaleg(rf, T);

%%

mxy_z = ab2ex(abr(rf, gz, z));
mxy_f = ab2ex(abr(rf, gf, df));
mxy_2d = ab2ex(abr(rf, gz + i*gf, z, df));


%%
figure
subplot(421)
plot([0:Nspec-1]*DT*1e3, real(rfspec), '-x')
ylabel('RF')
title('Spectral Pulse Design')
subplot(423)
plot([0:Nspec-1]*DT*1e3, ones(1,Nspec))
ylabel('G_f')
xlabel('Time (ms)')
subplot(222)
plot(df, abs(mxy_f))
xlabel('Frequency (Hz)'), ylabel('M_{XY}')
title('Spectral Profile (z=0)')

subplot(425)
plot([0:Nlobe-1]*dt*1e3, real(rfspatv))
ylabel('RF')
title('Spatial Pulse Design')

subplot(427)
plot([0:Nlobe-1]*dt*1e3, gamp*g1)
ylabel('G_z')
xlabel('Time (ms)')
subplot(224)
plot(z, abs(mxy_z))
xlabel('Position (cm)'), ylabel('M_{XY}')
title('Spatial Profile (f=0)')


figure
subplot(421)
plot([0:length(rf)-1]*dt*1e3, real(rf), ...
    [0.5:1:Nspec-0.5]*DT*1e3, real(rfspec)/max(real(rfspec)) * max(real(rf)), '--')
ylabel('RF')
title('Spectral-Spatial RF Pulse')
subplot(423)
plot([0:length(rf)-1]*dt*1e3, g)
ylabel('G_z')
xlabel('Time (ms)')

subplot(222)
plot([0:length(rf)-1]*dt*1e3, GAMMA*dt*(cumsum(g) - sum(g)))
xlabel('k_f = t'), ylabel('k_z')
title('k-space trajectory')

subplot(223)
plot3([0:length(rf)-1]*dt*1e3, GAMMA*dt*(cumsum(g) - sum(g)), real(rf))
xlabel('k_f = t'), ylabel('k_z')
title('B_1(k)')

subplot(224)
imagesc(df,z,abs(mxy_2d))
xlabel('Frequency (Hz)'), ylabel('Position (cm)')
title('Spectral-spatial Profile')
colormap(gray)
