% init robot's tools
function rob=initRobotTool(rob)

% INPUT
% modtool: "WeldMaster"; "WLS400A"; ...
% rob: robot model

toolmodel=rob.Tool.Model{rob.Tool.Model{1}+1};

%... update
if strcmp(toolmodel, 'WeldMaster')
    rob=initWM(rob);
elseif strcmp(toolmodel, 'WLS400A') 
    rob=initWLS400A(rob);  
else
    
    
    
    % add here any otehr model
    
    
    
end


%--
function rob=initWM(rob)

%--
robmodel=rob.Model{rob.Model{1}+1};

rob.Kinematics=initKinematics(robmodel, 7, [0 0 0 0 0 0 0]); % set home position
Tfk=solveForwardKinematics(rob);

% define tool with respect to tool 0
rob.Tool.P=[482.22 0 167]; % mm
rob.Tool.R=[0 0 1
            -1 0 0
            0 -1 0]; % tool orientation 

filestl='tool_WeldMaster.stl'; % tool
 
[f, v]=lncreadmesh(filestl);

Ti=getTCPLocation(rob, Tfk);
v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');  

% save out
rob.Tool.Geom.Face=f;
rob.Tool.Geom.Vertices=v; 
    
% technological parameters
rob.Tool.Parameter.Compensation.Value=[8 3]; % mm - lateral Y(+-4), vertical Z(+-1.5)
rob.Tool.Parameter.Compensation.Offset=5; % offset from the TCP

rob.Tool.Parameter.IncidenceAngle=[5 40]; % deg - min max 
rob.Tool.Parameter.SearchDist=[3 5 10 20]; % laser to object (min max), scanner to object (min max)

%--
function rob=initWLS400A(rob)

%--
robmodel=rob.Model{rob.Model{1}+1};

rob.Kinematics=initKinematics(robmodel, 7, [0 0 0 0 0 0 0]); % set home position
Tfk=solveForwardKinematics(rob);

% define tool with respect to tool 0
rob.Tool.P=[777.339,206.37,162.829]; % mm
rob.Tool.R=quat2Rot([0.536924,-0.592928,0.385324,-0.460081]); % tool orientation (WLS400A)
rob.Tool.Load.Mass=17.7; % mass (kg)
rob.Tool.Load.P=[-45.9,-6.5,227.9]; % center of mass (mm)
rob.Tool.Load.R=quat2Rot([1 0 0 0]); % inertial axes
rob.Tool.Load.I=[0 0 0.766]; % inertia values (kg*m^2)

rob.Tool.Camera.P=[108.20  31.96 267.37
                             69.79 183.75 149.60
                             158.42 -116.34 149.60]; % camera position wrt to tool 0 (frame 7)
rob.Tool.Camera.R=buildCameraFrame(rob.Tool.P, rob.Tool.Camera.P); % camera orientations wrt to tool 0

Np=point2Plane(rob.Tool.Camera.P(1,:), rob.Tool.Camera.P(2,:), rob.Tool.Camera.P(3,:));
rob.Tool.Camera.Centre=planeLineIntersection(rob.Tool.Camera.P(1,:), Np, rob.Tool.P, rob.Tool.R(:,3)'); % intersection between Z axis of R7t and plane passing through "Camera.P"

% define camera intrinsic parameters
rob.Tool.Camera.Intrinsic.Parameter.W=512; % pixels
rob.Tool.Camera.Intrinsic.Parameter.H=512; % pixels
rob.Tool.Camera.Intrinsic.Parameter.PixelSize=0.008; % mm/pixel 
rob.Tool.Camera.Intrinsic.Parameter.Focal=[1100 1100]; 
rob.Tool.Camera.Intrinsic.Parameter.WorkingDistance=[780-180/2 780+180/2]; % mm (for medium lens - MFOV)

fx=rob.Tool.Camera.Intrinsic.Parameter.Focal(1); % focal x
fy=rob.Tool.Camera.Intrinsic.Parameter.Focal(2); % focal y
x0=rob.Tool.Camera.Intrinsic.Parameter.W/2; % principal point x
y0=rob.Tool.Camera.Intrinsic.Parameter.H/2; % principal point y
s=0; % skew
rob.Tool.Camera.Intrinsic.K(:,:,1)=[fx s x0
                               0 fy y0
                               0 0 1];
rob.Tool.Camera.Intrinsic.K(:,:,2)=[fx s x0
                               0 fy y0
                               0 0 1];
rob.Tool.Camera.Intrinsic.K(:,:,3)=[fx s x0
                               0 fy y0
                               0 0 1];
                                           
rob.Tool.FOV=[360 360]; % field of view "MFOF"

%--
filestl='tool_WLS400A.stl'; % tool
  
[f, v]=lncreadmesh(filestl);

Ti=getTCPLocation(rob, Tfk);
v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');  

% save out
rob.Tool.Geom.Face=f;
rob.Tool.Geom.Vertices=v; 


%-- 
function R=buildCameraFrame(Ptool, Pcam)

R=zeros(3,3,3);

for i=1:3
    % get optical axis
    Nopt=(Ptool-Pcam(i,:))/norm(Ptool-Pcam(i,:));

    R(:,:,i)=vector2Rotation(Nopt);
end


%--
function [f, v]=lncreadmesh(filestl)

stltype = getStlFormat(filestl);
    
if strcmp(stltype,'ascii')
    [f,v]=readMeshStlAscii(filestl); 
elseif strcmp(stltype,'binary')
    [f, v]=readMeshStlBin(filestl); 
else
    error('Init robot: geometry file (%s) not supported!', filestl)
end
    
