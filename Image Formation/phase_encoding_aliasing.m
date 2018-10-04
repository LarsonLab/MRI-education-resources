clear imall1 imall2

x = [-128:127]/256;
y = [-392:391]/256;

[X Y] = meshgrid(x,y);

I1 = 1:256; I2 = I1+256; I3 = I2+256;

Iphase = 0;
    Mxy = exp(i*2*pi*10*Y);
    
f1=figure(1);

    imagesc(x,y,real(Mxy),[-1 1])%, colorbar
    xlabel('X'), ylabel('Y'), title('M_X')
 
    currFrame = getframe(f1);
%an1=    annotation('textbox', [.45 .8 .2 .2], 'String', ['ky = ' int2str(Iphase)], 'FitBoxToText','on');

[imind,map] = rgb2ind(frame2im(currFrame),256,'nodither'); 

figure(2)
%an2=    annotation('textbox', [.45 .8 .2 .2], 'String', ['ky = ' int2str(Iphase)], 'FitBoxToText','on');


for Iphase = 0:16
    
    Mxy = exp(i*2*pi*Iphase*Y);
    
f1=figure(1);
subplot(121)
    imagesc(x,y,real(Mxy),[-1 1])%, colorbar
    xlabel('X'), ylabel('Y'), title('M_X')
    
    subplot(122)
    imagesc(x,y,imag(Mxy),[-1 1])%, colorbar
    xlabel('X'), ylabel('Y'), title('M_Y')
an1.String  = ['ky = ' int2str(Iphase)];
    drawnow
currFrame = getframe(f1);

  imall1(:,:,1,Iphase+1) = rgb2ind(frame2im(currFrame),map,'nodither');

    
f2=figure(2);
subplot(321)
    imagesc(x,y(I1),real(Mxy(I1,:)),[-1 1])%, colorbar
    title('M_X')
subplot(323)
    imagesc(x,y(I2),real(Mxy(I2,:)),[-1 1])%, colorbar
    ylabel('Y')
subplot(325)
    imagesc(x,y(I3),real(Mxy(I3,:)),[-1 1])%, colorbar
    xlabel('X')
    
subplot(322)
    imagesc(x,y(I1),imag(Mxy(I1,:)),[-1 1])%, colorbar
    title('M_Y')
subplot(324)
    imagesc(x,y(I2),imag(Mxy(I2,:)),[-1 1])%, colorbar
    ylabel('Y')
subplot(326)
    imagesc(x,y(I3),imag(Mxy(I3,:)),[-1 1])%, colorbar
    xlabel('X')
    an2.String = ['ky = ' int2str(Iphase)];
        drawnow
currFrame = getframe(f2);

  imall2(:,:,1,Iphase+1) = rgb2ind(frame2im(currFrame),map,'nodither');


    
 %   pause
end



imwrite(imall1,map,'phase_encoding_steps.gif','DelayTime',1,'LoopCount',1) 
imwrite(imall2,map,'phase_encoding_steps_divided.gif','DelayTime',1,'LoopCount',1) 
