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

R=4530;
C=1.5E-9;
L=132E-3;

% Resonant frequency (Hz)
fo = 1/(2*pi*sqrt(L*C))
% Resonant frequency (rad/sec)
wo = 1/sqrt(L*C)
% Damping factor (alpha) for parallel RLC circuit
alpha = 1/(2*R*C)

% Resistance for critical damping (alpha=wo)
Rcritical = sqrt(L*C)/(2*C)

if alpha > wo
   'Overdamped' 
elseif alpha == wo
   'Critically Damped' 
elseif alpha < wo
   'Underdamped'
end

numg=[(R*L*C) 0 0];
deng = [R*L*C L R];

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
