% ALLPASS_LSEE  designs an allpass filter for a given phase response
%
% Note: This technique appears to required using tau0 as a parameter and cannot
% be explicitly set as a desired result
%
% Referece:
% Lang and Laakso, Design of Allpass Filters for Phase Approximation and
% Equalization Using LSEE Error Criterion. IEEE (1992) p2417-2420

clc
clear
close all
npts = 1024;

% Input parameters
[b,a] = deal(1,1);%butter(10,[.1 .4]);
%figure;
%freqz(b,a,npts)

eps = .1;       % error tolerance

% Initialization
N = 8;          % order of allpass filter
L = 32;         % number of frequency points to match

wu = .4;        % upper frequency bound
wl = .1;        % lower frequency bound

% frequency samples
w_i = linspace(wl,wu,L);

% phase response of filter, H(z)
H = freqz(b,a,w_i*pi);
theta_H = unwrap(angle(H));

% maximum initial group delay
tau0 = (N*pi - theta_H(end))/wu;

% define Beta
beta = 0.5 * (theta_H + (tau0 - N)*w_i);

% define a(0)
b = -sin(beta)';
A = zeros(L,N);
for k=1:N
    A(:,k) = sin(beta' + k*w_i');
end
a = A\b;        % solve for a in LS sense

% iterate over solution to find LSEE
q = 0;
err = Inf;
while (err > eps)
    % increment q
    q = q+1;
    
    % compute b(q-1) - eqn. 9
    b = -sin(beta)';
    
    % compute A~(q-1) - eqn. 31
    for k=1:N
        A(:,k) = sin(beta' + k*w_i');
    end
    
    % solve A~(q-1) * [a(q); del_tau0(q)] = b(q-1) - eqn. 34 & 32
    a_last = a;
    a = A\b;  %[a(:,q); del_tau0(:,q)] = A \ b(:,q);
    
    % compute tau0 and beta - eqn. 30
    %tau0 = tau0 + del_tau0;
    beta = 0.5 * (theta_H + (tau0 - N)*w_i);
    
    % compute residual error
    %err = norm([a_q(q-1) - a_q(q-1); del_tau0]) / norm([a_q(q-1); tau0_q(q-1)]);
    err = norm(a_last - a) / norm(a_last);
    
end

% use last a(q) and tau0(q-1) for a and tau0;
%a = a_q(end);
%tau0 = tau0(end-1);
