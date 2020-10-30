write_animations = 1;
use_image_phase = 1; %instead of Mxy vectors

if use_image_phase
    filename_suffix = '-image_phase';
else
    filename_suffix = '-Mxy';
end

%%
N_PE = 8;
kPE = [-N_PE/2:N_PE/2]/N_PE; %
dt = 0.1;
Tpe = 1;

kFE = 1/2;
Tfe = 2;

GAMMA = 42.58;

Tall = [0:dt:Tpe+Tfe+2*dt]; % add zero samples at beginning and end

%%
imall = []; map = [];


for Ipe = 1:length(kPE)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tpe/dt+1) = kPE(Ipe)/(Tpe/dt) ;
    GFE(Tpe/dt+2:end-1) = kFE/(Tfe/dt) ;
    
    [imall, map] = plot_gradient_phase_evolution(Tall, GFE, GPE, N_PE, use_image_phase, 0, imall, map);
    
end



if write_animations
    imwrite(imall,map,['frequency_phase_encoding-simple' filename_suffix '.gif'],'DelayTime',0,'LoopCount',Inf) %g443800
end

%% with frequency encode dephasing gradients
 imall = []; map = [];

 for Ipe = 1:length(kPE)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tpe/dt+1) = kPE(Ipe)/(Tpe/dt) ;
    GFE(2:Tpe/dt+1) = -kFE/(Tpe/dt) ;
    GFE(Tpe/dt+2:end-1) = 2*kFE/(Tfe/dt) ;
    
    [imall, map] = plot_gradient_phase_evolution(Tall, GFE, GPE, N_PE, use_image_phase, 1, imall, map);
end

if write_animations
    imwrite(imall,map,['frequency_phase_encoding-full' filename_suffix '.gif'],'DelayTime',0,'LoopCount',Inf) %g443800
end

%% Radial

N = 8;

ktheta = [0:N-1]/N*pi; %
dt = 0.1;

Tdephase = 1;
kr = 1/2;
Tread = 2;


Tall = [0:dt:Tdephase+Tread+2*dt]; % add zero samples at beginning and end

imall = []; map = [];

for Ipe = 1:length(ktheta)
    
    GPE = zeros(1,length(Tall));GFE = GPE;
    GPE(2:Tdephase/dt+1) = -kr/(Tdephase/dt) * sin(ktheta(Ipe));
    GFE(2:Tdephase/dt+1) = -kr/(Tdephase/dt)  * cos(ktheta(Ipe));
    GPE(Tdephase/dt+2:end-1) = 2*kr/(Tread/dt)  * sin(ktheta(Ipe));
    GFE(Tdephase/dt+2:end-1) = 2*kr/(Tread/dt)  * cos(ktheta(Ipe));
    
    [imall, map] = plot_gradient_phase_evolution(Tall, GFE, GPE, N, use_image_phase, 1, imall, map);

 
end

if write_animations
    imwrite(imall,map,['radial_encoding-full' filename_suffix '.gif'],'DelayTime',0,'LoopCount',Inf) %g443800
end

%% Spiral

N_turns = N_PE/2;  % doubled
dt = 0.1;

kr = 1/2;
T = 12;


Tall = [0:dt:T+2*dt]; % add zero samples at beginning and end

GPE = zeros(1,length(Tall));GFE = GPE;
tspiral = [0:dt:T]/T;
kspiral = kr * tspiral .* exp(i*2*pi*N_turns*tspiral) ;
GPE(2:end-1) = real( kr* kspiral / sum(kspiral));
GFE(2:end-1) = imag( kr* kspiral / sum(kspiral));

imall = []; map = [];

[imall, map] = plot_gradient_phase_evolution(Tall, GFE, GPE, N, use_image_phase, 1, imall, map);


if write_animations
    imwrite(imall,map,['spiral_encoding-full' filename_suffix '.gif'],'DelayTime',0,'LoopCount',Inf) %g443800
end