function signa(wav,fn,s)

%
%  signa(waveform, filename [,scale]);
%
%  writes the waveform out as short integers with the low
%  bit masked off.
%
%  Inputs:
%    waveform --  vector, may be complex
%    filename --  string, if wavefrom is complex '.r' and '.i' are appended,
%                    and two files are written.
%    scale    --  optional scale.  If unspecified, the waveform is scaled to
%                   full scale integer 32766.  If specified, the output is
%                   waveform*scale*32766
%  

%
%  Written by John Pauly, Dec. 5, 1994
%  (c) Leland Stanford Jr. University
%

wmax = hex2dec('7ffe');

% if no scale is specified, use as much dynamic range as possible
if nargin == 2,
  s = 1/max(max(abs(real(wav)),abs(imag(wav))));
end;

% scale up to fit in a short integer
wav = wav*s*wmax;

% mask off low bit, since it would be an EOS otherwise
wav = 2*round(wav/2);

% if the imaginary component is zero, supress it
if sum(abs(imag(wav))) == 0,
  wav = real(wav);
end;

if isreal(wav),
  fip = fopen(fn,'wb','b');
  if fip == -1,
    disp(sprintf('Error opening %s for write',fn));
    return;
  end;
  fwrite(fip,wav,'short');
else
  fip = fopen([fn,'.r'],'wb','b');
  if fip == -1,
    disp(sprintf('Error opening %s for write',[fn,'.r']));
    return;
  end;
  fwrite(fip,real(wav),'short');
  fclose(fip);
  fip = fopen([fn,'.i'],'wb','b');
  if fip == -1,
    disp(sprintf('Error opening %s for write',[fn,'.i']));
    return;
  end;
  fwrite(fip,imag(wav),'short');
  fclose(fip);
end;
