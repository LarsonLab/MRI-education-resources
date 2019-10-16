%  function [nk] = csg(k,mxg,mxs,[g0, gamma])
%
%  This routine takes a k-space trajectory and time warps it to
%  meet gradient amplitude and slew rate constraints.
%
%  Inputs:
%     k   --  k-space trajectory, scaled to cycles/cm
%     mxg --  maximum gradient, G/cm
%     mxs --  maximum slew rate, (G/cm)/ms
%     g0 (optional) -- initial gradient strength, G/cm
%     gamma (optional) -- kHz/G
%
%  Outputs:
%     nk  --  new k-space trajectory meeting the constraints
%
%  csg also reports the gradient duration required.  
%

%  Written by John Pauly, 1993
%
%  Oct 4, 2004 modified to use 'spline' in interp1, now that it works in
%      matlab 7

function [nk] = csg(k,mxg,mxs,g0,gamma)

if nargin < 5
    gamma = 4.257;
end

td = 1;
len = length(k);

% compute initial gradient, slew rate
g = [diff(k)]/(gamma*(td/len));
if nargin < 4 || isempty(g0)
    g = [0 g];
else
    g = [g0 g];
end
s = diff(g)/(td/len);
%s = [s s(end)];

% Compute slew rate limited trajectory
nk = k;

for N = 1:5
g = [diff(nk)]/(gamma*(td/len));
if nargin < 4 || isempty(g0)
    g = [0 g];
else
    g = [g0 g];
end
s = diff(g)/(td/len);
ndts = sqrt(abs(s/mxs));
nt = [0,cumsum(ndts)*td/len];
%nk = csplinx(nt,k,[1:len]*nt(len)/len);
nk = interp1(nt,nk,[0:len-1]*nt(len)/(len-1),'spline');
end


% Apply the additional gradient amplitude constraint
g = [0 diff(nk)]/(gamma*(nt(len)/len));

%ndtg = max(abs(g/mxg),1);
ndtg = max(abs(g),mxg);
nt = [0, cumsum(ndtg(1:end-1))*nt(len)/(mxg*len)];
%nk = csplinx(nt,nk,[1:len]*nt(len)/len);
nk = interp1(nt,nk,[0:len-1]*nt(len)/(len-1),'spline');

% report the waveform length
disp(sprintf('Gradient duration is %6.3f ms',nt(len)));

