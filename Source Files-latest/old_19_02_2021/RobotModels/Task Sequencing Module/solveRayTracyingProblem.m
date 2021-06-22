% calculate the projected ray on the workpiece laying inside the FoV of the camera
function RayTracying=solveRayTracyingProblem(RayTracying, rob, part)

%-----------------
% NOTICE: in this part of the workflow we assume the FoV approximated by a cone
%-----------------

% INPUTs
% rob: robot model
% part: workpiece model (as generated by "femInit")
% RayTracying:
    % Point: camera position
    % Normal: camera axis direction
    % R: camera orientation
    % ResolutionImage: image resolution
        
% OUTPUTs
% varargout{1}: project point (nx3)
% varargout{2}: normal vector at projected point (nx3)

% generate xyz points within the FoV of the camera (using the specified image resolution) 
if strcmp(RayTracying.FoVModel,'cone')
    RayTracying.Sol.PointU=generateCameraPixelCone(rob, RayTracying, 1); % upper
    RayTracying.Sol.PointL=generateCameraPixelCone(rob, RayTracying, 2); % lower
else
    RayTracying.Sol.PointU=generateCameraPixelFrustum(rob, RayTracying, 1); % upper
    RayTracying.Sol.PointL=generateCameraPixelFrustum(rob, RayTracying, 2); % lower
end

% run ray tracying
[Pint, Nint, flag]=runRayTracying(part, RayTracying.Point, RayTracying.Sol.PointU, RayTracying.Sol.PointL);

% save output    
RayTracying.Sol.Point=Pint;
RayTracying.Sol.Normal=Nint;
RayTracying.Sol.Flag=flag;

                % RayTracying.Sol.Point=Pint(flag==true,:);
                % RayTracying.Sol.Normal=Nint(flag==true,:);
