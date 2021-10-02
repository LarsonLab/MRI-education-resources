% setup MRI-education-resources path and requirements
cd ../
startup

% Sinusoid has a single resonance frequency

dt = 0.002;
tmax = 1;
N = tmax/dt;
t = [1:N]*dt;
% frequency of RF
f0 = 20;

rf_sinusoid = exp(i*2*pi*f0*t);

f = [-N/2:N/2-1]/(N*dt);
% Fourier Transform used to approximate the RF pulse profile (small tip approximation)
FT_sinusoid = fftshift(fft(rf_sinusoid));

subplot(211)
plot(t,real(rf_sinusoid), t,imag(rf_sinusoid), t, abs(rf_sinusoid))
xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')

subplot(212)
plot(f,FT_sinusoid)
title('Frequency profile (Small-tip)')
xlabel('frequency'), ylabel('flip'), xlim([-2*f0 2*f0])

% To excite a slice, we create a RF pulse with a range of frequencies, used while applying magnetic field gradient


dt = 0.002;
tmax = 1;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;
% center frequency of RF
f0 = 20;

% range of frequencies to sum
df = [-5:5];

[tmat dfmat] = meshgrid(t,df+f0);
rf_all = exp(i*2*pi*dfmat.*tmat);

f = [-N/2:N/2-1]/(N*dt);

for n = 1:length(df)
    rf_n = sum(rf_all(1:n,:),1);

    % Fourier Transform used to approximate the RF pulse profile (small tip approximation)
    FT_n = fftshift(fft(rf_n));

    figure
    subplot(211)
    plot(t,real(rf_n), t,imag(rf_n), t, abs(rf_n))
    xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')

    title([int2str(n) ' frequencies in RF'])
    subplot(212)
    plot(f,abs(FT_n))
    title('Frequency profile (Small-tip)')
    xlabel('frequency'), ylabel('flip'), xlim([-2*f0 2*f0])

end


% This sum of sinusoids is a sinc function!


dt = 0.002;
tmax = 1;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;

% frequency of RF
f0 = 20; % center frequency
fwidth = 11; % frequency range
rf_sinc = exp(i*2*pi*f0*t).*sinc(fwidth*(t));

f = [-N/2:N/2-1]/(N*dt);
% Fourier Transform used to approximate the RF pulse profile (small tip approximation)
FT_sinc = fftshift(fft(rf_sinc));

subplot(211)
plot(t,real(rf_sinc), t,imag(rf_sinc), t, abs(rf_sinc))
xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')
subplot(212)
plot(f,abs(FT_sinc))
title('Frequency profile (Small-tip)')
xlabel('frequency'), ylabel('flip'), xlim([-2*f0 2*f0])

% Convert this plot to slice profile with gradient

Gz = .1;
gammabar = 42.58;
z = gammabar*f*Gz;

subplot(211)
plot(t,real(rf_sinc), t,imag(rf_sinc), t, abs(rf_sinc))
xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')
subplot(212)
plot(z,abs(FT_sinc))
title('Frequency profile (Small-tip)')
xlabel('position'), ylabel('flip'), xlim([-2*f0*gammabar*Gz 2*f0*gammabar*Gz])

gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';
dt = 0.1; % ms

flip = 90;

% Hard Pulse
tmax = 1.5;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;
RF = ones(1,N);
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

% B10 = (flip/360) / (gammabar*length(RF)*dt)


BW = 2; % kHz
df = linspace(-BW,BW);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


subplot(211)
plot([t(1)-eps,t,t(end)+eps],[0,RF,0])
xlabel('time (ms)'), ylabel('RF (mT)')
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% Windowed Sinc Pulse
tmax = 8;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;
RF =  hamming(N)' .* sinc(t);
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);


M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% windowed versus non-windowed sinc function

gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';
dt = 0.1; % ms

flip = 60;

tmax = 6;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;

BW = 1; % kHz
df = linspace(-BW,BW);

% Sinc pulse
RF =  sinc(t);
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title('Sinc Pulse')
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% Windowed Sinc Pulse
RF =  hamming(N)' .* sinc(t);
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);


M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title('Windowed Sinc Pulse')
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% Illustration of time-bandwidth product

gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';

flip = 60;
BWplot = 1; % kHz
df = linspace(-BWplot,BWplot);

