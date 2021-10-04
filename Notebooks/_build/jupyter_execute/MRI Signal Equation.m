% setup MRI-education-resources path and requirements
cd ../
startup

% Example of k-space trajectory time weighting functions, upsilon

% Cartesian

% kx(t)  = gammabar Gxr (t-TE)
% upsilon(k) = t = kx/gamma*Gxr + TE

gamma = 42.58; %kHz/mT
N = 32;
dt = 0.1; % ms
TE = 5; % ms
t = [-N/2+1:N/2]*dt;

Gxr = 1/(N*dt*gamma);

kx0 = gamma*Gxr* t;
[kx ky] = meshgrid(kx0,kx0);

upsilon_Cartesian = kx / (gamma*Gxr) + TE; 

% more simply, upsilon is time to readout single line of k-space
%upsilon = repmat(t + TE, [1 N]);

figure
mesh(kx, ky, upsilon_Cartesian)
xlabel('k_x'), ylabel('k_y')
title('Cartesian time weighting, \upsilon(k)')

% EPI

% add ky weighting as
% ky(t) = tesp * dky
tesp = N*dt; % simplified, assuming no deadtime between ky lines
TE = 5 + tesp*N/2;
% time for all data acquisition
tall = [-N^2/2+1:N^2/2]*dt + TE;

upsilon_EPI = reshape(tall, [N N]).'; 

figure
mesh(kx, ky, upsilon_EPI)
xlabel('k_x'), ylabel('k_y')
title('Echo-planar time weighting, \upsilon(k)')



% Convolution kernels for T2* weighting

T2s = 100; % ms

W_Cartesian = ifft2c(exp(-upsilon_Cartesian/T2s));
W_EPI = ifft2c(exp(-upsilon_EPI/T2s));

x0 = [-N/2:N/2-1];
[x y ] = meshgrid(x0,x0);
figure
subplot(121)
mesh(x,y,abs(W_Cartesian))
xlabel('k_x'), ylabel('k_y')
title(['Cartesian convolution kernel, T_2^* =' int2str(T2s) ' ms'])
subplot(122)
mesh(x,y,abs(W_EPI))
xlabel('k_x'), ylabel('k_y')
title(['EPI convolution kernel, T_2^* =' int2str(T2s) ' ms'])

T2s = 10; % ms

W_Cartesian = ifft2c(exp(-upsilon_Cartesian/T2s));
W_EPI = ifft2c(exp(-upsilon_EPI/T2s));

figure
subplot(121)
mesh(x,y,abs(W_Cartesian))
xlabel('x'), ylabel('y')
title(['Cartesian convolution kernel, T_2^* =' int2str(T2s) ' ms'])
subplot(122)
mesh(x,y,abs(W_EPI))
xlabel('x'), ylabel('y')
title(['EPI convolution kernel, T_2^* =' int2str(T2s) ' ms'])

% Convolution kernels for off-resonance weighting

df = 1/(N*tesp); % kHz

W_Cartesian = ifft2c(exp(-i*2*pi*df*upsilon_Cartesian));
W_EPI = ifft2c(exp(-i*2*pi*df*upsilon_EPI));

x0 = [-N/2:N/2-1];
[x y ] = meshgrid(x0,x0);
figure
subplot(121)
mesh(x,y,abs(W_Cartesian))
xlabel('k_x'), ylabel('k_y')
title(['Cartesian convolution kernel, \Delta f =' int2str(df*1e3) ' Hz'])
subplot(122)
mesh(x,y,abs(W_EPI))
xlabel('k_x'), ylabel('k_y')
title(['EPI convolution kernel, \Delta f=' int2str(df*1e3) ' Hz'])

df = 10/(N*tesp); % kHz

W_Cartesian = ifft2c(exp(-i*2*pi*df*upsilon_Cartesian));
W_EPI = ifft2c(exp(-i*2*pi*df*upsilon_EPI));

figure
subplot(121)
mesh(x,y,abs(W_Cartesian))
xlabel('x'), ylabel('y')
title(['Cartesian convolution kernel, \Delta f =' int2str(df*1e3) ' Hz'])
subplot(122)
mesh(x,y,abs(W_EPI))
xlabel('x'), ylabel('y')
title(['EPI convolution kernel, \Delta f =' int2str(df*1e3) ' Hz'])


