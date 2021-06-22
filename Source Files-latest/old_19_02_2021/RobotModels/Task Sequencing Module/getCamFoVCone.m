function [Lmin, Lmax, alfa]=getCamFoVCone(rob)

% Lmin: min focal length
% Lmax: max focal length
% alfa: cone aperture angle

%
Lmin=rob.Parameter.Tool.Camera.Intrinsic.Parameter.WorkingDistance(1);
Lmax=rob.Parameter.Tool.Camera.Intrinsic.Parameter.WorkingDistance(2);

%
scw=Lmin / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(1);
sch=Lmin / rob.Parameter.Tool.Camera.Intrinsic.Parameter.Focal(2);

x0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.W/2*scw; % principal point x
y0=rob.Parameter.Tool.Camera.Intrinsic.Parameter.H/2*sch; % principal point y

% radius of the circle
rad=max([x0, y0]);

alfa=2*atan(rad/Lmin)*180/pi;


