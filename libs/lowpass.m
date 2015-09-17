function Hd = lowpass
%LOWPASS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.3 and the Signal Processing Toolbox 6.21.
% Generated on: 17-Jun-2014 19:19:14

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in MHz.
Fs = 150;  % Sampling Frequency

Fpass = 1;               % Passband Frequency
Fstop = 1.1;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]