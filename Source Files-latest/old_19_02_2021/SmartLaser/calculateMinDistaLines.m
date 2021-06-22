function [Ptline, Poline, d]=calculateMinDistaLines(PT, PO, NT, NO)

% t0=0.0;
% t=fminunc(@(t)localObj(t,P1, P2, N1, N2),t0);
% 
% Pinter=P1+t*N1;
% d=distancepoint2line(P2,N2,Pinter);
% 
% function d=localObj(t, P1, P2, N1, N2)
% 
% Pi=P1+t*N1;
% 
% d=distancepoint2line(P2,N2,Pi);

Tline=inv([1 -dot(NT,NO); dot(NT,NO) -1])*[dot((PO-PT),NT);dot((PO-PT),NO)];

%-
Ptline=PT+Tline(1)*NT;
%-
Poline=PO+Tline(2)*NO;

d=norm(Poline-Ptline);
           