% calculate joint angles for given position
function varargout=pos2JointNumeric(goal, rob, settingteta, theta0)

% goal: 
    % .P: point to be reached
    % .Eps: min distance to be achieved
    % .N: normal vector
    % .Angle.Beam.Upper/Lower: allowed angle between beam and goal.N
    % .Objective: "scanner", "tcp"
    % .Solver.Eps: solver accuracy
    % .Solver.MaxIter: solver iterations

% rob:
%   .P0: location of axis[2]
%   .L2: length of link[2]
%   .L3: length of link[3]
%   .L4: length of link[4]
%   .L5: offset between fixed mirror and moving mirror
%   .jointLim: joint  (first line: positive limit; second line: negative limit)

% settingteta.
%     IdFix= constant teta IDs
%     IdVar= variable teta IDs
%     TetaFix= constant teta values

% theta0: initial guess

if ~isfield(goal, 'Eps')
    goal.Eps=1e-2;
    warning('Inverse Kinematics: using zero offset');
end

if ~isfield(goal, 'Objective')
    goal.Objective='tcp';
    warning('Inverse Kinematics: using "TCP" mode for optimisation');
end

if ~isfield(goal, 'Angle')
    goal.Angle.Beam.Upper=20.0;
    goal.Angle.Beam.Lower=0.0;
    warning('Inverse Kinematics: using default tolerances');
end

if ~isfield(goal, 'Solver')
    goal.Solver.Eps=1e-4;
    goal.Solver.MaxIter=1000;
    warning('Inverse Kinematics: using default settings for solver');
end

% define joint limits
lb=rob.jointLim(2,settingteta.IdVar); % lower
ub=rob.jointLim(1,settingteta.IdVar); % upper

% set calibration position as initial guess
if nargin<4
    alfa=[0 -25 -115 0 0 0]*pi/180; % COMAU calibration position
    
    theta0=[alfa(1) alfa(2) pi/2+alfa(3) alfa(4) alfa(5) alfa(6) 1100];     
end
theta0=theta0(settingteta.IdVar);

%-------------------------------------
option = optimset('TolX',goal.Solver.Eps,'TolFun',goal.Solver.Eps,...
                 'MaxFunEvals',goal.Solver.MaxIter,'TolCon',goal.Solver.Eps,'MaxIter',goal.Solver.MaxIter);
  
thetasol=fmincon(@(teta)localObj(teta, rob, goal, settingteta),theta0,[],[],[],[], lb, ub, @(teta)localCon(teta, rob, goal, settingteta),option);

% first output
theta(settingteta.IdFix)=settingteta.TetaFix;
theta(settingteta.IdVar)=thetasol;
varargout{1}=theta;

% check solution
f=localObj(thetasol, rob, goal, settingteta);

% check constraints
[c, ~]=localCon(thetasol, rob, goal, settingteta);

if nargout==2
    log.Distance=f; % TCP to goal.P
    
    if ~isempty(goal.N)
        log.Angle.Beam(1)=c(1)+goal.Angle.Beam.Upper; % angle between beam and goal.N
        log.Angle.Beam(2)=-c(2)+goal.Angle.Beam.Lower; % angle between beam and goal.N
    else
        log.Angle.Beam(1)=0.0;
        log.Angle.Beam(2)=0.0;
    end
            
    varargout{2}=log;
end   
    
% objective function
function f=localObj(teta, rob, goal, settingteta)

% get set of transformation
T=joint2Pos(teta, rob, settingteta);

% get robot point
if strcmp(goal.Objective,'tcp')
    idjoint=7;
elseif strcmp(goal.Objective,'scanner')
    idjoint=4;
end

Tjoint=setTransformation(T, idjoint);

Pact=Tjoint(1:3,4)';

% get objective
f=norm(goal.P-Pact);


% constraint function
function [c, ce]=localCon(teta, rob, goal, settingteta)

% ASSUMPTION: the normal vector (goal.N) and the beam direction are assumed opposite each other

ce=[];

if isempty(goal.N)
    % set distance constraint
    c(1)=-1.0; % satisfied
    c(2)=-1.0; % satisfied
    c(3)=localObj(teta, rob, goal, settingteta)-goal.Eps;
    ce=[];
    return
end

% calculate beam direction
T=joint2Pos(teta, rob, settingteta);

% get robot point
if strcmp(goal.Objective,'tcp')
    idjoint=7;
elseif strcmp(goal.Objective,'scanner')
    idjoint=4;
end

Tjoint=setTransformation(T, idjoint);

Nbeam=-Tjoint(1:3,3);

% get normal target
Ngoal=goal.N;

% set constraint

% C1: beam direction
angle=acos(dot(Nbeam,Ngoal))*180/pi;

c(1)=angle-goal.Angle.Beam.Upper; % i.e.: angle <= Angle.Beam.Upper
c(2)=-angle+goal.Angle.Beam.Lower; % i.e.: angle <= Angle.Beam.Upper

% set distance constraint    
c(3)=localObj(teta, rob, goal, settingteta)-goal.Eps;
% c(3)=-1;

    