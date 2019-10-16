function rf = dzepse(ang,gx,tbx,tgx,ngx,sbw,srip1,srip2,stype);

%  Design Echo-Planar Spin Echo Pulses using a 2D inverse SLR
%  transform.   
%
%  function rf = dzepse(ang,gx,tbx,tgx,ngx,sbw, {srip1,srip2,stype} );
%
%       ang -- flip angle, in radians
%       gx  -- one segment (half cycle) of the x gradient
%       tbx -- time-bandwidth of spatial profile
%       tgx -- duration of one sublobe, ms
%       ngx -- number of sublobes
%       sbw -- spectral bandwidth, kHz
%       srip1 -- spectral in-band ripple   (optional, default 0.01)
%       srip2 -- spectral stop-band ripple (optional, default 0.01)
%       stype -- spectral profile type     (optional, default 'pm')
%

if nargin <7,   srip1 = 0.01; end;
if nargin <8,   srip2 = 0.01; end;
if nargin <9,   stype = 'pm'; end;

% x profile, normalized to one by default
lgx = length(gx);
kwx = dzbeta(lgx,tbx,'se');
pwx = fftc(kwx,2*lgx);
pwx = pwx(0.5*lgx+1:1.5*lgx);

tlen = (ngx-1)*tgx;
tbs = tlen*sbw;

% spectral k-space weighting
kws = dzbeta(ngx,tbs,'se',stype,srip1,srip2);

r = pwx'*kws*sin(ang/2);

[m n] = size(r);
rn1 = [];
for j=1:m,
  rn1 = [rn1; b2rf(r(j,:))];
end;

rn2 = [];
for j=1:n,
  p2 = fftc(sin(rn1(:,j)'/2),m*2)/(2*m);
  p2 = p2(0.5*m+1:1.5*m);
  rn2 = [rn2 b2rf(p2)'];
end;

% verse it - originally used versec with [0:m-1] and no spline interp
rfv = verse(gx,rn2);

% make it a row vector
rf = rfv(:).';
%rf = rn2(:).';


