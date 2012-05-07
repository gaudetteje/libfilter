function hd = frac_lagrange(N,D)
% FRAC_LAGRANGE
%
% Design a fractional delay (FD) filter using Lagrange interpolation.  This
% type of filter is considered to be maximally flat.
%
% Hd = frac_lagrange(N,D) designs an Nth order FIR filter with fractional
% delay, D, and returns the length N+1 impulse response, Hd.  Magnitude
% response is unity at DC, but depends on frequency.  Higher order filters
% better approximate a wideband response.
%
% [1]  T. I. Laakso, V. Valimaki, M. Karjalainen, and U. K. Laine,
%      "Splitting the unit delay [FIR/all pass filters design]," Signal
%      Processing Magazine, IEEE DOI - 10.1109/MSP.2005.1511833, vol. 13,
%      no. 1, pp. 30-60, 1996.

hd = zeros(N,1);

for n=0:N
    h = 1; % reset h
    for k=0:N
        if (k ~= n)
            h = h * (D-k)/(n-k);
        end
    end
    hd(n+1) = h;        % assign coefficient
end

flipud(hd);
