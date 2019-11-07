N = 8;
Mxy= ones(N+1,N+1);

x = [-N/2:N/2];
[x,y] = meshgrid(x,x);
Splot = 0.5;

kPE = [-N/2:N/2]/N; %
dt = 0.1;
Tpe = 1;

kFE = 1/2;
Tfe = 2;


write_animations = 1;
clear imall

GAMMA = 42.58;

Tall = [0:dt:Tpe+Tfe+2*dt]; % add zero samples at beginning and end

Ix = 1;
for Ipe = 1:length(kPE)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tpe/dt+1) = kPE(Ipe)/(Tpe/dt) ;
    GFE(Tpe/dt+2:end-1) = kFE/(Tfe/dt) ;
    
    Mxy = zeros(N+1, N+1, length(Tall));
    Mxy(:,:,1) = ones(N+1,N+1);
    measured_signal = zeros(1,length(Tall));
    measured_signal(1) = sum(sum(Mxy(:,:,1)))/(N+1)^2;
    
    kspace = zeros(1,length(Tall));
    
    for It = 1:length(Tall)-1
        
        
        
        phase_y = 2*pi*GPE(It)*y;
        phase_x = 2*pi*GFE(It)*x;
        kspace(It+1) = kspace(It) + GFE(It) + i*GPE(It);
        Mxy(:,:,It+1) = Mxy(:,:,It) .* exp(i*phase_y) .* exp(i*phase_x);
        
        Mxy_plot = Mxy(:,:,It+1);
        measured_signal(It+1) = sum(sum(Mxy(:,:,It+1)))/(N+1)^2;
        
        fs = figure(1);
        subplot(122)
        quiver(x-real(Mxy_plot)*Splot/2,y-imag(Mxy_plot)*Splot/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            Splot)
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        
        
        subplot(321), plot(Tall, GPE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_Y'), xlim([0 3.2])
        subplot(323), plot(Tall, GFE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_X'), xlim([0 3.2])
        subplot(325), plot(Tall(1:It), real(measured_signal(1:It))), xlabel('time'), ylabel('Signal')
        ylim([-1 1]), xlim([0 3.5])
        

        drawnow
        
        currFrame = getframe(fs);
        if Ix == 1
            im = frame2im(currFrame);
            [imind,map] = rgb2ind(im,256,'nodither'); 
        end
        imall(:,:,1,Ix) = rgb2ind(frame2im(currFrame),map,'nodither');
        Ix = Ix+1;
        
    end
end



if write_animations
    imwrite(imall,map,'frequency_phase_encoding-simple.gif','DelayTime',0,'LoopCount',Inf) %g443800
end

%% with frequency encode dephasing gradients

GAMMA = 42.58;
write_animations = 1;
clear imall

Tall = [0:dt:Tpe+Tfe+2*dt]; % add zero samples at beginning and end

Ix = 1;
for Ipe = 1:length(kPE)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tpe/dt+1) = kPE(Ipe)/(Tpe/dt) ;
    GFE(2:Tpe/dt+1) = -kFE/(Tpe/dt) ;
    GFE(Tpe/dt+2:end-1) = 2*kFE/(Tfe/dt) ;
    
    Mxy = zeros(N+1, N+1, length(Tall));
    Mxy(:,:,1) = ones(N+1,N+1);
    measured_signal = zeros(1,length(Tall));
    measured_signal(1) = sum(sum(Mxy(:,:,1)))/(N+1)^2;
    
    kspace = zeros(1,length(Tall));
    
    for It = 1:length(Tall)-1
        
        
        
        phase_y = 2*pi*GPE(It)*y;
        phase_x = 2*pi*GFE(It)*x;
        kspace(It+1) = kspace(It) + GFE(It) + i*GPE(It);
        Mxy(:,:,It+1) = Mxy(:,:,It) .* exp(i*phase_y) .* exp(i*phase_x);
        
        Mxy_plot = Mxy(:,:,It+1);
        measured_signal(It+1) = sum(sum(Mxy(:,:,It+1)))/(N+1)^2;
        
        fs = figure(1);

        subplot(132)
        quiver(x-real(Mxy_plot)*Splot/2,y-imag(Mxy_plot)*Splot/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            Splot)
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        
        
        subplot(331), plot(Tall, GPE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_Y'), xlim([0 3.2])
        subplot(334), plot(Tall, GFE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_X'), xlim([0 3.2])
        subplot(337), plot(Tall(1:It), real(measured_signal(1:It))), xlabel('time'), ylabel('Signal')
        ylim([-1 1]), xlim([0 3.2])

        subplot(133)
        plot(real(kspace(1:It)), imag(kspace(1:It)), '-', real(kspace(It)), imag(kspace(It)), 'x')
        xlim([-.55 .55]), ylim([-.55 .55])
        xlabel('k_x'), ylabel('k_y')
        
        
        drawnow
        currFrame = getframe(fs);
        if Ix == 1
            im = frame2im(currFrame);
            [imind,map] = rgb2ind(im,256,'nodither'); 
        end
        imall(:,:,1,Ix) = rgb2ind(frame2im(currFrame),map,'nodither');
        Ix = Ix+1;
        
    end
end

if write_animations
    imwrite(imall,map,'frequency_phase_encoding-full.gif','DelayTime',0,'LoopCount',Inf) %g443800
end

return
%%  Old version
for Ipe = 1:length(kPE)
    
    for tpe = [0:dt:Tpe]
        phase_y = 2*pi*kPE(Ipe)*y *tpe/Tpe;
        
        Mxy_PE = Mxy .* exp(i*phase_y);
        
        %contour(xp,yp,squeeze(Bmag(:,:,Iz)),50), colorbar
        %hold on
        quiver(x-real(Mxy_PE)*Splot/2,y-imag(Mxy_PE)*Splot/2,real(Mxy_PE), imag(Mxy_PE), Splot)
        %hold off
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        drawnow
    end
    
    for tfe = [dt:dt:Tfe]
        phase_x = 2*pi*kFE*x *tfe/Tfe;
        
        Mxy_FE = Mxy_PE .* exp(i*phase_x);
        
        %contour(xp,yp,squeeze(Bmag(:,:,Iz)),50), colorbar
        %hold on
        quiver(x-real(Mxy_FE)*Splot/2,y-imag(Mxy_FE)*Splot/2,real(Mxy_FE), imag(Mxy_FE), Splot)
        %hold off
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        drawnow
    end
    
    
end


%% Radial

N = 8;
Mxy= ones(N+1,N+1);

x = [-N/2:N/2];
[x,y] = meshgrid(x,x);
Splot = 0.5;

ktheta = [0:N-1]/N*pi; %
dt = 0.1;

Tdephase = 1;
kr = 1/2;
Tread = 2;


GAMMA = 42.58;
write_animations = 1;
clear imall

Tall = [0:dt:Tdephase+Tread+2*dt]; % add zero samples at beginning and end

Ix = 1;
for Ipe = 1:length(ktheta)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tdephase/dt+1) = -kr/(Tdephase/dt) * sin(ktheta(Ipe));
    GFE(2:Tdephase/dt+1) = -kr/(Tdephase/dt)  * cos(ktheta(Ipe));
    GPE(Tdephase/dt+2:end-1) = 2*kr/(Tread/dt)  * sin(ktheta(Ipe));
    GFE(Tdephase/dt+2:end-1) = 2*kr/(Tread/dt)  * cos(ktheta(Ipe));
    
    Mxy = zeros(N+1, N+1, length(Tall));
    Mxy(:,:,1) = ones(N+1,N+1);
    measured_signal = zeros(1,length(Tall));
    measured_signal(1) = sum(sum(Mxy(:,:,1)))/(N+1)^2;
    
    kspace = zeros(1,length(Tall));
    
    for It = 1:length(Tall)-1
        
        
        
        phase_y = 2*pi*GPE(It)*y;
        phase_x = 2*pi*GFE(It)*x;
        kspace(It+1) = kspace(It) + GFE(It) + i*GPE(It);
        Mxy(:,:,It+1) = Mxy(:,:,It) .* exp(i*phase_y) .* exp(i*phase_x);
        
        Mxy_plot = Mxy(:,:,It+1);
        measured_signal(It+1) = sum(sum(Mxy(:,:,It+1)))/(N+1)^2;
        
        fs = figure(1);

        subplot(132)
        quiver(x-real(Mxy_plot)*Splot/2,y-imag(Mxy_plot)*Splot/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            Splot)
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        
        
        subplot(331), plot(Tall, GPE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_Y'), xlim([0 3.2])
        subplot(334), plot(Tall, GFE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_X'), xlim([0 3.2])
        subplot(337), plot(Tall(1:It), real(measured_signal(1:It))), xlabel('time'), ylabel('Signal')
        ylim([-1 1]), xlim([0 3.2])

        subplot(133)
        plot(real(kspace(1:It)), imag(kspace(1:It)), '-', real(kspace(It)), imag(kspace(It)), 'x')
        xlim([-.55 .55]), ylim([-.55 .55])
        xlabel('k_x'), ylabel('k_y')
        
        
        drawnow
        currFrame = getframe(fs);
        if Ix == 1
            im = frame2im(currFrame);
            [imind,map] = rgb2ind(im,256,'nodither'); 
        end
        imall(:,:,1,Ix) = rgb2ind(frame2im(currFrame),map,'nodither');
        Ix = Ix+1;
        
    end
end

if write_animations
    imwrite(imall,map,'radial_encoding-full.gif','DelayTime',0,'LoopCount',Inf) %g443800
end

%% Spiral

N = 8;
Mxy= ones(N+1,N+1);

x = [-N/2:N/2];
[x,y] = meshgrid(x,x);
Splot = 0.5;

dt = 0.1;

kr = 1/2;
T = 12;


GAMMA = 42.58;
write_animations = 1;
clear imall

Tall = [0:dt:T+2*dt]; % add zero samples at beginning and end

Ix = 1;
    GPE = zeros(1,length(Tall));GFE = GPE;
    tspiral = [0:dt:T]/T;
    kspiral = kr * tspiral .* exp(i*2*pi*N*tspiral) ;
    GPE(2:end-1) = real( kr* kspiral / sum(kspiral));
    GFE(2:end-1) = imag( kr* kspiral / sum(kspiral));
    
    Mxy = zeros(N+1, N+1, length(Tall));
    Mxy(:,:,1) = ones(N+1,N+1);
    measured_signal = zeros(1,length(Tall));
    measured_signal(1) = sum(sum(Mxy(:,:,1)))/(N+1)^2;
    
    kspace = zeros(1,length(Tall));
    
    for It = 1:length(Tall)-1
        
        
        
        phase_y = 2*pi*GPE(It)*y;
        phase_x = 2*pi*GFE(It)*x;
        kspace(It+1) = kspace(It) + GFE(It) + i*GPE(It);
        Mxy(:,:,It+1) = Mxy(:,:,It) .* exp(i*phase_y) .* exp(i*phase_x);
        
        Mxy_plot = Mxy(:,:,It+1);
        measured_signal(It+1) = sum(sum(Mxy(:,:,It+1)))/(N+1)^2;
        
        fs = figure(1);

        subplot(132)
        quiver(x-real(Mxy_plot)*Splot/2,y-imag(Mxy_plot)*Splot/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            Splot)
        xlabel('x'), ylabel('y')
        xlim([-N/2-1, N/2+1])
        ylim([-N/2-1, N/2+1])
        title('M_{XY}')
        
        
        subplot(331), plot(Tall, GPE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_Y'),xlim([0 T+.2])
        subplot(334), plot(Tall, GFE, Tall(It)*ones(1,2), [-0.05 0.05]), ylabel('G_X'),xlim([0 T+.2])
        subplot(337), plot(Tall(1:It), real(measured_signal(1:It))), xlabel('time'), ylabel('Signal')
        ylim([-1 1]), xlim([0 T+.2])

        subplot(133)
        plot(real(kspace(1:It)), imag(kspace(1:It)), '-', real(kspace(It)), imag(kspace(It)), 'x')
        xlim([-.55 .55]), ylim([-.55 .55])
        xlabel('k_x'), ylabel('k_y')
        
        
        drawnow
        currFrame = getframe(fs);
        if Ix == 1
            im = frame2im(currFrame);
            [imind,map] = rgb2ind(im,256,'nodither'); 
        end
        imall(:,:,1,Ix) = rgb2ind(frame2im(currFrame),map,'nodither');
        Ix = Ix+1;
        
    end

if write_animations
    imwrite(imall,map,'spiral_encoding-full.gif','DelayTime',0,'LoopCount',Inf) %g443800
end