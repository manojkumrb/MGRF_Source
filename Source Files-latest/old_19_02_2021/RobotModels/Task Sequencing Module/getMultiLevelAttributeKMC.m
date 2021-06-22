% define multi-weigheted attributes for given KMC
function out=getMultiLevelAttributeKMC(X, KMC, idkmc, WeightData, StationData, opt)

% WeightData.
    % Distance
    % Collision
    % Coverage
    % Kinematics
    %...

% StationData.
    % Robot
    % Workpiece

% opt: "point", "distance", "collision", "coverage", "kinematics"

if strcmpi(opt, 'point')
    out=lcnGetPointKMC(X, KMC, idkmc);
elseif strcmpi(opt, 'distance')
    distData=getMinGeometricDistanceKMC(KMC, WeightData.Distance.Resolution); 
    out=lcnGetDistanceKMC(X, distData, KMC, idkmc);
elseif strcmpi(opt, 'collision')
    out=lcnGetCollisionKMC(X, KMC, idkmc, WeightData.Collision, StationData.Workpiece);
elseif strcmpi(opt, 'coverage')
    out=lcnGetCoverageKMC(X, KMC, idkmc, WeightData.Coverage, StationData.Robot, StationData.Workpiece);
elseif strcmpi(opt, 'kinematics')
    out=lcnGetKinematicsKMC(X, KMC, idkmc, StationData.Robot);
else
 
    %---
    % add here any other attribute

end


% generate point inside the KMC for given parameters
function Ps=lcnGetPointKMC(X, KMC, id)

% Input:
%   X=
    % (1) t: axis parameters
    % (2) teta: angle into (Z-X plane) (radians) - wrt normal (Z)
    % (3) phi: angle into (X-Y) plane  (radians)
   
% Output:
%   P=[1x3]

t=X(1);
teta=X(2);
phi=X(3);

% get point
Ps(1)=t*sin(teta)*cos(phi);
Ps(2)=t*sin(teta)*sin(phi);
Ps(3)=t*cos(teta);

% trasnform into global frame
Ps=apply4x4(Ps, KMC(id).R, KMC(id).Vectors.Point);

% It computes the weight belonging to the P point according to the distance among P point and Pi points
function  W=lcnGetDistanceKMC(X, distData, KMC, id)


% Input:
%   X=
    % (1) t: axis parameters
    % (2) teta: angle into (Z-X plane) (radians)
    % (3) phi: angle into (Z-Y) plane  (radians)
% distData(i,j).
    % P=[Pi; Pj]
    % D=distance norm(pi-Pj)
% KMC: KMC structure
% id: KMC id

% Output:
%   W = weight (scalar)

% get parametrised point inside the KMC
P=lcnGetPointKMC(X, KMC, id);

W=0;

nP=size(distData,1);
for j=1:nP
    
    if id~=j
        Pi=distData(id,j).P(2,:); % the first point is P(id)
        W=(W+norm(P-Pi));
    end
    
end

%-- collision checker
function c=lcnGetCollisionKMC(X, KMC, id, collisionData, workpiece)

%-------
% c<0=no collision; c>=0; collision
%-------

% collisionData.
    % SphereRadius
    % Resolution
    
% get point
P=lcnGetPointKMC(X, KMC, id);

% run collision checking
workpiececoordinate=workpiece.xMesh.Node.Coordinate;

p(:,1)=workpiececoordinate(:,1)-P(1);
p(:,2)=workpiececoordinate(:,2)-P(2);
p(:,3)=workpiececoordinate(:,3)-P(3);

minDistance=collisionData.MinDistance;

% get distances and normalise
radius=collisionData.SphereRadius + minDistance;
dist=sqrt(sum(p.^2,2)) - radius;

c=-min(dist);

% if min(dist)>0
%     c=-1;
% else
%     c=0;
% end

