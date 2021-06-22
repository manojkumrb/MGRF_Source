function varargout=fixedFocus2PlaneIntersection(rob, t1, p1, t2, goal, datum)

% rob: robot model

% t1: arm[1] joint
% p1: arm[1] pos
% t2: arm[2] joint
% goal:
  % .Distance: goal distance
  % .Tol: tolerance
% datum: nominal datum points

log.Angle=[];
log.Distance=[];
log.DistanceErr=[];
log.T=[];
log.Tcp=[];
log.Ndatum=[];

np=size(t1,1);
Nf=zeros(np,3);

% TCP point
Ptcp=p1(1,1:3);
log.Tcp=Ptcp;

for i=1:np
    theta=[t2(i,:)*pi/180 t1(i,4:5)*pi/180 1100];
    theta(3)=theta(3)+pi/2;

    % get robot conf
    T=joint2Pos(theta, rob);

    % moving mirror
    Ti=setTransformation(T, 5);
    Pmov=Ti(1:3,4)';
    
    % get robot conf
    norm(Pmov-Ptcp)
    theta(7)=norm(Pmov-Ptcp);
    T=joint2Pos(theta, rob);
    
    % save
    if i==1
        log.T=T;
    end
    
    % beam direction
    Nf(i,:)=(Pmov-Ptcp)/norm(Pmov-Ptcp);
end

% get normal to nominal plane
P0=datum(1,:);
P1=datum(3,:);
P2=datum(2,:);
[Rdatum, ~]=buildFrame3Pt(P0, P1, P2);
Ndatum=Rdatum(:,3)';

log.Ndatum=Ndatum;

% run optimisation
lb=ones(1,np)*0.01;
x0=ones(1,np)*200;

option = optimset('TolX',1e-3,'TolFun',1e-3,'Algorithm','active-set','MaxFunEvals',10000,'TolCon',1e-3,'MaxIter',1000);
xopt=fmincon(@(x)localObj(x, Ptcp, Nf, Ndatum),x0,[],[],[],[], lb, [], @(x)localCon(x, Ptcp, Nf, goal), option);

log.Angle=localObj(xopt, Ptcp, Nf, Ndatum);

Pp=zeros(np,3);
for i=1:np
   Pp(i,:)=Ptcp + xopt(i)*Nf(i,:);
end

% get distances
d=zeros(1,2);
for i=1:2
    d(i)=norm(Pp(1,:)-Pp(i+1,:));
end

log.Distance=d;
log.DistanceErr=d-goal.Distance;

varargout{1}=Pp;

if nargout==2
    varargout{2}=log;
end


% local functions
function f=localObj(x, Pf, Nf, Ndatum)

% get intersection point
Pt=zeros(3,3);
for i=1:3
    Pt(i,:)=Pf + x(i)*Nf(i,:); 
end

% get plane
[R, ~]=buildFrame3Pt(Pt(1,:), Pt(2,:), Pt(3,:));
Np=R(:,3);

% get distance from plane
f=acos(dot(Np, Ndatum))*180/pi;


function [c, ce]=localCon(x, Pf, Nf, goal)

eps=goal.Tol;
dgoal=goal.Distance;

dgoalr=[dgoal-eps
        dgoal+eps];

ce=[];

% get intersection point
Pt=zeros(3,3);
for i=1:3
    Pt(i,:)=Pf + x(i)*Nf(i,:); 
end

% get distances
d=zeros(1,2);
for i=1:2
    d(i)=norm(Pt(1,:)-Pt(i+1,:));
end

c(1)=-d(1) + dgoalr(1);
c(2)=-d(2) + dgoalr(2);
c(3)=d(1) - dgoalr(3);
c(4)=d(2) - dgoalr(4);



