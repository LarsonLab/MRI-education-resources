% setup MRI-education-resources path and requirements
cd ../
startup

R = .1; % coil radius [m]
I0 = 0.1; % current amplitude [amps]
mu0 = 4*pi*1e-7; % T⋅m/A; 

t = linspace(0,4, 401);
I = cos(2*pi*t) * I0;


BZ = mu0 * I / (2*R);    % magnetic field at the center of a single loop

subplot(211)
plot(t,I)
ylabel('I (A)')
xlabel('time')
title(['Current in a single loop coil of radius ' num2str(R) ' [m]'])
subplot(212)
plot(t,BZ)
ylabel('B_Z (T)')
xlabel('time')
title(['Magnetic field at center of the coil'])


R = 12; % coil radius, cm
I = 3; % current in the coil
flag_2d = 1; % just plot 2D profile

[BX, BY, BZ, xp,yp, zp] = loop_coil_field(R, I, flag_2d);

% plot the vector field

quiver(xp,yp, BX, BY, 1.4)
axis([-18 18 -18 18])
xlabel('x position (cm)')
ylabel('y position (cm)')
title('Magnetic field as a vector field')

Bmag = sqrt(BX.^2+BY.^2+BZ.^2);
xhalf = round(length(xp)/2);

imagesc(yp, xp(1:xhalf), Bmag(1:xhalf,:))
xlabel('position (cm)')
ylabel('position (cm)')
axis tight
colormap(gray),colorbar
title('One-sided B_1 sensitivity profile (coil located at bottom of the image)')


