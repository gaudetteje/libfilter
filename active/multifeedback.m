function [H,f0,Q] = multifeedback(f,P1,P2,P3,P4,P5,varargin)
% MULTIFEEDBACK calculates the frequency response of an MFB filter
% configuration given the passive component values and frequency points
%
% H = MULTIFEEDBACK(F,R1,R2,R3,C4,C5) configures the circuit as follows:
% 
%                     R1
%           +---------^^^--------+
%           |                    |
%           |              C5    |
%           |         +----||----+
%           |         |          |
%           |         |  |\      |
%     R3    |   R2    |  | \     |
% o---^^^---+---^^^---+--|- \    |
% Vin       |            |   \   |
%           |            |    )--+----o Vout
%           = C4         |   /
%           |         +--|+ /
%           |         |  | /
%           V         |  |/
%                     |
%                     V
%
%
%  The diagram shows a low-pass configuration.  Specifying 'high' as a
%  parameter will swap R's and C's to yield the appropriate filter.
%
%  See also sallenkey, mfbdesign, and skdesign

switch nargin
    case 6
        method = 'l';
    case 7
        method = varargin{1};
end

% calculate gain, peakedness, natural frequency, and transfer function
f0 = 1./(2*pi*sqrt(P1*P2*P4*P5));
if strcmp(method(1),'h')
    K = -P3/P1;
    Q = sqrt(P5/P4) * sqrt(P2/P1) / (P1/P3 + P2/P3 + 1);
%    Q = sqrt(P5/P4) * sqrt(P2/P1) / (P1/P3 + P2/P3 + 1);     %% highpass  %%% SOMETHING STILL INCORRECT HERE (off by a factor of -K)
else
    K = -P1/P3;
    Q = sqrt(P4/P5) / (sqrt(P1/P2) + sqrt(P2/P1) + sqrt(P1*P2)/P3);     %% lowpass
end

H = second_order(f,f0,Q,K,method);

% calculate circuit gain, GBP, and Slew Rate
disp(sprintf('In-band gain, A = %.3f', K));
GBP = 100*K*f0;
disp(sprintf('Recommended op-amp GBP > %.3f MHz', abs(GBP)*1e-6));
SR = pi*f0;
disp(sprintf('Recommended op-amp Slew-Rate > Vout-pp * %.3f V/us', SR*1e-6));
