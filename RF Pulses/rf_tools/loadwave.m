function y = loadwave(s)

%
%  rf = loadwave('filename');
%
%   'filename' -- the name of a signa 5x waveform file
%   rf         -- waveform extracted from that file


fip = fopen(s,'r');
if fip == -1,
   disp(sprintf('Error opening %s for read',s));
   return;
end;

d = fread(fip,'short');
y = d(33:length(d)-4);

