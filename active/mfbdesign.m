function filt = mfbdesign(A, f0, Q, seed, varargin)
% MFBDESIGN uses a cookbook method to design a 2nd order multiple feedback
%    filter.
%
%    FILT = MFBDESIGN(A,f0,Q,SEED) designs a low-pass MFB topology using
%           gain, A, cutoff frequency, f0, filter peakness, Q, and starting
%           value SEED, C5.
%    FILT = MFBDESIGN(A,f0,Q,SEED,'high') designs a high-pass version using
%           C3 as the seeded value.
%
% Note that the MFB topology is inverting and gain, A, is assumed negative.
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
% Equations derived from Jung, Walter G., "Op Amp Applications." Analog
%   Devices, 2002
%
% See also skdesign, sallenkey, and multifeedback.

switch nargin
    case 4
        method = 'l';
    case 5
        method = varargin{1};
end

A = abs(A);     % take positive value for passive value calculations below

switch method(1)
    case 'l'
        filt.C5 = seed;
        k = 2*pi*f0*filt.C5;
        filt.C4 = (2*Q)^2 *(A+1) * filt.C5;
        filt.R3 = 1/(2*Q*A*k);
        filt.R2 = 1/(2*Q*(A+1)*k);
        filt.R1 = 1/(2*Q*k);
        
    case 'h'
        filt.C3 = seed;
        filt.C2 = filt.C3;
        filt.C1 = filt.C3/A;
        k = 2*pi*f0*filt.C3;
        filt.R4 = 1/(Q*k*(2+1/A));
        filt.R5 = Q*A*(2+1/A)/k;
    otherwise
        error(sprintf('Invalid design method:  %s', method));
end
