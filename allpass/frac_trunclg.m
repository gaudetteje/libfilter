function hd = frac_trunclg(N,M,D)
% FRAC_TRUNCLG
%
% Design a fractional delay (FD) filter using truncated Lagrange
% interpolation.
%
% Hd = frac_trunclg(N,M,D) designs an Nth order FIR filter with fractional
% delay, D, and returns the length N+1 implulse response, Hd.  M > N is the
% Mth order prototype Lagrange FD filter truncated to Nth order.
% 
% [1] V. Valimaki and A. Haghparast, "Fractional Delay Filter Design
%     Based on Truncated Lagrange Interpolation," IEEE Signal Processing
%     Letters, vol. 14, no. 11, pp. 816-819, Nov. 2007.

hd = zeros(N,1);
K1 = (M-N)/2;

for n=0:N
    h = 1; % reset h
    for k=0:N
        if (k ~= n+K1)
            h = h * (D-k)/(n+K1-k);
        end
    end
    hd(n+1) = h;        % assign coefficient
end

flipud(hd);
