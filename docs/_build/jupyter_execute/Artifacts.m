% setup MRI-education-resources path and requirements
cd ../
startup

% load k-space data
dataname = 'se_t1_sag_data';
load(dataname)
kdata = data;
S = size(kdata);

im_original = ifft2c(kdata);

subplot(121)
imagesc(log(abs(kdata)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_original), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off


%% spike noise
spike_location = [.6 .53];

data_spike = zeros(size(kdata));
data_spike(round(S(1)*spike_location(1)), round(S(2)*spike_location(2))) = max(kdata(:))/1.5;
im_spike = ifft2c(kdata + data_spike);


subplot(121)
imagesc(log(abs(kdata + data_spike)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_spike), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off



%% RF interference
relative_RF_frequency = 0.6;

%single frequency, phase modulated
ph_int = pi*rand(S(1),1);
rfint = exp(i*2*pi* [1:S(1)] *relative_RF_frequency/2 ) *  max(abs(kdata(:)))/S(1)/1.5;
data_rfint = repmat(rfint, [S(1), 1]) .* repmat(exp(i*ph_int), [1, S(2)]);
im_rfint = ifft2c(kdata + data_rfint);

figure
subplot(121)
imagesc(log(abs(kdata + data_rfint)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_rfint), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off

% simulate amplitude modulated interference
relative_RF_frequency = 0.2;
rfint = exp(i*2*pi* [1:S(1)]/S(1) * S(1)*relative_RF_frequency/2) *  max(abs(kdata(:)))/S(1)/3;
data_rfint = randn(S(1),1) * rfint;
im_rfint = ifft2c(kdata + data_rfint);

figure
subplot(121)
imagesc(log(abs(kdata + data_rfint)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_rfint), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off

% simulate frequency modulated interference
relative_RF_frequency = 1;
f = randn(S(1),1)*relative_RF_frequency/2;
data_rfint = exp(i*2*pi* f*[1:S(1)]/S(1)  ) *  max(abs(kdata(:)))/S(1)/1.5;
im_rfint = ifft2c(kdata + data_rfint);

figure
subplot(121)
imagesc(log(abs(kdata + data_rfint)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_rfint), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off

%% aliasing
N_undersamp = 2;  % >= 1
data_undersamp = zeros(size(kdata));
Iundersamp = 1:N_undersamp:S(1);
data_undersamp(round(Iundersamp),:) = kdata(round(Iundersamp),:);
im_undersamp = ifft2c(data_undersamp);


subplot(121)
imagesc(log(abs(data_undersamp)), [0 max(log(abs(kdata(:))))])
colormap(gray), axis equal tight off
subplot(122)
imagesc(abs(im_undersamp), [0 max(abs(im_original(:)))])
colormap(gray), axis equal tight off




