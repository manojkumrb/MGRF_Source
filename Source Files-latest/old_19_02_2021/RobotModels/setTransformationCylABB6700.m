% set trasformation for cylinder (ABB 6700)
function T=setTransformationCylABB6700(rob, Tfk)

% extract T03 and T3r
[T3r, T03]=retrieveT3r(rob, Tfk{3});

Tfk{3}=T03; % set cal pose
T03=setTransformation(Tfk, 3);

%--
P1=rob. Parameter.Cylinder.P1;
P2=rob. Parameter.Cylinder.P2;

% build frame attached to cylinder
T3cyl=buildTcyl(P1, P2);

% apply roration
P1=apply4x4(P1,T3r(1:3,1:3),T3r(1:3,4)'); % rotation around joint [3]

A=norm(P2);
B=norm(P1);

C=norm(P1-P2);

% rotation fo the cylinder
gamma=-real(acos((A^2+C^2-B^2)/(2*A*C)));
Tcylg=eye(4,4); Tcylg(1:3,1:3)=getRotZ(gamma); 

% build final trasformation
T=T03*T3cyl*Tcylg;

%---------
function R=getRotZ(teta)

R=[cos(teta) -sin(teta) 0
   sin(teta) cos(teta)  0
   0         0          1];

%--
function T=buildTcyl(P1, P2)

% define base into omega 3 frame
x=(P1-P2)/norm(P1-P2);
z=[0 0 1];
y=cross(z, x)/norm(cross(z, x));

R=[x' y' z'];

T=eye(4,4);
T(1:3,1:3)=R; T(1:3,4)=P2;

%--
function [T3r, T03]=retrieveT3r(rob, T0r)

L3=rob.Parameter.L3;

T03=eye(4,4);
T03(1:3,1:3)=[1 0  0
               0 0  1
               0 -1 0];
T03(1:3,4)=[L3(1) 0 L3(2)];

T3r=inv(T03)*T0r; %#ok<MINV>
