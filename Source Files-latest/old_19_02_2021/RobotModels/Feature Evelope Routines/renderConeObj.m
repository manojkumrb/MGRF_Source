function [X, Y, Z]=renderConeObj(fmin, fmax, alfa, phi, P0, N0, res)

% fmin/fmax: min and max truncation along the cone axis
% alfa/phi: angle in degree
% P0/N0: position and cone axis

alfa=alfa*pi/180;
phi=phi*pi/180;

rmin=fmin*tan(alfa/2);
rmax=fmax*tan(alfa/2);

r=linspace(rmin,rmax,res);
phi = linspace(phi(1),phi(2),res);
[r,phi] = meshgrid(r,phi);

X = r.*cos(phi);
Y = r.*sin(phi);
Z = repmat(linspace(fmin,fmax,res),res,1);

% get base:
R=vector2Rotation(N0);

%...
P=[X(:),Y(:),Z(:)];

P=apply4x4(P, R, P0);

%... then
X=reshape(P(:,1),res,res);
Y=reshape(P(:,2),res,res);
Z=reshape(P(:,3),res,res);

