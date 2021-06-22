function [Pinter, d, f]=beamDirsDistances2LineIntersect(P1, P2, P3, Pmov, d10, d20)

% set intial guess
t0 = [-100 -100 -100];

option = optimset('TolX',1e-6,'TolFun',1e-6,'MaxIter',10000,'MaxFunEvals',10000);
             
t = fsolve(@(t)localFnc(t, P1, P2, P3, Pmov, d10, d20), t0, option); 

% get intersections
N1=(Pmov-P1)/norm(Pmov-P1);
N2=(Pmov-P2)/norm(Pmov-P2);
N3=(Pmov-P3)/norm(Pmov-P3);

Pinter(1,:)=P1+t(1)*N1;
Pinter(2,:)=P2+t(2)*N2;
Pinter(3,:)=P3+t(3)*N3;

d(1)=norm(Pinter(1,:)-Pinter(2,:));
d(2)=norm(Pinter(2,:)-Pinter(3,:));

f=localFnc(t, P1, P2, P3, Pmov, d10, d20);

function f=localFnc(t, P1, P2, P3, Pmov, d10, d20)

% get beam directions
N1=(Pmov-P1)/norm(Pmov-P1);
N2=(Pmov-P2)/norm(Pmov-P2);
N3=(Pmov-P3)/norm(Pmov-P3);

% get points on the 3 lines
Pi1=P1+t(1)*N1;
Pi2=P2+t(2)*N2;
Pi3=P3+t(3)*N3;

% get distances:
f(1)=norm(Pi1-Pi2)-d10;
f(2)=norm(Pi2-Pi3)-d20;

temp1=(Pi1-Pi2)/norm(Pi1-Pi2);
temp2=(Pi3-Pi2)/norm(Pi3-Pi2);
f(3)=dot(temp1, temp2) + 1;


