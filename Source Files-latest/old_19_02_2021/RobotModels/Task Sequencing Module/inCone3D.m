% extract ids of point "Pi" inside cone (Pc, Nc)
function ids=inCone3D(Pi, Pc, Nc, alfa, Lmax)

np=size(Pi,1);

% init output
ids=1:np;

% Pi-P
Pic=Pi;
Pic(:,1)=Pi(:,1)-Pc(1); Pic(:,2)=Pi(:,2)-Pc(2); Pic(:,3)=Pi(:,3)-Pc(3);

% check condition 1: 0<=dot(Pi-P, Nc)<=Lmax
n=Nc';
t1=Pic*n;

% check condition 2: angle=acos(dot((Pi-P)/norm(Pi-P), Nc))<=alfa/2
Picn=Pic./repmat(sqrt(sum(Pic.^2,2)),1,3);
t2=acos(Picn*n);

% save out
ids=ids(t1>=0 & t1<=Lmax & t2<=alfa/2*pi/180);