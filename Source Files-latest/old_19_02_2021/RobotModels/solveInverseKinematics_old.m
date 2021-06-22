% solve inverse kinematics
function varargout=solveInverseKinematics(rob)

% rob: robot model

% varargout{1}: joint coordinates [nsol, no. joints]
% varargout{2}: solution error [position, rotation](nsol,2)
% varargout{3}: true/false => feasible/not feasible solution

% run calculation
if strcmp(rob.Model,'ABB6620') 
    
    q=zeros(8,7); % 8 possible solutions; 7 joints
    
    %------------------------------------------------
    % NOTICE: the kinematics problem can be decoupled
    %------------------------------------------------
    
    % STEP 1: solve inverse position problem
    qpos=solveInvPosKinematic(rob);
    
    % STEP 2: solve inverse rotation problem
    c=1;
    for i=1:4
        qr=solveInvRotKinematic(rob, [0 qpos(i,:), 0 0 0]);
        
        q(c, 2:4)=qpos(i,:); q(c, 5:7)=qr(1,:);
        c=c+1;
        q(c, 2:4)=qpos(i,:); q(c, 5:7)=qr(2,:);
        c=c+1;
    end
    
    % STEP 3: store only feasile solutions (out of 8 possible solutions)
    [q, err, flag]=checkFeasibleSolution(q, rob);
    if ~flag
        fprintf('Error (Inverse Kinematics): position not reachable!\n');
    end
    

else
    
    
    %--------------
    
    
end

%---------------------------
% save out
if nargout==1
    varargout{1}=q;
elseif nargout==2
    varargout{1}=q;
    varargout{2}=err;
elseif nargout==3
    varargout{1}=q;
    varargout{2}=err;
    varargout{3}=flag;
end



%------------------------------------------------------
%------------------------------------------------------

% solve inverse position kinematic: solve for "q2", "q3", "q4"
function q=solveInvPosKinematic(rob)

% q: set of fesible solutions [4, 3]
% flag: true/false => singular position (axis stroke-end) / solution found

%-------------------
% get wrist position
Pw=getWristPos(rob);

% solve for q2
q2=solveq2(rob, Pw);

% solve for q3
q3(1:2)=solveq3(rob, Pw, [0 q2(1) zeros(1,5)]);
q3(3:4)=solveq3(rob, Pw, [0 q2(2) zeros(1,5)]);

% solve for q4
q4(1:2)=solveq4(rob, Pw, [0 q2(1) zeros(1,5)]);
q4(3:4)=solveq4(rob, Pw, [0 q2(2) zeros(1,5)]);

% save out
q = [q2(1) q2(1) q2(2) q2(2)
     q3(1) q3(2) q3(3) q3(4) 
     q4(1) q4(2) q4(3) q4(4)]';
 

% solve inverse rotation kinematic: solve for "q5", "q6", "q7"
function q=solveInvRotKinematic(rob, qpos)

% qpos=[0 q2 q3 q4 0 0 0];

% q: set of fesible solutions [2, 3]

% num. tolerance
eps=rob.Kinematics.Solver.Eps; 

%-------------------
% get wrist orientation
R=getWristRot(rob, qpos);

if abs(1-R(1,3)^2)>=eps % normal solution
    q6(1)=atan2(sqrt(1-R(1,3)^2), R(1,3));
    q6(2)=atan2(-sqrt(1-R(1,3)^2), R(1,3));

    q5(1)=atan2( R(3,3)/sin(q6(1)), R(2,3)/sin(q6(1)) );
    q5(2)=atan2( R(3,3)/sin(q6(2)), R(2,3)/sin(q6(2)) );
        
    q7(1)=atan2( R(1,2)/sin(q6(1)), -R(1,1)/sin(q6(1)) );
    q7(2)=atan2( R(1,2)/sin(q6(2)), -R(1,1)/sin(q6(2)) );
else % singular solution
    fprintf('Warning (Inverse Kinematics): singularity - joint[5-6] set to default coordinate (0 deg)!\n');

    q6(1)=0;
    q6(2)=0;
    
    q5(1)=0;
    q5(2)=-pi;
    
    q7(1)=atan2( R(3,1) - R(2,2), R(3,2) + R(2,1));
    q7(2)=q7(1) + pi;
end

% save out
q=[q5(1) q5(2)
   q6(1) q6(2)
   q7(1) q7(2)]';


% solve q2
function q2=solveq2(rob, Pw)

% num. tolerance
eps=rob.Kinematics.Solver.Eps; 

if norm([Pw(1), Pw(2)]) <= eps
   fprintf('Warning (Inverse Kinematics): singularity - joint[2] set to default coordinate (0 deg)!\n');
   q2(1)=0.0; 
