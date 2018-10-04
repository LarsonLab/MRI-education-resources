%sag data
dataname = 'se_t1_sag_data';
outname = dataname;
load(['../Data/' dataname '.mat'])
kdata = d;

S = size(d);

imfinal = ifft2c(kdata);

pngwrite(abs(imfinal), [outname '_original']);


%% spike noise
data_spike = zeros(size(kdata));
data_spike(round(S(1)*.6), round(S(2)*.53)) = max(kdata(:))/2;
im_spike = ifft2c(kdata + data_spike);

imagesc(abs(im_spike))

%% RF interference
data_rfint = zeros(size(kdata));
data_rfint(:, round(S(2)*.23)) = exp(i*2*pi* [1:S(1)]/S(1) * round(S(1)*.8) *  max(kdata(:))/2/S(1);
im_rfint = ifft2c(kdata + data_rfint);

imagesc(abs(im_rfint))






%% generate image artifacts

load brain512


figure, imagesc(abs(ifft2c(data))), colormap(gray), axis equal tight off


%%

figure, imagesc(abs(ifft2c(data.'))), colormap(gray), axis equal tight off


%%

data_new = data; data_new(257,230) = max(abs(data(:)));  data_new(305,257) = max(abs(data(:)));
figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off

%%
x = 1:512;
[X,Y] = meshgrid(512,512);
data_new = data;  data_new(397,:) =  data_new(397,:) + exp(i*2*pi*200.2*x) .* randn(size(x));
data_new = data;  data_new=  data_new+ (exp(i*2*pi*160.2*X)+exp(i*2*pi*158*X))/100 .* repmat(randn(size(x.')),1,512);
figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off

%%
th = 0.2;
data_new = data;  data_new((abs(data) > th*max(abs(data(:))))) = data_new((abs(data) > th*max(abs(data(:))))) ./ abs(data_new((abs(data) > th*max(abs(data(:)))))) * th*max(abs(data(:)));
%data_new = data;  data_new((real(data) > th*max(real(data(:))))) = 

figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off

%%


data_new = data(1:2:end, :);  data_new(257:512,:) = 0;

figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off

im = ifft2c(data); data_new = fft2c(im([1:256]+128,:));
data_new(257:512,:) = 0;

figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off

%%

im = ifft2c(data); data_new = fft2c(im([1:256]+128,:));
data_new = data_new(:, 1:2:end);  

figure, imagesc(abs(ifft2c(data_new))), colormap(gray), axis equal tight off


%%

data_new = data([1:256]+128, :);
im_new = zeros(512); im_new([1:256]+128, :) = ifft2c(data_new);

figure, imagesc(abs(im_new)), colormap(gray), axis equal tight off

%%
im = ifft2c(data); im_rot = imrotate(im, 45);
im_rot = im_rot([1:512] + round(size(im_rot,1)/2)-256, [1:512] + round(size(im_rot,2)/2)-256 );
figure, imagesc(abs(im_rot)), colormap(gray), axis equal tight off


%%
im_new = ifft2c(data + randn(512,512) * max(abs(data(:)))/3e2);
figure, imagesc(abs(im_new)), colormap(gray), axis equal tight off
