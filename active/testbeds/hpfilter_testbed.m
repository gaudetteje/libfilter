% High-pass filter testbed

clear

f = 10.^[0:.006:6];
a = [f(1) f(end) -80 20];

% design parameters
Fc = 16e3;
A = 1;

%% LPF design

% % 3rd order LPF Butterworth pole locations
% a1LP = 0.5;
% b1LP = 0.866;
% F1LP = 1.0;
% Q1   = 1.0;
% a2LP = 1.0;
% F2LP = 1.0;

% % 3rd order LPF Chebychev 0.01dB pole locations
% a1LP = 0.4233;
% b1LP = 0.8663;
% F1LP = 0.9642;
% Q1   = 1.1389;
% a2LP = 0.8467;
% F2LP = 0.8467;

% 3rd order LPF Chebychev 0.1dB pole locations
a1LP = 0.3490;
b1LP = 0.8684;
F1LP = 0.9359;
Q1   = 1.3408;
a2LP = 0.6970;
F2LP = 0.6970;

% % 3rd order LPF Chebychev 0.5dB pole locations
% a1LP = 0.2683;
% b1LP = 0.8753;
% F1LP = 1.0688;
% Q1   = 1.7062;
% a2LP = 0.5366;
% F2LP = 0.6265;

%% HPF design
% translate to a 3rd order HPF  - Q remains unaffected
a1HP = a1LP/(a1LP^2 + b1LP^2);
b1HP = b1LP/(a1LP^2 + b1LP^2);
F1HP = 1/F1LP;
a2HP = 1/a2LP;
F2HP = 1/F2LP;

% design HPF SK & passive stage
f1.Cp = 220e-12;                       % seed value
f1.Rp = 1/(2*pi*f1.Cp*Fc*F2HP);
f2a = skdesign(A, Fc*F1HP, Q1, f1.Cp, 'h')
f2b = mfbdesign(A, Fc*F1HP, Q1, f1.Cp, 'h')

% perform filter stage analysis
[H1,f0] = seriesrc(f,f1.Cp,f1.Rp,'h');
figure(1); semilogx(f,db(abs(H1)),'m'); grid on; hold on;
figure(2); semilogx(f,180*angle(H1)/pi,'m'); grid on; hold on;
disp(sprintf('Passive Stage: fc = %.3f', f0))

[H2a,f0,Q] = sallenkey(f,f2a.C1,f2a.C2,f2a.R3,f2a.R4,f2a.Rb,f2a.Ra,'h');
figure(1); semilogx(f,db(abs(H2a)),'b'); grid on; hold on;
figure(2); semilogx(f,180*angle(H2a)/pi,'b'); grid on; hold on;
disp(sprintf('Active Stage:  F0 = %.2f, Q = %.3f',f0,Q))

[H2b,f0,Q] = multifeedback(f,f2b.C1,f2b.C2,f2b.C3,f2b.R4,f2b.R5,'h');
figure(1); semilogx(f,db(abs(H2b)),'c'); grid on; hold on;
figure(2); semilogx(f,180*angle(H2b)/pi,'c'); grid on; hold on;
disp(sprintf('Active Stage:  F0 = %.2f, Q = %.3f',f0,Q))


%% combine stages (does not account for loading between stages!)
Htot = H1 .* H2b;
figure(1); semilogx(f,db(abs(Htot)),'-k'); grid on;
title('FAI R2 Filter Stages'); axis(a)
legend('Passive Stage HPF', 'SK Active Stage', 'MFB Active Stage', 'Total Response', 'Location', 'SouthWest')
figure(2); semilogx(f,180*angle(Htot)/pi,'-k'); grid on;
