function [res,err] = passive_select(N,M)
% PASSIVE_SELECT finds commercially available electronic component values
%
% Passive component values fall into a standard series number (i.e. E3, E6,
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

% Precompute range of possible values in each decade (1-10)
vals = 10.^((0:M)./M);

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

