%%

L = 75e-6;
C = 3e-6;

f=10.^[0:.01:6];
w=2*pi*f;
s = j*w;

H1 = 1./(1+s.^2*L*C);        % simple LC lowpass
H2 = 

semilogx(f,db(abs(H1)))
grid on