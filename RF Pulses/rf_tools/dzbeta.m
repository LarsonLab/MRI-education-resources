function beta = dzbeta(np,tb,ptype,ftype,d1,d2,pclsfrac)
%   beta = dzbeta(np,tb,ptype,ftype,d1,d2,pclsfrac)
%
%  Same as dzrf, but returns the beta, instead of the rf pulse
%

%  written by John Pauly, 1995
%  (c) Board of Trustees, Leland Stanford Junior University

if (nargin < 7), pclsfrac = 1.5; end;
if nargin < 5, d1 = 0.01; d2 = 0.01; end;
if nargin < 4, ftype = 'ls'; end;
if nargin < 3, ptype = 'st'; end;

if strcmp(ptype,'st'),
   bsf = 1;
elseif strcmp(ptype,'ex'),
   bsf = sqrt(1/2);
   d1 = sqrt(d1/2);
   d2 = d2/sqrt(2);
elseif strcmp(ptype,'se'),
   bsf = 1;
   d1 = d1/4;
   d2 = sqrt(d2);
elseif strcmp(ptype,'inv'),
   bsf = 1;
   d1 = d1/8;
   d2 = sqrt(d2/2);
elseif strcmp(ptype,'sat'),
   bsf = sqrt(1/2);
   d1 = d1/2;
   d2 = sqrt(d2);
else
   disp(['Unrecognized Pulse Type -- ',ptype]);
   disp('  Recognized types are st, ex, se, inv, and sat');
   return;
end;

if strcmp(ftype,'ms'),
   b = msinc(np,tb/4);
elseif strcmp(ftype,'pm'),
   b = dzlp(np,tb,d1,d2);
elseif strcmp(ftype,'min'),
   b = dzmp(np,tb,d1,d2);
   b = b(np:-1:1);
elseif strcmp(ftype,'max'),
   b = dzmp(np,tb,d1,d2);
elseif strcmp(ftype,'ls'),
   b = dzls(np,tb,d1,d2);
else
   disp(['Unrecognized Filter Design Method -- ' ftype]);
   disp(['  Options: ms, pm, min, max, and ls']);
   return;
end;

if strcmp(ptype,'st'),
   beta = b;
else
   beta = bsf*b;
end;



