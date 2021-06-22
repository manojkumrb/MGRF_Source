function rob=initRobot(rob)

% INPUT
% modrobot: "ABB6620"; "SmartLaser"; ...

% OUTPUT
% rob.
    % Model: robot model
    % Parameter: geometrical parameters and tool definition
        % Li, i=1,...,NL
        % Tool
    % Geom: 3D geoemtry
        % Color
        % Face
        % Vertices
    % JointLim: joint limits
    % SpeedLim: speed limits
    % Options: rendering options
        % ParentAxes: parent axes
        % ShowLink: show CAD's linkages
        % ShowFrame: show frame
        % LengthAxisFrame: length axis length
    % Kinematics

robmodel=rob.Model{rob.Model{1}+1};
    
if strcmp(robmodel,'ABB6620') 
    rob=initABB6620(rob);
elseif strcmp(robmodel,'ABB6700-200') 
    rob=initABB6700200(rob);
elseif strcmp(robmodel,'ABB6700-235') 
    rob=initABB6700235(rob);
        
else
    
    
    
    %--------------
    
    
    
end

% init tools
rob=initRobotTool(rob);

% update graphics options
rob.Graphic.EdgeColor='k';
rob.Graphic.FaceAlpha=1.0;

rob.Graphic.Show=true;   
rob.Graphic.ShowEdge=false;

rob.Graphic.WorkVolume.Show=false;   

   
%-----------
function rob=initABB6700235(rob)

%--------------------
% NOTICE: the robot uses only 6 axis as follows: q=[0, q1, q2, q3, q4, q5, q6]
%--------------------

rob.Options.ParentAxes=[];
rob.Options.ShowLink=true(1,9); % 1:7=robot; 8: cylinder; tool
rob.Options.ShowFrame=false(1,10); % [world, joint(1),..., joint(7), cylinder, tool]
rob.Options.LengthAxisFrame=100*ones(1,10);

% define the robot parameters
L1=0; % mm
L2=288; % mm
L3=[320 492]; % mm
L4=1135; % mm
L5=[233.69 200]; % mm
L6=948.81; % mm
L7=200; % mm 

rob.Parameter.L1=L1;
rob.Parameter.L2=L2;
rob.Parameter.L3=L3;
rob.Parameter.Cylinder.P1=[-208.74 44.37 0]; % defined into local omega 3 frame
rob.Parameter.Cylinder.P2=[-669 142 0]; % defined into local omega 3 frame
rob.Parameter.L4=L4;
rob.Parameter.L5=L5;
rob.Parameter.L6=L6;
rob.Parameter.L7=L7;

% set joint limits [track, joint(1),..., joint(6)]
rob.JointLim=[0 170 85 70 300 130 360
              0 -170 -65 -180 -300 -130 -360]; 
rob.JointLim(:,2:end)=rob.JointLim(:,2:end)*pi/180; % radians

% set speed limit
rob.SpeedLim=[0 100 90 90 170 120 190]; 
rob.SpeedLim(2:end)=rob.SpeedLim(2:end)*pi/180;% rad/s

% init Kinematics
robmodel=rob.Model{rob.Model{1}+1};
rob.Kinematics=initKinematics(robmodel, 7, [0 0 0 0 0 0 0]); % set home position
Tfk=solveForwardKinematics(rob);

%-----------------------------------------------------------------------------
% NOTICE: the link's geometry needs to be passed into the home position
%-----------------------------------------------------------------------------

% import models
 col=[1 0 0
     0 1 0
     0 0 1
     1 0 0
     0 1 0
     0 0 1
     1 0 1
     0 0 1
     1 0.5 1];
rob.Graphic.Color=col;

 % geometry
rob.Geom=[];
for i=1:8 % 1:7=robot; 8: cylinder
        
    filestl=sprintf('link_%girb6700_235_new.stl',i); %  link/cylinder

    [f, v]=lncreadmesh(filestl);
    
    rob.Geom.Face{i}=f;

    % transform into local frame
    if i==8
        Ti=setTransformationCylABB6700(rob, Tfk);
    else
        Ti=setTransformation(Tfk, i); 
    end

    v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');  

    rob.Geom.Vertices{i}=v; 
    
end



%-----------
function rob=initABB6700200(rob)

%--------------------
% NOTICE: the robot uses only 6 axis as follows: q=[0, q1, q2, q3, q4, q5, q6]
%--------------------

rob.Options.ParentAxes=[];
rob.Options.ShowLink=true(1,9); % 1:7=robot; 8: cylinder, 9: tool
rob.Options.ShowFrame=false(1,10); % [world, joint(1),..., joint(7), cylinder, tool]
rob.Options.LengthAxisFrame=100*ones(1,10);

