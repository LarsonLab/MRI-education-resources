write_animations = 1;
spinecho_flag = 1;
% Simulations of off-resonance and T2* decay

B0 = 1.5e3; % 1500 mT = 1.5 T
% using units of mT and ms for the bloch_rotate function
T2 = 80; % ms
T1 = Inf; % neglect T1
% create range of off-resonance in a voxel
Nvoxel = 8^2;
off_resonance_ranges = [0 0.07 0.25]*1e-6; % off resonance range, in ppm
off_resonance_description = {'no' 'mild' 'severe'};

for I = 1:3

    imall = [];
    off_resonance_range = off_resonance_ranges(I); % off resonance range, in ppm

dBZ = linspace(-off_resonance_range,off_resonance_range, Nvoxel); % assumes a uniform distribution
dBZ = (rand(Nvoxel) -0.5 )* off_resonance_range;  % Uniform distribution
dBZ = randn(Nvoxel) * off_resonance_range;  % Gaussian distribution


% start after RF excitation
Mstart = [1,0,0].'; 

Tmax = T2;
dt = .5; % ms
N = Tmax/dt;
t = [1:N]*dt;
Mall = zeros(3,N,Nvoxel);
Mall(:,1,:) = repmat(Mstart, [1 1 Nvoxel]);
for INvoxel = 1:Nvoxel
    Bvoxel = [0 0 dBZ(INvoxel)*B0]; % off-resonance, in rotating frame
    for It = 1:N-1
        if spinecho_flag && It == round(N/3)
            Mall(2,It,INvoxel) = -Mall(2,It,INvoxel); % 180-pulse to invert My
        end
        Mall(:,It+1,INvoxel) = bloch_relax(  bloch_rotate(Mall(:,It,INvoxel),dt,Bvoxel), dt, 1, T1, T2 );
    end
end

Mall_voxel = sum(Mall, 3)/Nvoxel;

[x y] = meshgrid(1:sqrt(Nvoxel));
Splot = 0.5;
fs = figure(1);
%%
for It = 1:N
    Mxy_plot = Mall(1,It,:) + 1i*Mall(2,It,:);
    Mxy_plot = reshape(Mxy_plot, [sqrt(Nvoxel) sqrt(Nvoxel)]);

    subplot(1,3,1)
    quiver(x-real(Mxy_plot)/2,y-imag(Mxy_plot)/2,...
            real(Mxy_plot), imag(Mxy_plot), ...
            0)
    axis([0 9 0 9]), axis square
    title('M_{XY} within a voxel')

    subplot(1,3,2)
    Mxy_voxel = sum(sum(Mxy_plot))/length(Mxy_plot(:));
    quiver(-real(Mxy_voxel)/2,-imag(Mxy_voxel)/2,...
            real(Mxy_voxel), imag(Mxy_voxel), ...
            0)
    axis([-0.5 0.5 -0.5 0.5]), axis square
    title('M_{XY} summed across a voxel ')

    subplot(1,3,3)
    plot(t(1:It), Mall_voxel(1,1:It), t(1:It), Mall_voxel(2,1:It),'--')
    xlim([0 max(t)])
    ylim([-0.1 1])
    title('Voxel signal')
    xlabel('time [ms]')

    drawnow
    
    currFrame = getframe(fs);
    if It == 1 && isempty(imall)
        im = frame2im(currFrame);
        [imind,map] = rgb2ind(im,256,'nodither');
    end
    imall = cat(4, imall, rgb2ind(frame2im(currFrame),map,'nodither'));

end


if write_animations
    if spinecho_flag
        root_name = 't2star-spinecho_';
    else
        root_name = 't2star_';
    end
    imwrite(imall,map,[root_name off_resonance_description{I} '_off-resonance.gif'],'DelayTime',0,'LoopCount',Inf) %g443800
end

end
