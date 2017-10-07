% Simulate a phantom setup with three circular regions, each with
% different T1/T2 values

Nphan = 3;
% phantom parameters
xc = [-.3 0 .3]*256;  % x centers
yc = [-.25 .25 -.25]*256;  % y centers
T1 = [.5 .5 3];  % T1 relaxation times (s)
T2 = [.02 .05 .1];  % T2 relaxation times (s)
r = 1/64;  % ball radius

% matrices with kx, ky coordinates
[kx ky] = meshgrid([-128:127]/256);

% initialize k-space data matrix
M = zeros(256,256);

% Generate k-space data
for n= 1:Nphan
    % Generates data using Fourier Transform of a circle (jinc) multiplied by complex exponential to shift center location
    M = M+jinc(sqrt(kx.^2 + ky.^2) / (r) ) .* exp(i*2*pi* (kx*xc(n) + ky*yc(n)));
end

% reconstruct and display image
m = ifft2c(M);
imagesc(abs(m)), colormap(gray), axis equal tight