% minDistance=collisionData.MinDistance;
% 
% [X,Y,Z]=createSphereObj(collisionData.SphereRadius+minDistance, P, 50);
% FV=surf2patch(X, Y, Z);
% 
% [~, ~, npairs]=collisionChecker(FV.vertices, FV.faces, workpiece.xMesh.Node.Coordinate, workpiece.Sol.Tria.Element);
%  
% if npairs==0
%     c=-1;
% else
%     c=0;
% end
                            
%-- coverage checker
function c=lcnGetCoverageKMC(X, KMC, id, coverageData, rob, workpiece)

%-------
% coverageIndex>=minCoverage        => -(coverageIndex-minCoverage)<=0
% coverageIndex=[0, 1] => the bigger the better (continous variable)
%-------

% read inputs
RayTracying=coverageData.RayTracying;
minCoverage=coverageData.MinCoverage;

% get point
RayTracying.Point=lcnGetPointKMC(X, KMC, id);

ni=KMC(id).Vectors.Point-RayTracying.Point; ni=ni/norm(ni); 
RayTracying.Normal=ni;

% solve ray tracying problem
if RayTracying.SubModel % extract the sub-model from the workpiece
    workpiece=camera2SubWorkpiece(rob, workpiece, RayTracying.Point, RayTracying.Normal);
end
RayTracying=solveRayTracyingProblem(RayTracying, rob, workpiece);

RayTracying.Sol.Point=RayTracying.Sol.Point(RayTracying.Sol.Flag==true,:);
RayTracying.Sol.Normal=RayTracying.Sol.Normal(RayTracying.Sol.Flag==true,:);

% collect outputs
if coverageData.ScatterModel.Enable % visibility + scatter check
    maxangle=coverageData.ScatterModel.MaxScatterAngle;
    coeff=coverageData.ScatterModel.Coefficient;

    nv=size(RayTracying.Sol.Point,1);
    if nv>0
        CI=point2CoverageIndex(RayTracying.Point, RayTracying.Sol.Point, RayTracying.Sol.Normal,...
                           coeff, maxangle); % MEX function
                       
        cscatter=mean(CI);
    else
        cscatter=0.0;
    end
                           
    cvis=nv/RayTracying.ResolutionImage^2;
    
    c=-(HamacherTNorm(cvis, cscatter) - minCoverage);
           
    %------------------
    % NOTICE: I may use different aggregation operator for that
    %------------------
    
else % only visibility check
    nv=size(RayTracying.Sol.Point,1);
    coverageIndex=nv/RayTracying.ResolutionImage^2;
    c=-(coverageIndex - minCoverage);
end

%----------
function c=lcnGetKinematicsKMC(X, KMC, id, rob)

% read inputs
% Npsi=kinematicsData.Resolution;

Npsi=4;

% define tool (attached to the camera centre)
rob.Parameter.Tool.P = rob.Parameter.Tool.Camera.Centre;

% get point
P=lcnGetPointKMC(X, KMC, id);

% run over "N" instances of psi (rotation around the focal axis of the camera)
psi=linspace(0, 2*pi, Npsi);
cflag=0;
for i=1:Npsi
    % build rotation matrix for given "psi" angle
    R = lcnGetRKMC(P, KMC(id).Vectors.Point, psi(i));

    % define goals
    rob.Kinematics.Goal.P=P;
    rob.Kinematics.Goal.R=R;

    % solve kinematics
    [~, ~, flag]=solveInverseKinematics(rob);    
    
    if flag
        cflag=cflag+1;
    end
end

%--
c=-(cflag/Npsi);

%--
function Rtask = lcnGetRKMC(Ptask, PointKMC, psi)

vtkmc =  PointKMC - Ptask;
vtkmc = vtkmc/norm(vtkmc);

R0vtkmc=vector2Rotation(vtkmc);
Rpsi=RodriguesRot([0 0 1],psi);

Rtask=R0vtkmc*Rpsi;
