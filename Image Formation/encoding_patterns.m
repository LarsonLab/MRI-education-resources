x = [-128:127]/256;
data = zeros(256,256);
data(129,129) = 256;
%data(139,139) = 256;
k = ifft2c(data);

subplot(211), imagesc(x,x,real(k),[-1 1]), xlabel('x'), ylabel('y'), title('M_X'), colorbar
subplot(212), imagesc(x,x,imag(k),[-1 1]), xlabel('x'), ylabel('y'), title('M_Y'), colorbar

return
%%

N = 256;
I = [N/2+1, N/2+1];
I = round([N/2-N/2.6 N/2+1]);
kout = zeros(N,N);
kout(I(1), I(2)) = 1;
imout = ifft2c(kout);
figure(3)
imagesc(real(imout)), axis equal off
pngwrite(real(imout), sprintf('image_frequency_%.2f_%.2f', I(1)/N-.5, I(2)/N-.5), [-1/N 1/N])