% Create TBW = 4 pulse shape
TBW = 4;
N = 100;
IN = [-N/2:N/2-1]/N;
RF_shape =  hamming(N)' .*sinc(IN * TBW);

% Trf = 4 ms pulse, TBW = 4, so BWrf = TBW/Trf = 1 kHz
Trf = 4;
t = IN*Trf;
dt = Trf/N;

RF = (flip*pi/180)* RF_shape/sum(RF_shape) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc Pulse, TBW = ' int2str(TBW)])
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')


% Trf = 8 ms pulse, TBW = 4, so BWrf = TBW/Trf = 0.5 kHz
Trf = 8;
t = IN*Trf;
dt = Trf/N;

RF = (flip*pi/180)* RF_shape/sum(RF_shape) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc Pulse, TBW = ' int2str(TBW)])
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')


% Create TBW = 8 pulse shape
TBW = 8;
N = 100;
IN = [-N/2:N/2-1]/N;
RF_shape =  hamming(N)' .*sinc(IN * TBW);

% Trf = 8 ms pulse, TBW = 8, so BWrf = TBW/Trf = 1 kHz
Trf = 8;
t = IN*Trf;
dt = Trf/N;

RF = (flip*pi/180)* RF_shape/sum(RF_shape) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc Pulse, TBW = ' int2str(TBW)])
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')


% Play around with the time-bandwidth product!!
TBW = 4;
Trf = 2;

gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';

flip = 60;
BWplot = 4; % kHz
df = linspace(-BWplot,BWplot);

N = 100;
IN = [-N/2:N/2-1]/N;
RF_shape =  hamming(N)' .*sinc(IN * TBW);

t = IN*Trf;
dt = Trf/N;

RF = (flip*pi/180)* RF_shape/sum(RF_shape) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

figure
subplot(211)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc Pulse, TBW = ' int2str(TBW)])
subplot(212)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'), legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% small tip vs large tip
gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';
dt = 0.1; % ms

tmax = 6;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;

BW = 1; % kHz
df = linspace(-BW,BW);

% Windowed Sinc Pulse
RF =  hamming(N)' .* sinc(t);

flip = 60;
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


subplot(221)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Flip = ' int2str(flip) ' degrees'])
subplot(222)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')


flip = 90;
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

subplot(223)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Flip = ' int2str(flip) ' degrees'])
subplot(224)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')



% Large tip pulse designs
gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';
dt = 0.1; % ms

tmax = 6;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;

BW = 1; % kHz
df = linspace(-BW,BW);

% Windowed Sinc Pulse
RF =  hamming(N)' .* sinc(t);

flip = 90;
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


subplot(221)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc'])
subplot(222)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% Shinnar-Le Roux (SLR) Pulse design
RF = dzrf(N-1, tmax*1, 'ex');
RF = (flip*pi/180)* [0,RF]/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

subplot(223)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['SLR Pulse'])
subplot(224)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')


% Inversion (large-tip) pulses
gammabar = 42.58; % kHz/mT

M0 = 1;
M_equilibrium = [0,0,M0].';
dt = 0.1; % ms

tmax = 6;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;

BW = 1; % kHz
df = linspace(-BW,BW);

% Windowed Sinc Pulse
RF =  hamming(N)' .* sinc(t);

flip = 180;
RF = (flip*pi/180)* RF/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end


subplot(221)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['Windowed Sinc'])
subplot(222)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

% Shinnar-Le Roux (SLR) Pulse design
RF = dzrf(N-1, tmax*1, 'inv');
RF = (flip*pi/180)* [0,RF]/sum(RF) /(2*pi*gammabar*dt);

M = repmat(M_equilibrium, [1, length(df)]);
for n = 1:length(t)
    for f = 1:length(df)
        M(:,f) = bloch_rotate( M(:,f), dt, [real(RF(n)),imag(RF(n)),df(f)/gammabar]);
    end
end

subplot(223)
plot(t,RF)
xlabel('time (ms)'), ylabel('RF (mT)')
title(['SLR Pulse'])
subplot(224)
plot(df,sqrt(M(1,:).^2 + M(2,:).^2), df, M(3,:))
title('Frequency profile')
xlabel('frequency (kHz)'),legend('|M_{XY}|', 'M_Z')%, ylabel('flip')

