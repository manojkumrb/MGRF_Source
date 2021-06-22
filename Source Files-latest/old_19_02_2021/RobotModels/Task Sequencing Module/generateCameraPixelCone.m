function vfov=generateCameraPixelCone(rob, RayTracying, focalplane)

% INPUTs:
% rob: robot model
% RayTracying: ray tracying data
% focalplane: focal plane id: 1/2 => upper plane / lower plane

% OUTPUT:
% vfov: [x y z] of pixel points

P0c=RayTracying.Point;
N0c=RayTracying.Normal;
resimage=RayTracying.ResolutionImage;

% OUTPUT:
% vfov: [x y z] of pixel points

Lm=rob.Parameter.Tool.Camera.Intrinsic.Parameter.WorkingDistance(focalplane);
scw=Lm / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(1);
sch=Lm / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(2);

x0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.W/2*scw; % principal point x
y0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.H/2*sch; % principal point y

% radius of the circle
rad=max([x0, y0]);

r=linspace(0, rad, resimage); 
theta=linspace(0, 2*pi, resimage); 

[R, THETA]=meshgrid(r, theta);

X=R.*cos(THETA);
Y=R.*sin(THETA);
Z=ones(size(X))*Lm;

vfov=[X(:), Y(:), Z(:)];

% transform back
R0c=vector2Rotation(N0c);
vfov=apply4x4(vfov, R0c, P0c);



