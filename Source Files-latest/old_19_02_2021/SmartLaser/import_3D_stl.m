clc
clear

close all

wdir='Z:\Factory-of-the-future\Catapult\RLW Navigator\WP 3\VRM\Source Files-latest';
path(path,wdir);
femInit(wdir);

path(path,[pwd,'\Functions']);

%%
L=400; % graphical parameters for axis plot
%---------------

% define the robot parameters
P0=[400 0 900]; % mm
L2=960; % mm
L3=290; % mm
L4=1508.5; % mm
L5=275; % mm

rob.P0=P0;
rob.L2=L2;
rob.L3=L3;
rob.L4=L4;
rob.L5=L5;
rob.R=[0 0 1
       -1 0 0
       0 -1 0]; % intial end effector orientation
%% set joint limits
rob.jointLim=[45 60 -45+90 280
              -60 -40 -170+90 -280]*pi/180; % robot (% "90" correction as required by the COMAU manual)
rob.jointLim(:,5)=[140; -140]*pi/180; % scanner
rob.jointLim(:,6)=[10; -7.5]*pi/180; % moving mirror
rob.jointLim(:,7)=[1143; 1000]; % focal distance

rob.Geom=[];

% set calibration position
alfa=[0 -25 -115 0 0 0]*pi/180; % 
teta=[alfa(1) alfa(2) pi/2+alfa(3) alfa(4) alfa(5) alfa(6) 1000]; % rad
Tfk=joint2Pos(teta, rob);

% import models
col=[1 0 0
     0 1 0
     0 0 1
     0.5 0.5 0
     0.5 0 0.5
     0.5 0.5 0.5];
 
for i=1:6
    filestl=sprintf('link_%g.stl',i);
    
    stltype = getStlFormat(filestl);
    
    if strcmp(stltype,'ascii')
        
        [f,v]=readMeshStlAscii(filestl); % matlab function
        
    elseif strcmp(stltype,'binary')
        
        [f, v]=readMeshStlBin(filestl); % matlab function
        
    end
        
    rob.Geom.Face{i}=f;
    rob.Geom.Vertices{i}=v;
    rob.Geom.Color(i,:)=col(i,:);
end

for i=2:6
    v=rob.Geom.Vertices{i};
    
    % transform into local frame
    Ti=setTransformation(Tfk, i-1);
    v=applyinv4x4(v, Ti(1:3,1:3), Ti(1:3,4)');
    
    rob.Geom.Vertices{i}=v;
end

save('rob.mat','rob')

%% plot
hold all

% define independent angles
alfa=[0 -25 -115 0 0 -10]*pi/180; % 
teta=[alfa(1) alfa(2) pi/2+alfa(3) alfa(4) alfa(5) alfa(6) 1000]; % rad
Tfk=joint2Pos(teta, rob);


% base
p0=[0 0 0];
R0=eye(3,3);
plotFrame(R0, p0, L*5)
      
for i=1:7
    Ti=setTransformation(Tfk, i);
    
    % plot frames
    ti=Ti(1:3,4)';    
    Ri=Ti(1:3,1:3);

%     plotFrame(Ri, ti, L)       
end

% plot geometry
plotRobot3d(rob, Tfk)

axis equal
view(3)
grid on

        