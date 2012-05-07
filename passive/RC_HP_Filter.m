clear all;

R=4530;
C=3E-9;

numg=[R*C 0];
deng = [R*C 1];

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
title('Bode Plot for RC High-Pass Filter')

subplot(212), semilogx(w/(2*pi), phase2)
grid on
xlabel('Frequency (Hz)'), ylabel('Phase deg')
