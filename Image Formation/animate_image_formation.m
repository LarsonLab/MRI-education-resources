%sag data
load('../Data//se_t1_sag_data.mat')
kdata = data;

S = size(kdata);

write_animations = 0;

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
if write_animations
    imwrite(imall,map,'image_formation_sequential.gif','DelayTime',0,'LoopCount',1) %g443800
end



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
if write_animations
    imwrite(imall,map,'image_formation_centerout_lines.gif','DelayTime',0,'LoopCount',1) %g443800
%writeVideo(vidObj, currFrame);
end

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

if write_animations
    imwrite(imall,map,'image_formation_random_lines.gif','DelayTime',0,'LoopCount',1) %g443800
end

return      

%%
clear imall
accel_factor = 1; Icount = 1;
kout = zeros(S);
Ir = randperm(S(1)*S(2));

fs = figure(1);
colormap(gray)

for I = 1:length(Ir)
kout(Ir(I)) = kdata(Ir(I));
imout = ifft2c(kout);
if rem(I, accel_factor) == 0
subplot(121), imagesc(log(abs(kout)), [0 5]), axis equal off
subplot(122), imagesc(abs(imout)), axis equal off
drawnow
currFrame = getframe(fs);
  imall(:,:,1,Icount) = rgb2ind(frame2im(currFrame),map,'nodither');
    Icount = Icount + 1;  
    if accel_factor < 512
        accel_factor = accel_factor*2;
    end
end
end

if write_animations
    imwrite(imall,map,'image_formation_random_all.gif','DelayTime',0,'LoopCount',1) %g443800
end
