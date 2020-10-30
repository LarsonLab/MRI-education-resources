function [imall, map] = plot_gradient_phase_evolution(Tall, GX, GY, xwidth, use_image_phase, plot_kspace_trajectory, imall, map)
% Help function to plot a gradient, the induced MXY phase from the
% gradients, and the resulting k-space trajectory

Splot = 0.5;

if use_image_phase
    N_xy = 64;
else
    N_xy = 8;
end

x_vector = [-xwidth/2:xwidth/N_xy:xwidth/2];
[x,y] = meshgrid(x_vector,x_vector);

Mxy = zeros(N_xy+1, N_xy+1, length(Tall));
Mxy(:,:,1) = ones(N_xy+1,N_xy+1);
measured_signal = zeros(1,length(Tall));
measured_signal(1) = sum(sum(Mxy(:,:,1)))/(N_xy+1)^2;

kspace = zeros(1,length(Tall));


for It = 1:length(Tall)-1
    
    
    
    phase_y = 2*pi*GY(It)*y;
    phase_x = 2*pi*GX(It)*x;
    kspace(It+1) = kspace(It) + GX(It) + i*GY(It);
    Mxy(:,:,It+1) = Mxy(:,:,It) .* exp(i*phase_y) .* exp(i*phase_x);
    
    Mxy_plot = Mxy(:,:,It+1);
    measured_signal(It+1) = sum(sum(Mxy(:,:,It+1)))/(N_xy+1)^2;
    
    fs = figure(1);
    if plot_kspace_trajectory
        subplot(132)
    else
        subplot(122)
    end
    if use_image_phase
        imagesc(x_vector,x_vector,angle(Mxy_plot), [-pi pi]), colorbar
        set(gca,'YDir','normal')
        title('M_{XY} phase')
        axis tight
        %        xlim([-N_PE/2, N_PE/2])
        %        ylim([-N_PE/2, N_PE/2])
    else
        quiver(x-real(Mxy_plot)*Splot/2,y-imag(Mxy_plot)*Splot/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            Splot)
        title('M_{XY}')
        
        xlim([min(x(:))-1, max(x(:))+1])
        ylim([min(y(:))-1, max(y(:))+1])
    end
    xlabel('x'), ylabel('y')
    
    
    if plot_kspace_trajectory
        subplot(231)
    else
        subplot(221)
    end
    plot(Tall, GX, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_X'), xlim([0 Tall(end)])
    if plot_kspace_trajectory
        subplot(234)
    else
        subplot(223)
    end
    plot(Tall, GY, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_Y'), xlim([0 Tall(end)])
    %         subplot(325), plot(Tall(1:It), real(measured_signal(1:It))), xlabel('time'), ylabel('Signal')
    %         ylim([-1 1]), xlim([0 3.2])
    
    if plot_kspace_trajectory
        subplot(133)
        plot(real(kspace(1:It)), imag(kspace(1:It)), '-', real(kspace(It)), imag(kspace(It)), 'x')
        xlim([-.55 .55]), ylim([-.55 .55])
        xlabel('k_x'), ylabel('k_y')
    end
    
    drawnow
    
    currFrame = getframe(fs);
    if It == 1 && isempty(imall)
        im = frame2im(currFrame);
        [imind,map] = rgb2ind(im,256,'nodither');
    end
    imall = cat(4, imall, rgb2ind(frame2im(currFrame),map,'nodither'));
    
end