function H = first_order(f,f0,varargin)
% FIRST_ORDER  yields the standard first-order frequency response for a
% passive filter with the specified parameters
%
% H = FIRST_ORDER(F,F0) calculates a maximally flat (Q=.7071) lowpass
% filter response with cutoff, F0, unity gain over frequency points in F
% H = FIRST_ORDER(F,F0,'hpf') will calculate the high pass version

%  Author:  Jason Gaudette
%  Email:   jason.e.gaudette@navy.mil
%  Date:    09/03/12

mode = 'l';

switch nargin
    case 2
    case 3
        mode = varargin{1};
    otherwise
        error('Invalid number of arguments used')
end

% calculate numerator
switch mode(1)
    case 'l'
        Hn = 1;
    case 'h'
        Hn = f./f0;
    otherwise
        error('Unknown mode used')
end

% calculate denominator
Hd = 1 + 1i*f/f0;

% combine transfer function
H = Hn ./ Hd;
