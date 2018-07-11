function filt = biquad_design(A, f0, Q, C, R, varargin)
% BIQUAD_DESIGN uses a cookbook method to design a 2nd order Biquadratic filter
%
%    FILT = biquad_design(A,F0,Q,C,R) designs a low-pass biquadratic
%           topology using gain A, natural frequency F0, peakedness Q, and
%           seed values C and R.
%    FILT = biquad_design(A,F0,Q,C,R,'high') adds a high-pass section
%    FILT = biquad_design(A,F0,Q,C,R,'notch') adds a notch section
%    FILT = biquad_design(A,F0,Q,C,R,'allpass') adds an all-pass section
%
%   <schematic diagram to be drawn>
%
% Equations derived from Jung, Walter G., "Op Amp Applications." Analog
%   Devices, 2002
%
% See also mfbdesign, sallenkey, and multifeedback.

switch nargin
    case 5
        method = 'l';
    case 6
        method = varargin{1};
    otherwise
        error('Invalid number of parameters entered')
end

switch method(1)
    case 'l'
        k = 2*pi*f0*C;
        filt.C1 = C;
        filt.C2 = C;
        filt.R1 = R/A;
        filt.R2 = R;
        filt.R3 = Q/k;
        filt.R4 = 1/(R*k^2);
        
        % inverted LP stage
        filt.R5 = R;
        filt.R6 = R;
    case 'h'
    case 'n'
    case 'a'
    otherwise
        error(sprintf('Invalid design method:  %s', method));
end

