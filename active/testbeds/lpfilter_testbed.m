% High-pass filter testbed

clear

f = 10.^[0:.006:6];
a = [f(1) f(end) -80 20];

% design parameters
Fc = 69e3;
A = 1;

%% LPF design

% 3rd order LPF Butterworth pole locations
a1LP = 0.5;
b1LP = 0.866;
F1LP = 1.0;
Q1   = 1.0;
a2LP = 1.0;
F2LP = 1.0;

% % 3rd order LPF Chebychev 0.01dB pole locations
% a1LP = 0.4233;
% b1LP = 0.8663;
% F1LP = 0.9642;
% Q1   = 1.1389;
% a2LP = 0.8467;
% F2LP = 0.8467;

% % 3rd order LPF Chebychev 0.1dB pole locations
% a1LP = 0.3490;
% b1LP = 0.8684;
% F1LP = 0.9359;
% Q1   = 1.3408;
% a2LP = 0.6970;
% F2LP = 0.6970;

% % 3rd order LPF Chebychev 0.5dB pole locations
% a1LP = 0.2683;
% b1LP = 0.8753;
% F1LP = 1.0688 / 1.16749;     % corrects for 0.5dB cheby response (-3dB cutoff @ Fc)
% Q1   = 1./0.5861;
% a2LP = 0.5366;
% F2LP = 0.6265 / 1.16749;     % corrects for 0.5dB cheby response (-3dB cutoff @ Fc)

% design LPF SK & passive stage
f1.Cp = 220e-12;                       % seed value
f1.Rp = 1/(2*pi*f1.Cp*Fc*F2LP);
f2a = skdesign(A, Fc*F1LP, Q1, f1.Cp)
f2b = mfbdesign(A, Fc*F1LP, Q1, f1.Cp)

% perform filter stage analysis
[Ha1,f0] = seriesrc(f,f1.Cp,f1.Rp);
figure(1); semilogx(f,db(abs(Ha1)),'m'); grid on; hold on;
figure(2); semilogx(f,180*angle(Ha1)/pi,'m'); grid on; hold on;
disp(sprintf('Passive Stage: fc = %.3f', f0))

[Ha2a,f0,Q] = sallenkey(f,f2a.R1,f2a.R2,f2a.C3,f2a.C4,f2a.Rb,f2a.Ra);
figure(1); semilogx(f,db(abs(Ha2a)),'b'); grid on; hold on;
figure(2); semilogx(f,180*angle(Ha2a)/pi,'b'); grid on; hold on;
disp(sprintf('Active Stage:  F0 = %.2f, Q = %.3f',f0,Q))

[Ha2b,f0,Q] = multifeedback(f,f2b.R1,f2b.R2,f2b.R3,f2b.C4,f2b.C5);
figure(1); semilogx(f,db(abs(Ha2b)),'c'); grid on; hold on;
figure(2); semilogx(f,180*angle(Ha2b)/pi,'c'); grid on; hold on;
disp(sprintf('Active Stage:  F0 = %.2f, Q = %.3f',f0,Q))


%% combine stages (does not account for loading between stages!)
Htot = Ha1 .* Ha2b;
figure(1); semilogx(f,db(abs(Htot)),'-k'); grid on;
title('FAI R2 Filter Stages'); axis(a)
legend('Passive Stage HPF', 'Active Stage HPF', 'Total Response', 'Location', 'SouthWest')
figure(2); semilogx(f,180*angle(Htot)/pi,'-k'); grid on;
