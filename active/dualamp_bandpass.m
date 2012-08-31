%function [R1,R2,R3,R4,R5,C] = dualamp_bandpass(f0,Q,A)
% Dual Amplifier Bandpass design
%
% Gain is 2 by default, but may be set less with an additional resistor
%


% set basic parameters
f0 = 9950;
Q = 5;
A = 1;

% choose capacitor and resistor
C = 16e-9;
R4 = 1e3;

% compute remaining values
R2 = 1./(2*pi*f0*C);
R3 = R2;
R5 = R4;
R1 = Q*R2;

% if A < 2
if (A < 2)
    R1a = 2*R1/A;
    R1b = (A*R1a)/(2-A);
end
