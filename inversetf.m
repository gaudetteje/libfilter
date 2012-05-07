function [b,a,inv] = inversetf(Hd,Nb,Na)
% [B,A,INV] = INVERSETF(Hd,NB,NA) designs an IIR inverse-filter or equalizer 
% from the given magnitude response DFT (MAG) by minimizing the sum-squared 
% inverse-filter magnitude error MAG*INV - 1.  NB and NA are the
% numbers of zeros and poles in model B(z)/A(z).  FIR models are produced for 
% NA = 0, and all-pole models are produced for NB = 0.  To eliminate the 
% possibility of large variations in the model response between the frequency 
% samples, a relatively large number of samples should be given in MAG.  The
% models tend to be causal and minimum-phase, but they can always be made 
% causal, stable, and minimum-phase by reflecting poles and zeros outside 
% the unit circle to the interior of the unit circle. 
% This is a frequency-domain adaptation of Judell's algorithm.  
% Copyright, 2007, Leland B. Jackson.

%Hd = abs(mag);
[L,C] = size(Hd);
if C > 1, Hd = Hd.'; L = C; end
W = dftmtx(L); Wb = W; Wa = W;
Wb(:,Nb+2:L) = []; Wa(:,Na+2:L) = [];

r = ifft(Hd.^2);             % autocorrelation function
aL = levinson(r,L/2);
hL = impz(1,aL,Nb+2*Na+2);
[b,a] = prony(hL,Nb,Na); b=b.';    % initial model

for i = 1:10,                         % Judell's method
    [Hi,w] = freqz(b,a,L,'whole');
    Hbi = freqz(1,b,L,'whole');
    Pi = exp(j*angle(Hi));
    HdPi = Hd.*Pi;
    a = (diag(HdPi.*Hbi)*Wa)\ones(L,1); A = fft(a,L);
    if Na == 0, A = A'; end
    b0 = b;
    b = (diag(A.*Hbi.*Hbi.*HdPi)*Wb)\ones(L,1);
    b = 2*b0 - b;
end

b = b.'; a = a.';
a0 = a(1); b = b/a0; a = a/a0;
[H,w] = freqz(b,a,L,'whole'); Hm = abs(H);
E = Hd./Hm;
inv = 1./Hm;
plot(w/pi,Hm,'k-',w/pi,Hd,'k--')
xlabel('Normalized frequency (w/pi)'); ylabel('Magnitude')
legend('Model magnitude','Original magnitude','location','Best')
Next = 'After viewing magnitude plot, hit any key for inverse-error plot'
Sum_Sq_Error = sum((E-1).^2);pause
plot(w/pi,E)
Next = 'After viewing error plot, hit any key for pole/zero plot'
pause
zplane(b,a)

    
    