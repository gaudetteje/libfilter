function [res,err] = passive_select(M,varargin)
% PASSIVE_SELECT finds commercially available electronic component values
%
% Passive component values fall into a standard series number (i.e. E6,
% E12, E24, E96).  The series number defines how many values exist within 
% each decade.  This function will round values to the closest component
% available in a specified series.  This is valid for both, resistance and
% capacitance values.
%
% RES = passive_select(VAL,SERIES) takes a real number, VAL, and returns
%     a real value, RES, holding the suggested value.  SERIES is a positive
%     integer.
% [RES, ERR] = passive_select(...) also returns the % error between
%     desired and actual value.
%
% Note:  VAL can also be a row or column vector to evaluate multiple
%     passive component values.
%
% Note:  Components are typically rounded to the nearest 2 or 3 significant
%     digits, depending upon the tolerance.
%
% See also: http://www.venkel.com/PDFs/EAIThinFilms.pdf

%  Author:  Jason Gaudette
%  Email:   jason.e.gaudette@navy.mil
%  Date:    4/11/12

% precompute 20%, 10%, 5% values (minor difference in series rounding)
EIA6 = [1.0 1.5 2.2 3.3 4.7 6.8];
EIA12 = sort([EIA6 1.2 1.8 2.7 3.9 5.6 8.2]);
EIA24 = sort([EIA12 1.1 1.3 1.6 2.0 2.4 3.0 3.6 4.3 5.1 6.2 7.5 9.1]);

% ensure valid M base
assert(ismember(M,(2*3)*2.^(0:5)),'Invalid base entered.  Must be one of [6,12,24,48,96,192].')
switch(M)
    case 6
        vals = EIA6;
    case 12
        vals = EIA12;
    case 24
        vals = EIA24;
    case 96
        vals = unique([EIA24 round(10.^((0:M-1)./M).*100)./100]);      % EIA24 values are also available
    otherwise
        % Compute range of possible values in each decade (1-10)
        vals = round(10.^((0:M-1)./M)*100)./100;
end

% span entire decade if no values entered
if nargin > 1
    N = varargin{1};
else
    N = vals;
end

% Find which decade values correspond to
dec = fix(log10(N));

% Subtract decade from value
rem = N ./ 10.^dec;

% Round number to nearest possible value in decade
rnd = zeros(size(rem));
for n=1:numel(N)
    [~,idx] = min(abs(vals-rem(n)));
    rnd(n) = vals(idx);
end

% Return corresponding value and % error between desired and actual value
res = rnd .* 10.^dec;
err = 100*N/res; 

