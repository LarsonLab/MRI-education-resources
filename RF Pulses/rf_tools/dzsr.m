function rf = dzsr(h,n,d,p);

lh = length(h);
h = h/max(abs(fftc(h,4*lh)));
b = [zeros(1,n-lh) h(lh:-1:1)];
a = b2a(b);
b = b/sqrt(2);
a(n-d-lh+1:n-d) = a(n-d-lh+1:n-d) + exp(i*p)*b(n-lh+1:n);
rf = cabc2rf(a,b);

