%% Illustration of a RF pulse
% To excite a slice, we create a RF pulse with a range of frequencies, used while applying magnetic field gradient

clear all

dt = 0.01;
tmax = 1;
N = tmax/dt;
t = [-N/2:N/2-1]*dt;
% center frequency of RF
f0 = 30;

% range of frequencies to sum
df = [-7:7];

[tmat dfmat] = meshgrid(t,df+f0);
rf_all = exp(i*2*pi*dfmat.*tmat);

f = [-N/2:N/2-1]/(N*dt);

fs = figure(1);
rf_test = sum(rf_all,1) * dt;
%rf_test = rf_test / length(df)^2;
FT_test = fftshift(fft(rf_test));
    subplot(211)
    plot(t,real(rf_test), t,imag(rf_test), t, abs(rf_test))
    xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')

    title([ ' frequencies in RF'])
    subplot(212)
    plot(f,abs(FT_test))
    title('Frequency profile')
    xlabel('frequency'), ylabel('flip (normalized)')
drawnow
currFrame = getframe(fs);
im = frame2im(currFrame);
% get map
[imind,map] = rgb2ind(im,256,'nodither'); 
%%

for n = 1:length(df)
    rf_n = sum(rf_all(1:n,:),1) * dt;

    % Fourier Transform used to approximate the RF pulse profile (small tip approximation)
    FT_n = fftshift(fft(rf_n));

    subplot(211)
    plot(t,real(rf_n), t,imag(rf_n), t, abs(rf_n))
    xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')

    title([int2str(n) ' frequencies in RF'])
    subplot(212)
    plot(f,abs(FT_n))
    title('Frequency profile')
    ylim([0 1.2])
    xlabel('frequency'), ylabel('flip (normalized)')

    drawnow
    currFrame = getframe(fs);

      imall(:,:,1,n) = rgb2ind(frame2im(currFrame),map,'nodither');

end


%%
imwrite(imall,map,'RF_pulse_frequencies-lab_frame.gif','DelayTime',1,'LoopCount',Inf)


%%

clear imall
f0 = 0;

% range of frequencies to sum
df = [0,1,-1,2,-2,3,-3,4,-4,5,-5,6,-6,7,-7];

[tmat dfmat] = meshgrid(t,df+f0);
rf_all = exp(i*2*pi*dfmat.*tmat);

for n = 1:length(df)
    rf_n = sum(rf_all(1:n,:),1) * dt;

    % Fourier Transform used to approximate the RF pulse profile (small tip approximation)
    FT_n = fftshift(fft(rf_n));

    subplot(211)
    plot(t,real(rf_n), t,imag(rf_n), t, abs(rf_n))
    xlabel('time'), ylabel('RF'), legend('real','imaginary', 'magnitude')

    title([int2str(n) ' frequencies in RF'])
    subplot(212)
    plot(f,abs(FT_n))
    title('Frequency profile')
    ylim([0 1.2])
    xlabel('frequency'), ylabel('flip (normalized)')

    drawnow
    currFrame = getframe(fs);

      imall(:,:,1,n) = rgb2ind(frame2im(currFrame),map,'nodither');

end


%%
imwrite(imall,map,'RF_pulse_frequencies-rotating_frame.gif','DelayTime',1,'LoopCount',Inf)

