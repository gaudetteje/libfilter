% Testbed for validation of circuit analysis
%
% All filters are designed for 2nd order -3dB cutoff of 10kHz using the TI
% FilterPro design tool.  Note that Chebychev cutoff frequencies were
% normalized to yield a -3dB response at 10kHz (see ADI Op-Amp Applications
% Handbook, pg. 326, Table 1).

clear
clc

f = 10.^[0:.06:6];
s = j*2*pi*f;
a1 = [f(1) f(end) -80 20];
a2 = [f(1) f(end) -190 10];

% sallen-key butterworth LPF
R1 = 2.74e3; R2 = 17.8e3;
C3 = 4.7e-9; C4 = 1.1e-9;
[Ha1,f0,Q] = sallenkey(f,R1,R2,C3,C4,0,0);
fn1 = sprintf('SK Butterworth Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha1)),'b','DisplayName',fn1); grid on; hold on;
figure(2); semilogx(f,180.*angle(Ha1)./pi,'b','DisplayName',fn1); grid on; hold on;
disp(fn1)

% sallen-key butterworth HPF
C1 = 5.6e-9; C2 = 0.91e-9;
R3 = 3.4e3; R4 = 14.3e3;
[Hb1,f0,Q] = sallenkey(f,C1,C2,R3,R4,0,0,'high');
fn1a = sprintf('SK Butterworth High-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Hb1)),'-b','DisplayName',fn1a); grid on; hold on;
figure(2); semilogx(f,180.*angle(Hb1)./pi,'-b','DisplayName',fn1a); grid on; hold on;
disp(fn1a)

% multiple feedback butterworth LPF
R1 = 7.87e3; R2 = 11.0e3; R3 = 7.87e3;
C4 = 3.9e-9; C5 = 0.75e-9;
[Ha2,f0,Q] = multifeedback(f,R1,R2,R3,C4,C5);
fn2 = sprintf('MFB Butterworth Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha2)),'g','DisplayName',fn2); grid on;
figure(2); semilogx(f,180.*angle(Ha2)./pi,'g','DisplayName',fn2); grid on; hold on;
disp(fn2)

% sallen-key cheby type-I (0.1dB) LPF - f0dB = 5,169.8Hz
R1 = 2.67e3; R2 = 17.4e3;
C3 = 5.6e-9; C4 = 1.1e-9;
[Ha3,f0,Q] = sallenkey(f,R1,R2,C3,C4,0,0);
fn3 = sprintf('SK Chebychev (0.1dB) Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha3)),'r','DisplayName',fn3); grid on; hold on;
figure(2); semilogx(f,180.*angle(Ha3)./pi,'r','DisplayName',fn3); grid on; hold on;
disp(fn3)

% multiple feedback cheby type-I (0.1dB) LPF - f0dB = 5,169.8Hz
R1 = 7.32e3; R2 = 11.0e3; R3 = 7.32e3;
C4 = 4.7e-9; C5 = 0.75e-9;
[Ha4,f0,Q] = multifeedback(f,R1,R2,R3,C4,C5);
fn4 = sprintf('MFB Chebychev (0.1dB) Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha4)),'m','DisplayName',fn4); grid on;
figure(2); semilogx(f,180.*angle(Ha4)./pi,'m','DisplayName',fn4); grid on; hold on;
disp(fn4)

% sallen-key cheby type-I (0.25dB) LPF - f0dB = 6,256.2Hz
R1 = 2.61e3; R2 = 17.4e3;
C3 = 6.2e-9; C4 = 1.1e-9;
[Ha5,f0,Q] = sallenkey(f,R1,R2,C3,C4,0,0);
fn5 = sprintf('SK Chebychev (0.25dB) Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha5)),'k','DisplayName',fn5); grid on; hold on;
figure(2); semilogx(f,180.*angle(Ha5)./pi,'k','DisplayName',fn5); grid on; hold on;
disp(fn5)

% multiple feedback cheby type-I (0.25dB) LPF - f0dB = 6,256.2Hz
R1 = 7.5e3; R2 = 11.0e3; R3 = 7.5e3;
C4 = 5.1e-9; C5 = 0.75e-9;
[Ha6,f0,Q] = multifeedback(f,R1,R2,R3,C4,C5);
fn6 = sprintf('MFB Chebychev (0.25dB) Low-pass:  F0 = %.2f, Q = %.3f',f0,Q);
figure(1); semilogx(f,db(abs(Ha6)),'c','DisplayName',fn6); grid on;
figure(2); semilogx(f,180.*angle(Ha6)./pi,'c','DisplayName',fn6); grid on; hold on;
disp(fn6)

legend show
