function RayTracying=initRayTracying()

% RayTracying:
    % Point: camera position
    % Normal: camera axis direction
    % R: camera orientation
    % ResolutionImage: image resolution
    % SubModel: if true then the calculation is performed on the sub-model of the workpiece enclosed in the cone

    
RayTracying.Point=[0 0 0];
RayTracying.Normal=[0 0 1];
RayTracying.R=eye(3,3);
RayTracying.ResolutionImage=20;
RayTracying.SubModel=true;
RayTracying.FoVModel='cone';

RayTracying.Sol.Point=[]; % projected point within the FoV
RayTracying.Sol.Normal=[];% corresponding normals of the projected point within the FoV

RayTracying.Sol.PointU=[]; % points on the upper boundary of the FoV
RayTracying.Sol.PointL=[]; % points on the lower boundary of the FoV