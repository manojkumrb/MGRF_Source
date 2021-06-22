function vfov=generateCameraPixelFrustum(rob, RayTracying, focalplane)

% INPUTs:
% rob: robot model
% RayTracying: ray tracying data
% focalplane: focal plane id: 1/2 => upper plane / lower plane

% OUTPUT:
% vfov: [x y z] of pixel points

P0c=RayTracying.Point;
R0c=RayTracying.R;
resimage=RayTracying.ResolutionImage;

Lm=rob.Parameter.Tool.Camera.Intrinsic.Parameter.WorkingDistance(focalplane);
scw=Lm / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(1);
sch=Lm / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(2);

x0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.W/2*scw; % principal point x
y0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.H/2*sch; % principal point y

x=linspace(-x0, x0, resimage); 
y=linspace(-y0, y0, resimage); 

[X, Y]=meshgrid(x, y);
Z=ones(size(X))*Lm;

vfov=[X(:), Y(:), Z(:)];

vfov=apply4x4(vfov, R0c, P0c); 
