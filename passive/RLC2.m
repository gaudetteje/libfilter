% ---Rs--+-+
%        | |
%        L R
%        | |
%        +-+
%        |
%        C
%        |
%        +

clc
clear all


Rs=50
R=50
C=1e-6
L=10e-3

f = 10.^[0:0.06:6];
s = j*2*pi*f;

hNum = 1 + s*C*R;
hDen = 1 + s*C*R + s.^2*C*L;

H = hNum./hDen;

figure;
subplot(2,2,1);
semilogx(f,db(abs(H))); grid on;
title('|H|')

subplot(2,2,2);
semilogx(f,angle(H)); grid on;
title('<H')

subplot(2,2,3);
semilogx(f,real(H)); grid on;
title('Re(H)')

subplot(2,2,4);
semilogx(f,imag(H)); grid on;
title('Im(H)')
