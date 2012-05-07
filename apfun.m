function err = apfun(params, w, GD, wt)
%APFUN  Allpass error function for use by LEASTSQ.
%  Inputs:
%  Params is a length 2*N vector of r and theta for
%  the N allpass sections of the form:
%            1 - z*r*exp(-j*theta)
%     H(z) = ----------------------
%              z - r*exp(j*theta)
%  w - vector of frequencies (between 0 and pi)
%  GD - desired group delay at frequencies w
%
%  Output:
%    G - GD, where G = sum of group delay terms for each section
%    The output has the same length as w and GD.

if nargin < 4
   wt = ones(size(w));
end

N = size(params,1);

% force column vectors
rho = params(:,1);
theta = params(:,2);

% constrain r to be inside unit circle:
%ind = find(abs(r)>1.0);
%r(ind) = 1./r(ind);

GD = GD(:);
w = w(:);
G = zeros(size(GD));
for i=1:N
    G = G + (1-rho(i).^2)./(1+rho(i).^2+2*rho(i)*cos(w-theta(i)));
    G = G + (1-rho(i).^2)./(1+rho(i).^2+2*rho(i)*cos(w+theta(i)));
end

err = abs((G - GD).*wt(:));
% make sure poles are inside unit circle
%err = (tansig(10*(max(r)-.9))*5+6) * min(err,1);

