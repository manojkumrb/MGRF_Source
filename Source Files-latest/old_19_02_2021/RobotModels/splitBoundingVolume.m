% split bounding volume
function bbs=splitBoundingVolume(bb, N, Loc)

% bb: input bounding volume
% N=[Nx, Ny, Nz]
% Loc=[i/j/k]: location of of the splitting volume

% bbs: splitted volume

%--
Nx=N(1); Ny=N(2); Nz=N(3); 

%--
i=Loc(1); j=Loc(2); k=Loc(3); 

%--
rx=bb.Range.X;
ry=bb.Range.Y;
rz=bb.Range.Z;

W=abs(diff(rx)/Nx);
L=abs(diff(ry)/Ny);
D=abs(diff(rz)/Nz);

s=rx(1);
rxl(1)=s+(i-1)*W; rxl(2)=s+i*W;

s=ry(1);
ryl(1)=s+(j-1)*L; ryl(2)=s+j*L;

s=rz(1);
rzl(1)=s+(k-1)*D; rzl(2)=s+k*D;

% save out
bbs=bb;
bbs.Range.X=rxl;
bbs.Range.Y=ryl;
bbs.Range.Z=rzl;

