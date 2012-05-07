% This script creates an allpass filter - i.e. we design the phase response (and
% group delay) of a filter to yield a desired response.  The question is, can we
% use adaptive filter techniques to modify the delay out of each bandpass
% filter?
%
% For linear phase FIR filters (such that h(t) is even or odd (anti-) symmetric)
% we have a constant group delay equal to N/2.  A 2nd filter stage of allpass
% design would add an increased group delay (constant or otherwise).  In this
% case, we simply need to increase or decrease the allpass filter order
% depending on the (slowly changing) input signal envelope.  In hardware, we
% would just connect to a different tap in the allpass lattice structure.
%
% 


clear

% define time series information
fs = 2.5e6;           % sampling rate
tLen = .004;        % time series length
pTime = [.001]';       % pulse location
N0 = -Inf;          % noise level

% define pulse train characteristics (M components)
pulse.time = [0 .002]';         % start and stop times [sec] - 2xM matrix
pulse.freq = 1e3*[50 25; 100 50]';      % start and stop frequencies [Hz] - 2xM matrix
pulse.modFn = {'hfm'};            % pulse modulation type [char array or 1xM cell]
pulse.winFn = {@raisedcos};         % amplitude shading function [function handle, char array, or 1xM cell]
pulse.gain = [1 .7];                 % amplitude of pulse [arbitrary]
pulse.phase = -0.5*pi;         % initial phase per component [radians] - real or 1xM array

% generate a pulse train
P(1) = pulse;
%P(2) = pulse;
ts = gen_pulsetrain(fs, tLen, pTime, N0, P);

% create a linear phase FIR bandpass filter
N = 80;
F = [0 .2 .25 .3 .35 1];
A = [0 0 1 1 0 0];
b1 = firpm(N,F,A);
figure
freqz(b1)
% group delay is N/2 = 20 samples = 20us @ 1MHz


% create allpass filter
c = b1;
figure
freqz(c,[1 fliplr(c)])


%%
y = filter(b,1,ts.data);

figure
plot(ts.time,ts.data,ts.time,y)

tfrpwv(ts.data+y);

%% 