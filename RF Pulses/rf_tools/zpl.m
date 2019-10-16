function zpl(x)

%  plot zero locations relative to the unit circle

%  written by John Pauly, 1992
%  (c) Board of Trustees, Leland Stanford Junior University

clf;
hold on;
axis('square');
xl = max(abs(x));
xl = max(1.2,xl);
axis([-xl xl -xl xl]);
i = sqrt(-1);
plot(exp(-i*2*pi*[0:128]/128),'-');
plot([-xl xl],[0 0],'-');
plot([0 0],[-xl xl],'-');
for j=1:length(x),
 text(real(x(j))-0.04,imag(x(j)),'o');
end;
hold off;

