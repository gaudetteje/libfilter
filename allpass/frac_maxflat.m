function hd = frac_maxflat(N,D,w0)
% FRAC_MAXFLAT
%
% Design a fractional delay (FD) filter using a maximally flat FIR delay
%
% Hd = frac_maxflat(N,D,W0) designs an Nth order FIR filter with fractional
% delay, D, centered around normalized frequency, W0.  The length, N+1,
% impulse response, Hd, is returned.
%
% Notes:
% When w0 = 0, this function reduces to the Lagrange interpolation
%    method.  If a lowpass response is desired, use 'frac_lagrange'.
%
% The resulting filter (and hence delayed data) will be complex except for
%    W0 = 0.  If passing through real data, the imaginary part can be
%    thrown away after computing the result.
%
% [1]	E. Hermanowicz, "Explicit formulas for weighting coefficients of
%       maximally flat tunable FIR delayers," Electronics Letters, vol. 28,
%       no. 20, pp. 1936-1937, 1992.
%
% See also frac_lagrange, frac_trunclg

hd = zeros(N,1);

w0 = w0*pi;     % normalize Fs = 1

for n=0:N
    h = exp(1i*w0*(n-D));    % reset h to exp[j*w0*(n - D)]
    for k=0:N
        if (k ~= n)
            h = h * (D-k)/(n-k);
        end
    end
    hd(n+1) = h;        % assign coefficient
end

flipud(hd);
