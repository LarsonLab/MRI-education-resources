function af = iq2ap(rf)

a = abs(rf);
f = diff(phase(rf));
f = [0 f];

sgn = (-1*ones(1,length(rf))).^cumsum(sign(f).*floor(abs(f)/2));
a = a.*sgn;
f = angle(rf.*sgn);
af = a + i*f;