% define the robot parameters
L1=0; % mm
L2=288; % mm
L3=[320 492]; % mm
L4=1125; % mm
L5=[233.45 200]; % mm
L6=910.05; % mm
L7=200; % mm 

rob.Parameter.L1=L1;
rob.Parameter.L2=L2;
rob.Parameter.L3=L3;
rob.Parameter.Cylinder.P1=[-208.74 44.37 0]; % defined into local omega 3 frame
rob.Parameter.Cylinder.P2=[-668.5 142.5 0]; % defined into local omega 3 frame
rob.Parameter.L4=L4;
rob.Parameter.L5=L5;
rob.Parameter.L6=L6;
rob.Parameter.L7=L7;

% set joint limits [track, joint(1),..., joint(6)]
rob.JointLim=[0 170 85 70 300 130 360
              0 -170 -65 -180 -300 -130 -360]; 
rob.JointLim(:,2:end)=rob.JointLim(:,2:end)*pi/180; % radians

% set speed limit
rob.SpeedLim=[0 110 110 110 190 150 210]; 
rob.SpeedLim(2:end)=rob.SpeedLim(2:end)*pi/180;% rad/s

% init Kinematics
robmodel=rob.Model{rob.Model{1}+1};
rob.Kinematics=initKinematics(robmodel, 7, [0 0 0 0 0 0 0]); % set home position
Tfk=solveForwardKinematics(rob);

%-----------------------------------------------------------------------------
% NOTICE: the link's geometry needs to be passed into the home position
%-----------------------------------------------------------------------------

% import models
col=[1 0 0
     0 1 0
     0 0 1
     1 0 0
     0 1 0
     0 0 1
     1 0 1
     0 0 1
     1 0.5 1];
rob.Graphic.Color=col;

 % geometry
rob.Geom=[];
for i=1:8 % 1:7=robot; 8: cylinder
        
    filestl=sprintf('link_%girb6700_200_new.stl',i); %  link/cylinder

    [f, v]=lncreadmesh(filestl);
    
    rob.Geom.Face{i}=f;

    % transform into local frame
    if i==8
        Ti=setTransformationCylABB6700(rob, Tfk);
    else
        Ti=setTransformation(Tfk, i); 
    end

    v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');  

    rob.Geom.Vertices{i}=v; 
    
end


%-----------
function rob=initABB6620(rob)

rob.Options.ParentAxes=[];
rob.Options.ShowLink=true(1,9); % 1:8=track+robot, 9: tool
rob.Options.ShowFrame=false(1,9); % [world, joint(1),..., joint(7), tool]
rob.Options.ShowCameraFoV=true(1,4); % show camera1/2/3/overall FoV
rob.Options.LengthAxisFrame=100*ones(1,9);

% define the robot parameters
L1=0; % mm
L2=230; % mm
L3=[320 450]; % mm
L4=975; % mm
L5=[182 200]; % mm
L6=705; % mm
L7=200; % mm 

rob.Parameter.L1=L1;
rob.Parameter.L2=L2;
rob.Parameter.L3=L3;
rob.Parameter.L4=L4;
rob.Parameter.L5=L5;
rob.Parameter.L6=L6;
rob.Parameter.L7=L7;

% set joint limits [track, joint(1),..., joint(6)]
rob.JointLim=[3000 170 140 70 300 130 300
              0 -170 -65 -180 -300 -130 -300]; 
rob.JointLim(:,2:end)=rob.JointLim(:,2:end)*pi/180; % radians

% set speed limit
rob.SpeedLim=[0 100 90 90 150 120 190]; 
rob.SpeedLim(2:end)=rob.SpeedLim(2:end)*pi/180;% rad/s

% init Kinematics
robmodel=rob.Model{rob.Model{1}+1};
rob.Kinematics=initKinematics(robmodel, 7, [0 0 0 0 0 0 0]); % set home position
Tfk=solveForwardKinematics(rob);

%-----------------------------------------------------------------------------
% NOTICE: the link's geometry needs to be passed into the home position
%-----------------------------------------------------------------------------

% import models
col=[0.5 0.5 0.5
     1 0 0
     0 1 0
     0 0 1
     1 0 0
     0 1 0
     0 0 1
     1 0 1
     1 0.5 1];
rob.Graphic.Color=col;

 % geometry
rob.Geom=[];
for i=1:8 % 1=track; 2:8=robot;
    
    filestl=sprintf('link_%girb6620_new.stl',i); % link
    
   [f, v]=lncreadmesh(filestl);
            
    rob.Geom.Face{i}=f;
    
    % transform into local frame
    if i>1 % track already into local frame
      Ti=setTransformation(Tfk, i-1); 
      v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');  
    end
    
    rob.Geom.Vertices{i}=v; 
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



