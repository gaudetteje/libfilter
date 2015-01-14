function [y,e] = delay_signal(x,D)
% SIGNAL_DELAY  delays a sampled signal x by D samples using linear filter
% techniques;  D is any positive real number
%
% y = delay_signal(x,D) if D an integer, x is simply a shifted and zero
% padded replica
%
% Notes:
%   y has a sample length of numel(x)+ceil(D)
%   e is the impulse response error between the ideal sinc impulse delay
%     and the actual delay function used (frequency dependent)


% find fractional remainder
R = mod(D,1);

if R == 0
    tic
    h = [zeros(D-1);1];     % simple delay line
    y = filter(x,h,1);
    toc
    e = 0;
    return
end

% Fractional Delay Filter Methods
%frac_trunclg
%frac_lagrange
%frac_maxflat
