function H = second_order(f,f0,varargin)
% SECOND_ORDER  yields the standard second order frequency response for a
% filter with the specified parameters
%
% H = SECOND_ORDER(F,F0) calculates a maximally flat (Q=.7071) lowpass
% filter response with cutoff, F0, unity gain over frequency points in F
% H = SECOND_ORDER(F,F0,Q) uses specified peakedness, Q
% H = SECOND_ORDER(F,F0,Q,H0) applies linear gain, H0
% H = SECOND_ORDER(F,F0,Q,H0,'hpf') will calculate the high pass version

% default values
Q = 1/sqrt(2);
H0 = 1;
mode = 'l';

switch nargin
    case 2
    case 3
        Q = varargin{1};
    case 4
        Q = varargin{1};
        H0 = varargin{2};
    case 5
        Q = varargin{1};
        H0 = varargin{2};
        mode = varargin{3};
    otherwise
        error('Invalid number of arguments used')
end

% calculate numerator
switch mode(1)
    case 'l'
        Hn = H0;
    case 'h'
        Hn = -H0 * (f./f0).^2;
    otherwise
        error('Unknown mode used')
end

% calculate denominator
Hd = 1 - (f./f0).^2 + (1i/Q)*(f./f0);

% combine transfer function
H = Hn ./ Hd;
