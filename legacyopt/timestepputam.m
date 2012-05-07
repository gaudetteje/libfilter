function [u1,ind] = timestepput(u,A,c,A1,c1,S,X)
% TIMESTEP  computes one timestep of the crank-nicholson FD computation
%        For European put options.
%
%       Reference: John C Hull : Options, Futures and other derivatives, Chap 15.


N=length(u);
u1=zeros(N,1);
u1(1)=X;
rhs=A1*u(2:N-1);
rhs(1)=rhs(1)+c1(1)*u(1);
rhs(1)=rhs(1)-c(1)*u1(1);
u1(2:N-1)=A\rhs;
ind=find(u1 > X-S );
ind=ind(1)-1;
u1=max(u1,X-S);
