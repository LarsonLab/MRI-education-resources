% setup MRI-education-resources path and requirements
cd ../
startup

% TE contrast

TE = linspace(0,200); % ms
T2v = [1;10;20;80;160];
[T2 TE] = meshgrid(T2v,TE);
M0 = ones(size(T2));

S_TE = M0.*exp(-TE./T2);

plot(TE,S_TE)
xlabel('TE (ms)'), ylabel('signal')
legend(int2str(T2v))
title('Signal versus TE for various T_2 values')

TE = linspace(0,200); % ms
T2 = linspace(1,150); % ms
[T2 TE] = meshgrid(T2,TE);
M0 = ones(size(T2));

S_TE = M0 .* exp(-TE./T2);

figure

mesh(T2,TE,S_TE)
view([155 30])
ylabel('TE (ms)'), xlabel('T_2 (ms)'), zlabel('signal')
colorbar

% Signal evolution between TRs with 90-degree pulses

M0 = [1;1;1;1]; 

T1 = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms

NTR = 8;
flip = 90;
TR = 500; %ms
Nt_per_TR = 100;
t_per_TR = [1:Nt_per_TR]*TR/Nt_per_TR;
t_minus = [0:NTR]*TR; t_plus = t_minus + 1;

% magnetization before each RF pulse
Mz_minus = zeros(length(T1), NTR+1);
% magnetization after each RF pulse
Mz_plus = zeros(length(T1), NTR+1);

% initial condition
Mz_minus(:,1) = M0;
Mz_plus(:,1) = Mz_minus(:,1)*cos(flip*pi/180);
t = [0 eps];
Mz_all = [Mz_minus(:,1),Mz_plus(:,1)];


for I = 1:NTR
    t = [t, t_per_TR + (I-1)*TR];

    for It = 1:Nt_per_TR
        Mz_all = [Mz_all, Mz_plus(:,I).*exp(-t_per_TR(It)./T1) + M0.*(1-exp(-t_per_TR(It)./T1))];
    end
    
    Mz_minus(:,I+1) = Mz_plus(:,I).*exp(-TR./T1) + M0.*(1-exp(-TR./T1));
    Mz_plus(:,I+1) = Mz_minus(:,I+1).*cos(flip*pi/180);


end

plot(t, Mz_all, t_minus, Mz_minus, 'x', t_plus, Mz_plus,'o')
legend(int2str(T1))
xlabel('time (ms)'), ylabel('M_Z')
title([num2str(flip) '-degree RF pulses applied every ' num2str(TR) ' ms'])

% TR contrast with T1

TR = linspace(0,2000); % ms
T1v = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms
[T1 TR] = meshgrid(T1v,TR);
M0 = ones(size(T1));

S_TR = M0.*(1-exp(-TR./T1));

plot(TR,S_TR)
xlabel('TR (ms)'), ylabel('signal')
legend(int2str(T1v))
title(['Signal versus TR for various T_1 values with ' num2str(flip) '-degree flip'])

TR = linspace(0,2000); % ms
T1 = linspace(400,2500); % ms
[T1 TR] = meshgrid(T1,TR);
M0 = ones(size(T1));

S_TR = M0 .* (1-exp(-TR./T1));

figure

mesh(T1,TR,S_TR)
view([110 30])
ylabel('TR (ms)'), xlabel('T_1 (ms)'), zlabel('signal')
colorbar


% Signal evolution between TRs with <90-degree pulses

M0 = [1;1;1;1]; 
T1 = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms

NTR = 30;
flip = 30;
TR = 100; %ms
Nt_per_TR = 100;
t_per_TR = [1:Nt_per_TR]*TR/Nt_per_TR;
t_minus = [0:NTR]*TR; t_plus = t_minus + 1;

% magnetization before each RF pulse
Mz_minus = zeros(length(T1), NTR+1);
% magnetization after each RF pulse
Mz_plus = zeros(length(T1), NTR+1);

% initial condition
Mz_minus(:,1) = M0;
Mz_plus(:,1) = Mz_minus(:,1)*cos(flip*pi/180);
t = [0 eps];
Mz_all = [Mz_minus(:,1),Mz_plus(:,1)];


