% ---L---+
%        |
%        C
%        |
%        R
%        |
%        +

clc
clear all


R=0
C=5e-6
L=100e-6

f = 10.^[2:0.001:6];
s = j*2*pi*f;

hNum = 1 + s*C*R;
hDen = 1 + s*C*R + s.^2*C*L;

H = hNum./hDen;

disp(sprintf('Natural frequency = %.2f',1/(2*pi*sqrt(L*C))));

figure;
%subplot(2,2,1);
semilogx(f,db(abs(H))); grid on;
title('|H|')
% 
% subplot(2,2,2);
% semilogx(f,angle(H)); grid on;
% title('<H')
% 
% subplot(2,2,3);
% semilogx(f,real(H)); grid on;
% title('Re(H)')
% 
% subplot(2,2,4);
% semilogx(f,imag(H)); grid on;
% title('Im(H)')
