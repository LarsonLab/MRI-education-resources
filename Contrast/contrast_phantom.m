% Simulate a phantom setup with three circular regions, each with
% different T1/T2 values
addpath ../Utilities/

Nphan = 3;
% phantom parameters
xc = [-.3 0 .3]*256;  % x centers
yc = [-.25 .25 -.25]*256;  % y centers
T1 = [.5 .5 3];  % T1 relaxation times (s)
T2 = [.02 .05 .1];  % T2 relaxation times (s)
r = 1/64;  % ball radius, where FOV = 1

N = 256;

% matrices with kx, ky coordinates
[kx ky] = meshgrid([-N/2:N/2-1]/N);

% initialize k-space data matrix
M = zeros(N,N);

% Generate k-space data by adding together k-space data for each
% individual phantom
    % Note that this does not take into account the T1 and T2 relaxation
    % rates for this phantom, T1(n) and T2(n)

for n= 1:Nphan
    % Generates data using Fourier Transform of a circle (jinc) multiplied by complex exponential to shift center location
    M = M+jinc(sqrt(kx.^2 + ky.^2) / (r) ) .* exp(i*2*pi* (kx*xc(n) + ky*yc(n)));


end

% reconstruct and display ideal image
m = ifft2c(M);
imagesc(abs(m)), colormap(gray), axis equal tight