for I = 1:NTR
    t = [t, t_per_TR + (I-1)*TR];

    for It = 1:Nt_per_TR
        Mz_all = [Mz_all, Mz_plus(:,I).*exp(-t_per_TR(It)./T1) + M0.*(1-exp(-t_per_TR(It)./T1))];
    end
    
    Mz_minus(:,I+1) = Mz_plus(:,I).*exp(-TR./T1) + M0.*(1-exp(-TR./T1));
    Mz_plus(:,I+1) = Mz_minus(:,I+1).*cos(flip*pi/180);


end

plot(t, Mz_all, t_minus, Mz_minus, 'x', t_plus, Mz_plus,'o')
legend(int2str(T1))
xlabel('time (ms)'), ylabel('M_Z')
title([num2str(flip) '-degree RF pulses applied every ' num2str(TR) ' ms'])

% TR and flip angle contrast with T1

flip = 30; % degrees
TR = linspace(0,2000); % ms
T1v = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms
[T1 TR] = meshgrid(T1v,TR);
M0 = ones(size(T1));

S_TR = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

plot(TR,S_TR)
xlabel('TR (ms)'), ylabel('signal')
legend(int2str(T1v))
title(['Signal versus TR for various T_1 values with ' num2str(flip) '-degree flip'])

TR = linspace(0,2000); % ms
T1 = linspace(400,2500); % ms
[T1 TR] = meshgrid(T1,TR);
M0 = ones(size(T1));

S_TR = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

figure

mesh(T1,TR,S_TR)
view([110 30])
ylabel('TR (ms)'), xlabel('T_1 (ms)'), zlabel('signal')
title([ num2str(flip) '-degree flip'])
colorbar

TR = 100;
flip = linspace(0,90); % degrees
T1v = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms
[T1 flip] = meshgrid(T1v,flip);
M0 = ones(size(T1));

S_flip = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

figure
plot(flip,S_flip)
xlabel('flip angle (degrees)'), ylabel('signal')
legend(int2str(T1v))
title(['Signal versus flip angles for various T_1 values with TR = ' num2str(TR) ' ms'])


flip = linspace(0,90); % degrees
T1 = linspace(400,2500); % ms
[T1 flip] = meshgrid(T1,flip);
M0 = ones(size(T1));

S_flip = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

figure

mesh(T1,flip,S_flip)
view([110 30])
xlabel('flip angle (degrees)'), xlabel('T_1 (ms)'), zlabel('signal')
title(['TR = ' num2str(TR) ' ms'])
colorbar

TR = 10;
flip = linspace(0,10); % degrees
T1v = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms
[T1 flip] = meshgrid(T1v,flip);
M0 = ones(size(T1));

S_flip = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

figure
plot(flip,S_flip)
xlabel('flip angle (degrees)'), ylabel('signal')
legend(int2str(T1v))
title(['Signal versus flip angles for various T_1 values with TR = ' num2str(TR) ' ms'])


flip = linspace(0,10); % degrees
T1 = linspace(400,2500); % ms
[T1 flip] = meshgrid(T1,flip);
M0 = ones(size(T1));

S_flip = sin(flip*pi/180) .* M0 .* (1-exp(-TR./T1)) ./ (1-cos(flip*pi/180).*exp(-TR./T1));

figure

mesh(T1,flip,S_flip)
view([110 30])
xlabel('flip angle (degrees)'), xlabel('T_1 (ms)'), zlabel('signal')
title(['TR = ' num2str(TR) ' ms'])
colorbar

% Inversion Recovery

T1 = [400; 800; 1200; 2000];
M0 = [1;1;1;1]; 

NTR = 3;
flip1 = 180; flip2 = 90;
TR = 2000; %ms
TI = 750; % ms

dt = 5; % ms
t_per_TR = dt:dt:TR;

% magnetization before each RF pulse
Mz1_minus = zeros(length(T1), NTR+1);
Mz2_minus = zeros(length(T1), NTR);

% magnetization after each RF pulse
Mz1_plus = zeros(length(T1), NTR+1);
Mz2_plus = zeros(length(T1), NTR);

% time of RF pulses
t1_minus = [0:NTR]*TR; t1_plus = t1_minus + 1;  % flip1, 180-degrees
t2_minus = t1_minus(1:end-1)+TI; t2_plus = t1_plus(1:end-1) + TI;


