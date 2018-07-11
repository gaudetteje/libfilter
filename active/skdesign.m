function filt = skdesign(A, f0, Q, seed, varargin)
% SKDESIGN uses a cookbook method to design a 2nd order Sallen-Key filter
%
%    FILT = SKDESIGN(A,F0,Q,SEED) designs a low-pass Sallen-Key topology using
%           gain A, natural frequency F0, peakedness Q, and starting value SEED for C3.
%    FILT = SKDESIGN(A,F0,Q,SEED,'high') designs a high-pass version using C1 as
%           the seeded value.
%
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
% Equations derived from Jung, Walter G., "Op Amp Applications." Analog
%   Devices, 2002
%
% See also mfbdesign, sallenkey, and multifeedback.

switch nargin
    case 4
        method = 'l';
    case 5
        method = varargin{1};
end

switch method(1)
    case 'l'
        filt.C3 = seed;
        k = 2*pi*f0*filt.C3;
        m = 1/(2*Q)^2 + (A-1);
        filt.C4 = m * filt.C3;
        filt.R1 = 2*Q/k;
        filt.R2 = 1/(2*Q*m*k);
    case 'h'
        filt.C1 = seed;
        filt.C2 = filt.C1;
        k = 2*pi*f0*filt.C1;
        gamma = 1/Q + sqrt(1/Q^2 + (A-1));
        filt.R3 = gamma/(4*k);
        filt.R4 = 4/(gamma*k);
    otherwise
        error(sprintf('Invalid design method:  %s', method));
end

if A==1
    filt.Ra = 0; filt.Rb = 0;
else
    filt.Ra = 10e3;
    filt.Rb = filt.Ra * (A-1);
end

