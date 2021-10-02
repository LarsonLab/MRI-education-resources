x = linspace(-2,2);
rect = ones(size(x));
rect(abs(x) > 0.5) = 0;
rect(abs(x) == 0.5) = 0.5;

plot(x,rect, 'LineWidth',4)
xlabel('x')
title('rect(x)')

x = linspace(-6,6);

plot(x,sinc(x), 'LineWidth',4)
xlabel('x')
title('sinc(x)')

% Illustrate Fourier decomposition of a rect function (could illustrate ringing)

N = 512;
kxmax = 128;
kx = [-N/2:N/2-1]/N * kxmax*2;

x = [-N/2:N/2-1]/N /(2*kxmax);

for kxmax_truncate = [4 8 16 32 64 128];

F = sinc(kx);
F(find(abs(kx)>kxmax_truncate)) = 0;

f = fftshift(ifft(ifftshift(F)));
figure
plot(x,real(f), x, imag(f))
title(['Truncation of sinc at ' num2str(kxmax_truncate)])
end


