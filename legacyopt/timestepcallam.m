function u1 = timestep(u,A,c,A1,c1,S,X,div)
% TIMESTEP  computes one timestep of the crank-nicholson finite difference computation
%	 For european call options.
%
%       Reference: John C Hull : Options, Futures and other derivatives, Chap 15.


N=length(u);
u1=zeros(N,1);
B=sparse(N-1,N-1);
B(1:N-2,1:N-2)=A;
B(N-2,N-1)=c(N-2);
B(N-1,N-2)=-1; B(N-1,N-1)=1;
rhs=A1*u(2:N-1);
rhs(N-2)=rhs(N-2)+c1(N-2)*u(N);
rhs=[rhs;(S(N)-S(N-1))*div];
u1(2:N)=B\rhs;
u1=max(u1,S-X);
