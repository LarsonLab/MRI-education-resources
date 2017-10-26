% RF pulse examples
GAMMA = 4257;

%% illustration of pulse profiles and SLR transform
N = 200;
tbw = 10;
rf = dzrf(N, tbw, 'inv','ls');
T = 6e-3;
dt = T/N;
df = linspace(-2000, 2000, 201);
gf = 2*pi*dt*ones(1,N);
mxyex = ab2ex(abr(rf, gf, df));
mxyse = ab2se(abr(rf,gf,df));
mz = ab2inv(abr(rf, gf, df));

t = [1:N]*dt*1e3;

% SLR:
bsf = sqrt(1/2);
d1 = sqrt(.01/2);
d2 = .01/sqrt(2);

b = dzlp(N,tbw,d1,d2);
a = b2a(b);

B = fftc(b);  A = fftc(a);


figure
subplot(221)
plot(t,real(rfscaleg(rf,T*1e3)))
%ylim([-.05 .1])
xlabel('time (ms)'), ylabel('B1 (G)'), title('RF Pulse')
subplot(222)
plot(df, abs(mxyex), df, abs(mxyse), df, mz)
xlabel('frequency (Hz)')
legend('M_{XY,ex}', 'M_{XY,SE}', 'M_Z')
subplot(223)
plot(t, b/max(b), t, real(a(end:-1:1))/max(real(a)))
xlabel('time (ms)')
legend('b','a'), title('SLR polynomials')
subplot(224)
plot([1:N], abs(B), [1:N], abs(A))
legend('B', 'A'), title('SLR polynomials')

%% illustration of TBW product
rf  = dzrf(N, tbw, 'ex', 'pm');
rf2 = dzrf(N, tbw*2, 'ex', 'pm');

figure
subplot(321)
plot(t,real(rfscaleg(rf,T*1e3)))
xlabel('time (ms)'), ylabel('B1 (G)')
axis([0 6 -.1 .2])
subplot(322)
plot(df, abs(ab2ex(abr(rf, gf, df))))
xlabel('frequency (Hz)'), ylabel('M_{XY}')
subplot(323)
plot(2*t,real(rfscaleg(rf2,2*T*1e3)))
xlabel('time (ms)'), ylabel('B1 (G)')
axis([0 12 -.1 .2])
subplot(324)
plot(df, abs(ab2ex(abr(rf2, 2*gf, df))))
xlabel('frequency (Hz)'), ylabel('M_{XY}')
subplot(325)
plot(t,real(rfscaleg(rf2,T*1e3)))
axis([0 6 -.1 .2])
xlabel('time (ms)'), ylabel('B1 (G)')
subplot(326)
plot(df, abs(ab2ex(abr(rf2, gf, df))))
xlabel('frequency (Hz)'), ylabel('M_{XY}')


%% spectral-spatial profile
slthick = 5;
gamp = (tbw/T) / (GAMMA*slthick/10);

z = linspace(-0.5, 0.5, 201);
gz = 2*pi*GAMMA*dt * gamp * ones(1,N);

df = linspace(-1500, 1500, 201);

% spectral-spatial:
mxy_2d = ab2ex(abr(rf, gz + i*gf, z, df));
mxy_gf = ab2ex(abr(rf, i*gf, z, df));
mxy_gz = ab2ex(abr(rf, gz, z, df));

figure
subplot(311)
imagesc(df,z,abs(mxy_gf))
xlabel('Frequency (Hz)'), ylabel('Position (cm)')
subplot(312)
imagesc(df,z,abs(mxy_2d))
xlim([-500 500])
xlabel('Frequency (Hz)'), ylabel('Position (cm)')
colormap(gray)

subplot(313)

plot(z, abs(mxy_2d(101, :)), z, abs(mxy_2d(81, :)),z, abs(mxy_2d(121, :)))
xlabel('Position (cm)')
ylabel('M_{XY}')
legend('f = 0', ['f = ' num2str(df(81)) 'Hz'], ['f = ' num2str(df(121)) 'Hz'])

