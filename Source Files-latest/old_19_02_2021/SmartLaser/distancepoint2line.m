function d=distancepoint2line(P0,N0,Pi)

t=dot(Pi-P0, N0);

Pp=P0+t*N0;

d=norm(Pi-Pp);