else
   q2(1)=atan2(Pw(2), Pw(1)); 
end

q2(2)=q2(1)+pi;
q2 = normalizeq(q2);


% solve q3
function q3=solveq3(rob, Pw, q)

% get constants
L4=rob.Parameter.L4;
L51=rob.Parameter.L5(1); L52=rob.Parameter.L5(2);
L6=rob.Parameter.L6;

A=sqrt( L52^2 + (L51+L6)^2 );

% trasform Pw into frame attached to q3 for convenience
Pw=moveToFrame(Pw, rob, q, 3);
    
B=sqrt(Pw(1)^2+Pw(2)^2);

% solve for q3
D=(L4^2 + B^2 -A^2 )/(2*L4*B);
beta=real(acos(D));
gamma=atan2(-Pw(2), Pw(1)); % => this corresponds to "gamma-pi/2"

q3(1)=pi/2-gamma-beta; % elbow down
q3(2)=pi/2-gamma+beta; % elbow up


% solve q4      
function q4=solveq4(rob, Pw, q)   

% get constants
L4=rob.Parameter.L4;
L51=rob.Parameter.L5(1); L52=rob.Parameter.L5(2);
L6=rob.Parameter.L6;

A=sqrt( L52^2 + (L51+L6)^2 );

% trasform Pw into frame attached to q3 for convenience
Pw=moveToFrame(Pw, rob, q, 3);
   
B=sqrt(Pw(1)^2+Pw(2)^2);

% solve for q4
D=(L4^2 + A^2 -B^2 )/(2*L4*A);
alfa=real(acos(D));
phi=atan((L51+L6)/L52);

q4(1)=pi-phi-alfa; % elbow down
q4(2)=pi-phi+alfa; % elbow up


%--
% read wrist orientation wrt frame "4" 
function R47=getWristRot(rob, q)

% q: joint coordinates

% R47=R45(q5)*R56(q6)*R67(q7)

% goal orientation
R0t=rob.Kinematics.Goal.R;

% read tool (tool to flange)
R7t=rob.Parameter.Tool.R;

% calculate trasformation R04
rob.Kinematics.Theta.JointFree.Coordinate=q; Ti=solveForwardKinematics(rob);
T04=setTransformation(Ti, 4); R04=T04(1:3,1:3);

R47=R04' * R0t * R7t';


% check feasible solutions
function [teta, err, flag]=checkFeasibleSolution(q, rob)

% q: joint coordinates (nsol, njoint)
% rob: robot model

% teta: feasible joint coordinates (nsoll, njoint)
% err: solution error [position, rotation](nsoll,2)
% flag: true/false

% output values
teta=[]; 
err=[];
flag=true;

eps=rob.Kinematics.Solver.EpsIK; % num. tolerance

% check now the feasible solutions
c=1;
for i=1:size(q,1)
    
    % build joint coordinates
    tetac=q(i,:);
    
    % check stroke-end
    csei=checkStrokeEnd(tetac, rob, 1:7);
    if csei % now check the location of tool (TCP)
        rob.Kinematics.Theta.JointFree.Coordinate=tetac; Ti=solveForwardKinematics(rob);
        
        % get TCP
        Ttcp=getTCPLocation(rob, Ti);
        Ptcp=Ttcp(1:3,4);
        Rtcp=Ttcp(1:3,1:3);
        
        % get goal
        Pt=rob.Kinematics.Goal.P;
        Rt=rob.Kinematics.Goal.R;
        
        % and, check position and orientation
        ep=norm( Ptcp(:) - Pt(:) ); % position error
        er=norm( Rtcp(:) - Rt(:) ); % orientation error

        if ep<=eps && er<=eps % check
            teta(c,:) = q(i,:); %#ok<AGROW>
            err(c,:)=[ep, er];  %#ok<AGROW>
            c=c+1;
              
                    % fprintf('Message (Inverse Kinematics): solution found - position error: %f, rotation error: %f\n', ep, er);
              
        end
    end
end

%--
if isempty(teta)
    flag=false;
else
    
end


% transform Pw to frame "idaxis" for given joint coordinate "teta"
function Pw=moveToFrame(Pw, rob, teta, idaxis)

rob.Kinematics.Theta.JointFree.Coordinate=teta;
T=solveForwardKinematics(rob);
T0idaxis=setTransformation(T, idaxis);

Pw=applyinv4x4(Pw, T0idaxis(1:3,1:3), T0idaxis(1:3,4)');


% normalise q into [-pi, pi]
function q = normalizeq(q)

for i=1:length(q)
   q(i)=atan2(sin(q(i)),cos(q(i))); 
end





