function [Ps, Rs]=samplePointKMC(KMC, idkmc, t, teta, phi)

% KMC: KMC data set
% idkmc: id KMC
% t: axis parameters
% teta: angle into (Z-X plane) (radians)
% phi: angle into (Z-Y) plane  (radians)

% get point
Ps(1)=t*cos(teta)*cos(phi);
Ps(2)=t*cos(teta)*sin(phi);
Ps(3)=t*sin(teta);

% build frame
Nz=-Ps/norm(Ps);
Pi=[0 0 Ps(3)];
ty=Pi-Ps;
Nx=cross(ty,Nz)/norm(cross(ty,Nz));
Ny=cross(Nz, Nx);

% trasnform into global frame
Ps=apply4x4(Ps, KMC(idkmc).R, KMC(idkmc).Vectors.Point);

Nx=apply4x4(Nx, KMC(idkmc).R, [0 0 0]);
Ny=apply4x4(Ny, KMC(idkmc).R, [0 0 0]);
Nz=apply4x4(Nz, KMC(idkmc).R, [0 0 0]);
Rs=[Nx', Ny', Nz'];

