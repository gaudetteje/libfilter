function [H,f0] = seriesrc(f,P1,P2,varargin)
% SERIESRC calculates the frequency response of a passive RC filter
% given the passive component values and frequency points
%
% H = SERIESRC(F,R1,C2) configures the circuit as follows:
%
%         R1
% Vin o---^^^---+----o Vout
%               |
%               = C2
%               |
%               V
%
%  The diagram shows a low-pass configuration.
%
%  [H,F0] = SERIESRC(F,R1,C2) returns the calculated natural frequency of
%  the filter.
%
%  Specifying 'high' as a parameter will swap R's for C's to yield the
%  appropriate filter.  The parameters are entered in the same order ,i.e.:
%
%  H = SERIESRC(F,C1,R2,'high')
%
%

%  Author:  Jason Gaudette
%  Email:   jason.e.gaudette@navy.mil
%  Date:    8/19/08

switch nargin
    case 3
        method = 'l';
    case 4
        method = varargin{1};
end

f0 = 1./(2*pi*P1*P2);
H = first_order(f,f0,method);