% initial condition
Mz1_minus(:,1) = M0;
Mz1_plus(:,1) = Mz1_minus(:,1)*cos(flip1*pi/180);
Mz_all = [Mz1_minus(:,1),Mz1_plus(:,1)];
t= [0, eps];

for I = 1:NTR
    t = [t, t_per_TR + (I-1)*TR];

    % evolve for TI period after 180-pulse
    for It = find(t_per_TR < TI)
        Mz_all = [Mz_all, Mz1_plus(:,I).*exp(-t_per_TR(It)./T1) + M0.*(1-exp(-t_per_TR(It)./T1))];
    end
    
    Mz2_minus(:,I) = Mz1_plus(:,I).*exp(-TI./T1) + M0.*(1-exp(-TI./T1));
    Mz2_plus(:,I) = Mz2_minus(:,I).*cos(flip2*pi/180);

    for It = find(t_per_TR >= TI)
        Mz_all = [Mz_all, Mz2_plus(:,I).*exp(-(t_per_TR(It)-TI)./T1) + M0.*(1-exp(-(t_per_TR(It)-TI)./T1))];
    end
    
    Mz1_minus(:,I+1) = Mz2_plus(:,I).*exp(-(TR-TI)./T1) + M0.*(1-exp(-(TR-TI)./T1));
    Mz1_plus(:,I+1) = Mz1_minus(:,I+1).*cos(flip1*pi/180);

end

plot(t, Mz_all, t1_minus, Mz1_minus.', 'x', t1_plus, Mz1_plus.','o', t2_minus, Mz2_minus, 'x', t2_plus, Mz2_plus,'o')
legend(int2str(T1))
xlabel('time (ms)'), ylabel('M_Z');

% Inversion Recovery, TI vs T1

TR = 2000; % ms
TI = linspace(0,2000); % ms
T1v = [400; 800; 1200; 2000]; %linspace(200,2000)'; % ms
[T1 TI] = meshgrid(T1v,TI);
M0 = ones(size(T1));

S_TI = M0.*(1 - 2*exp(-TI./T1) + exp(-TR./T1));

plot(TI,S_TI)
xlabel('TI (ms)'), ylabel('signal')
legend(int2str(T1v))
title(['Signal versus TI for various T_1 values with TR = ' num2str(TR) ' ms'])

TR = 2000;
TI = linspace(0,2000); % ms
T1 = linspace(400,2500); % ms
[T1 TI] = meshgrid(T1,TI);
M0 = ones(size(T1));

S_TI = M0.*(1 - 2*exp(-TI./T1) + exp(-TR./T1));

figure

mesh(T1,TI,S_TI)
view([110 30])
ylabel('TI (ms)'), xlabel('T_1 (ms)'), zlabel('signal')
colorbar


% contrast_phantom


Nphan = 3;
% phantom parameters
xc = [-.3 0 .3]*256;  % x centers
yc = [-.25 .25 -.25]*256;  % y centers
M0 = [1 1 1]; % relative proton densities
T1 = [.3 .8 3]*1e3;  % T1 relaxation times (ms)
T2 = [.06 .06 .2]*1e3;  % T2 relaxation times (ms)
r = 1/64;  % ball radius, where FOV = 1

flip = 90*pi/180;
TEs = [20 160]; TRs = [400 3000];

N = 256;

% matrices with kx, ky coordinates
[kx ky] = meshgrid([-N/2:N/2-1]/N);

for TE = TEs
    for TR = TRs

% initialize k-space data matrix
M = zeros(N,N);

% Generate k-space data by adding together k-space data for each
% individual phantom

for n= 1:Nphan
    % Generates data using Fourier Transform of a circle (jinc) multiplied by complex exponential to shift center location
    M = M+jinc(sqrt(kx.^2 + ky.^2) / (r) ) .* exp(i*2*pi* (kx*xc(n) + ky*yc(n))) * ...
        MRsignal_spoiled_gradient_echo(flip, TE, TR, M0(n), T1(n), T2(n));


end

% reconstruct and display ideal image
m = ifft2c(M);
figure
imagesc(abs(m)), colormap(gray), axis equal tight
title(['TE = ' int2str(TE) ', TR = ' int2str(TR)])

end
end


