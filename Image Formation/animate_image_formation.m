%sag data
load('../Data//se_t1_sag_data.mat')
kdata = d;

S = size(d);

%%
clear imall

accel_factor = 1;

fs = figure(1);
imfinal = ifft2c(kdata);
maxdata = max(log(abs(kdata(:))));  maxim = max(abs(imfinal(:)));
subplot(121), imagesc(log(abs(kdata)), [0 maxdata]), axis equal off
subplot(122), imagesc(abs(imfinal), [0 maxim]), axis equal off
colormap(gray)
drawnow
currFrame = getframe(fs);
im = frame2im(currFrame);
[imind,map] = rgb2ind(im,256,'nodither'); 

%%
kout = zeros(S);
kdata_perm = kdata.';
for Ix = 1:S(1)
kout(Ix,:) = kdata(Ix,:);
imout = ifft2c(kout);
% subplot(121), imagesc(log(abs(kout)), [0 maxdata]), axis equal off
% subplot(122), imagesc(abs(imout), [0 maxim]), axis equal off
subplot(121), imagesc(log(abs(kout))), axis equal off
subplot(122), imagesc(abs(imout)), axis equal off
drawnow
currFrame = getframe(fs);

  imall(:,:,1,Ix) = rgb2ind(frame2im(currFrame),map,'nodither');

end
end

imwrite(imall,map,'image_formation_sequential.gif','DelayTime',0,'LoopCount',1) %g443800




%%
clear imall

kout = zeros(S);
kx = [1:S(1)]-S(1)/2;
[~, Ir] = sort(abs(kx));

fs = figure(1);
colormap(gray)

for I = 1:length(Ir)
kout(Ir(I),:) = kdata(Ir(I),:);
imout = ifft2c(kout);
subplot(121), imagesc(log(abs(kout))), axis equal off
subplot(122), imagesc(abs(imout)), axis equal off
drawnow
currFrame = getframe(fs);
  imall(:,:,1,I) = rgb2ind(frame2im(currFrame),map,'nodither');

end

imwrite(imall,map,'image_formation_centerout_lines.gif','DelayTime',0,'LoopCount',1) %g443800
%writeVideo(vidObj, currFrame);


%%
clear imall

kout = zeros(S);
Ir = randperm(S(1));

fs = figure(1);
colormap(gray)

for I = 1:length(Ir)
kout(Ir(I),:) = kdata(Ir(I),:);
imout = ifft2c(kout);
subplot(121), imagesc(log(abs(kout))), axis equal off
subplot(122), imagesc(abs(imout)), axis equal off
drawnow
currFrame = getframe(fs);
  imall(:,:,1,I) = rgb2ind(frame2im(currFrame),map,'nodither');

end

imwrite(imall,map,'image_formation_random_lines.gif','DelayTime',0,'LoopCount',1) %g443800

return      
%%
N = 256;
I = [N/2+1, N/2+1];
I = round([N/2-N/2.6 N/2+1]);
kout = zeros(N,N);
kout(I(1), I(2)) = 1;
imout = ifft2c(kout);
figure(3)
imagesc(real(imout)), axis equal off
pngwrite(real(imout), sprintf('image_frequency_%.2f_%.2f', I(1)/N-.5, I(2)/N-.5), [-1/N 1/N])
