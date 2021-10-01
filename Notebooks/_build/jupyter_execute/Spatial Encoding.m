% simulate frequency encoding
N = 8;
Mxy= ones(N+1,N+1);

x = [-N/2:N/2];
[x,y] = meshgrid(x,x);
Splot = 0.5;

kFE = 1/2;
dt = 0.1;
Tfe = 2;

GAMMA = 42.58;


for tfe = linspace(0,1,6)*Tfe
    phase_x = 2*pi*kFE*x *tfe/Tfe;
        
    Mxy_FE = Mxy .* exp(i*phase_x);
        
    figure
    subplot(121), plot([0:dt:Tfe+dt],  [0, ones(1,Tfe/dt)*kFE/(Tfe/dt), 0], tfe*ones(1,2), [-0.05 0.05]), ylabel('G_X')
    title('Frequency Encoding')
    subplot(122)
    quiver(x-real(Mxy_FE)*Splot/2,y-imag(Mxy_FE)*Splot/2,real(Mxy_FE), imag(Mxy_FE), Splot)
    xlabel('x'), ylabel('y')
    xlim([-N/2-1, N/2+1])
    ylim([-N/2-1, N/2+1])
    title('M_{XY}')
    drawnow
end



% 2D object
% simulate frequencies + phase encoding

N = 8;
Mxy= ones(N+1,N+1);

x = [-N/2:N/2];
[x,y] = meshgrid(x,x);
Splot = 0.5;

kPE = [-N/2:N/2]/N; %
dt = 0.1;
Tpe = 1;

GAMMA = 42.58;

for Ipe = 1:length(kPE)
    
    for tpe = Tpe %[0:dt:Tpe]
        phase_y = 2*pi*kPE(Ipe)*y *tpe/Tpe;
        
        Mxy_PE = Mxy .* exp(i*phase_y);
        
        figure(Ipe)
        
        subplot(121)
        plot([0:dt:Tpe+dt], [0, ones(1,Tpe/dt)*kPE(Ipe)/(Tpe/dt), 0]), ylim([-0.05 0.05]), ylabel('G_Y') 
        title(['Phase encoding, Step ' int2str(Ipe)])
        subplot(122)
        quiver(x-real(Mxy_PE)*Splot/2,y-imag(Mxy_PE)*Splot/2,real(Mxy_PE), imag(Mxy_PE), Splot)
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        drawnow
    end
end

%  plot k-space trajectories

% Cartesian
N = 8;

k = [-N/2:N/2]/N;
[ky,kx] = meshgrid(k,k);

figure
plot(kx, ky, 'LineWidth',10), xlim([-.6 .6]), ylim([-.6 .6])
xlabel('k_x'),ylabel('k_y')
title('Cartesian trajectory')

% echo-planar
kx_ep = kx; kx_ep(:,2:2:end) = kx_ep(end:-1:1,2:2:end);
kx_ep = kx_ep(:);

ky_ep = ky(:);

figure
plot(kx_ep, ky_ep, 'LineWidth',10), xlim([-.6 .6]), ylim([-.6 .6])
xlabel('k_x'),ylabel('k_y')
title('Echo-Planar trajectory')

% radial

k_theta = exp(i*2*pi*[1:N]/(2*N));
k_radial = k.' * k_theta;

figure
plot(real(k_radial), imag(k_radial), 'LineWidth',10), xlim([-.6 .6]), ylim([-.6 .6])
xlabel('k_x'),ylabel('k_y')
title('Radial trajectory')


% spiral
n = linspace(0,1,201);
Nturns = N/2;
k_spiral = 1/2*n.*exp(i*2*pi*Nturns*n);

figure
plot(real(k_spiral), imag(k_spiral), 'LineWidth',10), xlim([-.6 .6]), ylim([-.6 .6])
xlabel('k_x'),ylabel('k_y')
title('Spiral trajectory')




