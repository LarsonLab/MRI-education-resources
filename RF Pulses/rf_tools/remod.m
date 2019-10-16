function rfn = remod(rf,t,n,f);

nc = t*f;
lrf = length(rf);

w = [0:lrf-1]/lrf;
wi = (floor(w*n)+0.5)/n;

rfn = rf.*exp(i*2*pi*w*nc).*exp(-i*2*pi*wi*nc);

