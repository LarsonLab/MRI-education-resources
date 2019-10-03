function [BX, BY, BZ, xp, yp, zp] = loop_coil_field(radius, I, flag_2d)
%  Uses a biot-savart to evaluate the magnetic field of a circular loop
%  coil.  The coil is placed in the X-Z plane.
%
% INPUTS:
%   radius - Radius of the coil.
%   I - current in the coil
%
% OUTPUTS:
%   BX,BY,BZ - components of magnetic field vector
%   xp,yp,zp - locations at which the magnetic field vector was evaluated
%
% Contributions from https://www.mathworks.com/matlabcentral/fileexchange/42329-magnetic-field-of-a-circular-current-loop-using-biot-savart-s-law
% and Peder E. Z. Larson

if length(radius) == 1
    radius = [radius,radius];
end

if nargin < 3 || isempty(flag_2d)
    flag_2d = 0;
end

%-------------------------------------------------------------------------%
%---Coil is in the X-Z plane and Magnetic Field is Evaluated -------------%
%-------------at every point in the Y-Z plane(X=0)------------------------%
%-------------------------------------------------------------------------%

N=25;   % No of grids in the coil ( X-Y plane)
u0=1;   % for simplicity, u0 is taken as 1 (permitivity)
phi=-pi/2:2*pi/(N-1):3*pi/2; % For describing a circle (coil)

Xc=radius(1)*cos(phi); % X-coordinates of the coil
Yc=zeros(1,N);
Zc=radius(2)*sin(phi); % Y-coordinates of the coil

max_plot = max(radius)*2;

Nplot = 51;

xp = linspace(-max_plot,max_plot, Nplot);
yp = xp; 

if flag_2d ==1
    zp = 0;
else
    zp = xp;
end

[X, Y, Z] = meshgrid(xp, yp, zp);

for Ix=1:length(xp)
    for Iy=1:length(yp)
        for Iz=1:length(zp)
            
            %-------------------------------------------------------------------------
            % calculate R-vector from the coil(X-Y plane)to Y-Z plane where we are
            % interested to find the magnetic field and also the dl-vector along the
            % coil where current is flowing
            % (note that R is the position vector pointing from coil (X-Y plane) to
            % the point where we need the magnetic field (in this case Y-Z plane).)
            % dl is the current element vector which will make up the coil------------
            %-------------------------------------------------------------------------
            
            for i=1:N-1
                Rx(i)=X(Ix,Iy,Iz)-0.5*(Xc(i)+Xc(i+1));
                Ry(i)=Y(Ix,Iy,Iz)-0.5*(Yc(i)+Yc(i+1));
                Rz(i)=Z(Ix,Iy,Iz)-0.5*(Zc(i)+Zc(i+1));
                dlx(i)=Xc(i+1)-Xc(i);
                dly(i)=Yc(i+1)-Yc(i);
                dlz(i)=Zc(i+1)-Zc(i);
            end
            Rx(N)=X(Ix,Iy,Iz)-0.5*(Xc(N)+Xc(1));
            Ry(N)=Y(Iy,Iy,Iz)-0.5*(Yc(N)+Yc(1));
            Rz(N)=Z(Ix,Iy,Iz)-0.5*(Zc(N)+Zc(1));
            dlx(N)=-Xc(N)+Xc(1);
            dly(N)=-Yc(N)+Yc(1);
            dlz(N)=-Zc(N)+Zc(1);
            
            %--------------------------------------------------------------------------
            % for all the elements along coil, calculate dl cross R -------------------
            % dl cross R is the curl of vector dl and R--------------------------------
            % XCross is X-component of the curl of dl and R, similarly I get Y and Z-
            %--------------------------------------------------------------------------
            
            
            curl_dl_R = cross([dlx; dly; dlz], [Rx; Ry; Rz]);
            R=sqrt(Rx.^2+Ry.^2+Rz.^2);
            
            %-------------------------------------------------------------------------
            % this will be the biot savarts law equation------------------------------
            %--------------------------------------------------------------------------
            
            Bx1=(I*u0./(4*pi*(R.^3))).*curl_dl_R(1,:);
            By1=(I*u0./(4*pi*(R.^3))).*curl_dl_R(2,:);
            Bz1=(I*u0./(4*pi*(R.^3))).*curl_dl_R(3,:);
            %--------------------------------------------------------------------------
            % now we have  magnetic field from all current elements in the form of an
            % array named Bx1,By1,Bz1, now its time to add them up to get total
            % magnetic field
            %--------------------------------------------------------------------------
            
            BX(Ix, Iy, Iz) = sum(Bx1);
            BY(Ix, Iy, Iz) = sum(By1);
            BZ(Ix, Iy, Iz) = sum(Bz1);
            
            %-------------------------------------------------------------------------
            
        end
    end
end


Bmag = sqrt(BX.^2+BY.^2+BZ.^2);

[~,Iz] = min(abs(zp));
figure
subplot(221)
contour(xp,yp,squeeze(BX(:,:,Iz)),50), colorbar
title('B_X')
xlabel('x'), ylabel('y')
subplot(222)
contour(xp,yp,squeeze(BY(:,:,Iz)),50), colorbar
xlabel('x'), ylabel('y')
title('B_Y')
subplot(223)
contour(xp,yp,squeeze(BZ(:,:,Iz)),50), colorbar
xlabel('x'), ylabel('y')
title('B_Z')
subplot(224)
contour(xp,yp,squeeze(Bmag(:,:,Iz)),50), colorbar
hold on
quiver(xp(1:4:end),yp(1:4:end),BX(1:4:end,1:4:end,Iz), BY(1:4:end,1:4:end,Iz))
hold off
xlabel('x'), ylabel('y')
title('|B|')


% plot3(Xc,Yc,Zc,'linewidth',3)
% axis([-max_plot,max_plot,-max_plot,max_plot,-max_plot,max_plot])
% view([180 0])
% xlabel('x'), ylabel('y'), zlabel('z')
% title('loop co-ordinates','fontsize',14)
% grid on

