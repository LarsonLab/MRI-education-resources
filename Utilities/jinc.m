function res=jinc(x)
%res=jinc(x)

tmp = besselj(1,pi*x+eps);
res = tmp./(pi*x+eps);



