function [H,f0,Q] = sallenkey(f,P1,P2,P3,P4,Rb,Ra,varargin)
% SALLENKEY calculates the frequency response of a Sallen-Key filter
% configuration given the passive component values and frequency points
%
% H = SALLENKEY(F,R1,R2,C3,C4,RB,RA) configures the circuit as follows:
%
%  Note: * denotes optional components; specify RB=RA=0 for unity gain
%
%                          RB*       RA*
%           +---------+----^^^---+---^^^---+
%           |         |          |         |
%           |         |  |\      |         |
%           |         |  | \     |         V
%           = C3      +--|- \    |
%           |            |   \   |
%           |            |    )--+----o Vout
%     R1    |   R2       |   /
% o---^^^---+---^^^---+--|+ /
% Vin                 |  | /
%                     |  |/
%                     |
%                     = C4
%                     |
%                     |
%                     V
%
%  The diagram shows a low-pass configuration with optional gain resistors.
%
%  [H,F0,Q] = SALLENKEY(F,R1,R2,C3,C4,RB,RA) returns the calculated natural
%   frequency and peakedness, Q, of the filter.
%
%  Specifying 'high' as a parameter will swap R's for C's to yield the
%  appropriate filter.  The parameters are entered in the same order ,i.e.:
%  
%  H = SALLENKEY(F,C1,C2,R3,R4,RB,RA,'high')
%
%  See also multifeedback, mfbdesign, and skdesign

switch nargin
    case 7
        method = 'l';
    case 8
        method = varargin{1};
end

% calculate gain
if ~Ra
    K = 1;
else
    K = 1+Rb/Ra;
end

% calculate peakedness, natural frequency, and transfer function
if strcmp(method(1),'h')
    Q = sqrt(P1*P2*P3*P4)/(P3*(P1+P2)+(P4*P2*(1-K)));  %% highpass
else
    Q = sqrt(P1*P2*P3*P4)/(P4*(P1+P2)+(P1*P3*(1-K)));  %% lowpass
end
f0 = 1./(2*pi*sqrt(P1*P2*P3*P4));
H = second_order(f,f0,Q,K,method);

% calculate circuit gain, GBP, and Slew Rate
disp(sprintf('In-band gain, 1+RB/RA, A = %.3f', K));
if Q>1
    GBP = 100*K*Q^3*f0;
else
    GBP = 100*K*f0;
end
disp(sprintf('Recommended op-amp GBP > %.3f MHz', abs(GBP)*1e-6));
SR = pi*f0;
disp(sprintf('Recommended op-amp Slew-Rate > Vout-pp * %.3f V/us', SR*1e-6));
