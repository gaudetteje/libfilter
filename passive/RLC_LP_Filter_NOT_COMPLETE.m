clear all;

%R=663;
%C=10E-9;
%L=17.6E-3;

%R=6633;
%C=1E-9;
%L=176E-3;

%R=3316;
%C=2E-9;
%L=88E-3;

%R=4690;
%C=1.5E-9;
%L=132E-3;

% Want 2500Hz (L*C=4.05696e-9)
% Want 10,000Hz (L*C=0.253559-9)
R=.5;
L=10E-6;
C=100E-6;

% Resonant frequency (Hz)
fo = 1/(2*pi*sqrt(L*C))
% Resonant frequency (rad/sec)
wo = 1/sqrt(L*C)
% Damping factor (alpha) for series RLC circuit
%alpha = sqrt(L)/(2*R*sqrt(C))
alpha = R/(2*L)

% Resistance for critical damping (alpha=wo)
Rcritical = (2*L)/sqrt(L*C)

if alpha > wo
   'Overdamped' 
elseif alpha == wo
   'Critically Damped' 
elseif alpha < wo
   'Underdamped'
end

numg=[0 0 1/C];
deng = [L R 1/C];

sys = tf(numg, deng)
[mag,phase,w]=bode(sys);

dimensions = size(mag);
n = dimensions(3);

for i = 1:n,
    magDB(i) = 20*log10(mag(:,:,i));
    phase2(i) = phase(:,:,i);
end
 
subplot(211), semilogx(w/(2*pi), magDB)
grid on
xlabel('Frequency (Hz)'), ylabel('Gain dB')
title('Bode Plot for RLC High-Pass Filter')

subplot(212), semilogx(w/(2*pi), phase2)
grid on
xlabel('Frequency (Hz)'), ylabel('Phase deg')
