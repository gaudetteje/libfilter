% Allpass filter design testbed
%
% Designs an allpass filter with a prespecified group delay using the
% least squares solver in the optimization toolbox.

close all
clear
clc

% Example from Deczky's paper:
%[b,a] = ellip(4,.5,32,.5);
%[b,a] = cheby1(4,.5,.5);
[b,a] = cheby2(4,32,.5);

npts = 1000;
W = linspace(0,pi,npts);  % vector of frequencies
G = grpdelay(b,a,npts);
%wc = .6*pi;  % cutoff frequency
%wt = tansig(20*(wc-W))*5+5;  % if you have neural net
wt = ones(size(W));  % no weights

%c = 2*max(G);
c = 20;
GD = c-G;  % Desired group delay: constant - G

N = 20;   % number of 2nd order allpass sections (half order of filter)

r_init = .9*rand(N,1);
theta_init = ((1:N)'-.5)*pi/N;

params = lsqnonlin(@(x) apfun(x,W,GD,wt), [r_init theta_init]);
%params = leastsq('apfun',[r_init; theta_init],f,[],w,GD,wt);
%params = fminimax('apfun',[r_init; theta_init],f,[],[],[],w,GD,wt);

% Now create filter from parameters:

r = params(:,1);
%ind = find(abs(r)>1.0)
%r(ind) = 1./r(ind);
theta = params(:,2);

% poles
p = [r.*exp(1i*theta); r.*exp(-1i*theta)];
%  p = r.*exp(j*theta);
% zeros
z = [(1./r).*exp(1i*theta); (1./r).*exp(-1i*theta)];
%  z = (1./r).*exp(j*theta);

[b1,a1] = zp2tf(-z,-p,1);

b1 = b1/sum(b1);
a1 = a1/sum(a1);


%% plot results
subplot(211)
[H,W] = freqz(b,a,npts);
Ha = freqz(b1,a1,npts);
plot(W/pi,db(abs(H)),'b')
grid on; hold on;
plot(W/pi,db(abs(Ha)),'r')
title('Magnitude response of filter')

subplot(212)
G0 = grpdelay(b,a,W);
G1 = grpdelay(b1,a1,W);
plot(W/pi,[G0 G1 G0+G1])
grid on
title('Group delay')
xlabel('Frequency (Hz)')
legend('Original filter','Equalizer','Sum')
