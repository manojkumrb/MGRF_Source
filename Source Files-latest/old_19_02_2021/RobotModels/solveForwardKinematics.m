% calculate the trasformation matrices for a given joint set
function varargout=solveForwardKinematics(rob)

% rob: robot model

% varargout{1}: set of trasformation matrix
% varargout{2}: true/false =>joint limits satisfied/not satisfied
   
teta=rob.Kinematics.Theta.Joint.Coordinate;

%--
% solve forward kinematics
robmodel=rob.Model{rob.Model{1}+1};

if strcmp(robmodel,'SmartLaser') % smartlaser
    [T, flag]=solveForwardKinematicsSmartLaser(teta, rob); 
elseif strcmp(robmodel,'ABB6620') 
    [T, flag]=solveForwardKinematicsIRB6xxx(teta, rob); 
elseif strcmp(robmodel,'ABB6700-200') 
    [T, flag]=solveForwardKinematicsIRB6xxx(teta, rob); 
elseif strcmp(robmodel,'ABB6700-235') 
    [T, flag]=solveForwardKinematicsIRB6xxx(teta, rob); 
else
    
    
    %-------------
    
    
end

% save out
if nargout==1
    varargout{1}=T;
elseif nargout==2 % check stroke-ends
    varargout{1}=T;
    varargout{2}=flag;
end


% ABB IRB 6xxx series
function varargout=solveForwardKinematicsIRB6xxx(teta, rob)

% teta: list of axis joints
% rob: robot model

% varargout{1}: set of trasformation matrix
% varargout{2}: true/false =>joint limits satifies/not satisfied

% init matrices
T=cell(1,7);

L1=rob.Parameter.L1;
L2=rob.Parameter.L2;
L3=rob.Parameter.L3;
L4=rob.Parameter.L4;
L5=rob.Parameter.L5;
L6=rob.Parameter.L6;
L7=rob.Parameter.L7;

% AXIS[1] - track
T01c=eye(4,4);
T01c(1:3,4)=[L1 0 0];

T01r=eye(4,4);
T01r(1:3,4)=[teta(1) 0 0];

T{1}=T01c*T01r;

% AXIS[2]
T12c=eye(4,4);
T12c(1:3,4)=[0 0 L2];

T12r=eye(4,4);
R=getRotZ(teta(2));
T12r(1:3,1:3)=R;

T{2}=T12c*T12r;

% AXIS[3]
T23c=eye(4,4);
T23c(1:3,1:3)=[1 0  0
               0 0  1
               0 -1 0];
T23c(1:3,4)=[L3(1) 0 L3(2)];

T23r=eye(4,4);
R=getRotZ(teta(3));
T23r(1:3,1:3)=R;

T{3}=T23c*T23r;

% AXIS[4]
T34c=eye(4,4);
T34c(1:3,4)=[0 -L4 0];

T34r=eye(4,4);
R=getRotZ(teta(4));
T34r(1:3,1:3)=R;

T{4}=T34c*T34r;

% AXIS[5]
T45c=eye(4,4);
T45c(1:3,1:3)=[0 0 1
               1 0 0
               0 1 0];
T45c(1:3,4)=[L5(1) -L5(2) 0];

T45r=eye(4,4);
R=getRotZ(teta(5));
T45r(1:3,1:3)=R;

T{5}=T45c*T45r;

% AXIS[6]
T56c=eye(4,4);
T56c(1:3,1:3)=[0 1 0
               0 0 1
               1 0 0];
T56c(1:3,4)=[0 0 L6];

T56r=eye(4,4);
R=getRotZ(teta(6));
T56r(1:3,1:3)=R;

T{6}=T56c*T56r;

% AXIS[7]
T67c=eye(4,4);
T67c(1:3,1:3)=[0 0 1
               1 0 0
               0 1 0];
T67c(1:3,4)=[L7 0 0];

T67r=eye(4,4);
R=getRotZ(teta(7));
T67r(1:3,1:3)=R;

T{7}=T67c*T67r;

% save out
if nargout==1
    varargout{1}=T;
elseif nargout==2 % check stroke-ends
    varargout{1}=T;
    
    flagse=checkStrokeEnd(teta, rob, 1:7);
    varargout{2}=flagse;
end



% SMARTLASER
function varargout=solveForwardKinematicsSmartLaser(teta, rob)

% teta: list of axis joints
% rob: robot model

% varargout{1}: set of trasformation matrix
% varargout{2}: true/false =>joint limits satified/not satisfied

% init matrices
T=cell(1,7);

% inital parameters
P0=rob.P0;
L2=rob.L2;
L3=rob.L3;
L4=rob.L4;
L5=rob.L5;

% AXIS[1]
R01=[cos(teta(1)) -sin(teta(1)) 0
     -sin(teta(1)) -cos(teta(1)) 0
     0            0            -1];
d01=[0 0 0];
T01=eye(4,4);
T01(1:3,1:3)=R01; T01(1:3,4)=d01;
T{1}=T01;

% AXIS[2]
R12=[sin(teta(2)) cos(teta(2)) 0
     0            0            -1
     -cos(teta(2)) sin(teta(2)) 0];
d12=[P0(1) -P0(2) -P0(3)];
T12=eye(4,4);
T12(1:3,1:3)=R12; T12(1:3,4)=d12;
T{2}=T12;

% AXIS[3]
R23=[cos(teta(3)) -sin(teta(3)) 0
     -sin(teta(3)) -cos(teta(3)) 0
     0             0             -1];
d23=[L2 0 0];
T23=eye(4,4);
T23(1:3,1:3)=R23; T23(1:3,4)=d23;
T{3}=T23;

% AXIS[4]
R34=[-cos(teta(4)) -sin(teta(4)) 0
     0            0             -1
     sin(teta(4)) -cos(teta(4)) 0];
d34=[L3 -L4 0];
T34=eye(4,4);
T34(1:3,1:3)=R34; T34(1:3,4)=d34;  
T{4}=T34;

% AXIS[5]
R54=[1 0            0
     0 cos(teta(5)) sin(teta(5))
     0 -sin(teta(5)) cos(teta(5))];
d54=[L5 0 0];
T54=eye(4,4);
T54(1:3,1:3)=R54; T54(1:3,4)=d54;  
T{5}=T54;

% AXIS[6]
R65=[cos(teta(6))  0   -sin(teta(6))
     0             1   0
     sin(teta(6)) 0   cos(teta(6))];
d65=[0 0 0];
T65=eye(4,4);
T65(1:3,1:3)=R65; T65(1:3,4)=d65;  
T{6}=T65;

% AXIS[7]
d76=[0 0 teta(7)];
T76=eye(4,4);
T76(1:3,4)=d76;  
T{7}=T76;

% save out
if nargout==1
    varargout{1}=T;
elseif nargout==2 % check stroke-ends
    varargout{1}=T;
    
    flagse=checkStrokeEnd(teta, rob, 1:7);
    varargout{2}=flagse;
end





%---------
function R=getRotZ(teta)

R=[cos(teta) -sin(teta) 0
   sin(teta) cos(teta)  0
   0         0          1];


      
      
      
