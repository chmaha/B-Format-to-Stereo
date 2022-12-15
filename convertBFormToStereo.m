function convertBFormToStereo(filename)
% https://wiki.xiph.org/Ambisonics
% http://pcfarina.eng.unipr.it/Aurora/B-Format_to_UHJ.htm
% http://www.dsprelated.com/showthread/matlab/5198-1.php
% A bugfix or two plus modified to run on an entire directory of wav files

myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.wav')); 
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);

% Read in wavfile specified by filename
[WXYZ,fs] = audioread(fullFileName);

% separate into spearate channels
W = WXYZ(:,1);
X = WXYZ(:,2);
Y = WXYZ(:,3);

% get numel for fft
N = numel(W);

% caculate Left and Right channels
% L = (X + Y)/sqrt(2);
% R = (X - Y)/sqrt(2);

p = 90*pi/180;
j = cos(p) + 1i * sin(p);
% j2 = exp(p*i);

 L = ifft(0.5*(0.9397*fft(W,N)+ 0.18568*fft(X,N) - j*0.342*fft(W,N) + j*0.5099*fft(X,N) + 0.655*fft(Y,N)));
 R = ifft(0.5*(0.9397*fft(W,N)+ 0.18568*fft(X,N) + j*0.342*fft(W,N) - j*0.5099*fft(X,N) - 0.655*fft(Y,N)));

% S = 0.9396926*W + 0.1855740*X;
% D = j*(-0.3420201*W + 0.5098604*X) + 0.6554516*Y;
% L = (S + D)/2.0;
% R = (S - D)/2.0;
 
% make stereo output
stereoOut = [L R];

% write to wav
filenameOut = strcat('Stereo_',baseFileName);

audiowrite(filenameOut,stereoOut,fs);

end 
