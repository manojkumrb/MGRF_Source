% solve inverse kinematics
function varargout=pos2JointNumeric(rob)

warning off %#ok<WNOFF>

% rob: robot model
    
% varargout:
    % {1}: joint values
    % {2}:
        % log.Distance
        % log.Angle
    
%------------------------------------------------------------------------
goal=rob.Goal;

theta0=goal.Theta0(goal.Theta.IdVar);


% define joint limits - (first line: positive limit; second line: negative limit)
lb=rob.jointLim(2,goal.Theta.IdVar); % lower
ub=rob.jointLim(1,goal.Theta.IdVar); % upper

%-------------------------------------
option = optimset('TolX',goal.Solver.Eps,'TolFun',goal.Solver.Eps,...
                 'MaxFunEvals',goal.Solver.MaxIter,'TolCon',goal.Solver.Eps,'MaxIter',goal.Solver.MaxIter,...
                 'Algorithm', 'active-set',...
                 'Display', 'off');
  
thetasol=fmincon(@(teta)localObj(teta, rob, goal),theta0,[],[],[],[], lb, ub, @(teta)localCon(teta, rob, goal),option);

% FIRST output
nt=size(rob.jointLim,2);
theta=zeros(1,nt);
theta(goal.Theta.IdFix)=goal.Theta.ValFix;
theta(goal.Theta.IdVar)=thetasol;
varargout{1}=theta;

% SECOND output
if nargout==2
    f=localObj(thetasol, rob, goal);
    
    log.Distance=f; % TCP to goal.P
    
    if goal.CheckR
        log.Angle=getAngle(thetasol, rob, goal);
    else
        log.Angle=[0 0 0];
    end
            
    varargout{2}=log;
end   
    

%---------------------------------------
% objective function
function f=localObj(teta, rob, goal)

% get set of transformation
SettingTeta=goal.Theta;
T=joint2Pos(teta, rob, SettingTeta);

% get robot point
Tact=getTCPLocation(rob, T);
Pact=Tact(1:3,4)';

% get objective
f=norm(goal.P-Pact);


% constraint function
function [c, ce]=localCon(teta, rob, goal)

%--
ce=[];

if ~goal.CheckR
    % set distance constraint
    c=localObj(teta, rob, goal)-goal.Eps(1);
    ce=[];
    return
end

% get angles
angle=getAngle(teta, rob, goal);

c(1)=angle(1)-(goal.Angle(1)+goal.Eps(2)); % i.e.: angle <= Angle(1)+eps
c(2)=-angle(1)+(goal.Angle(1)-goal.Eps(2)); % i.e.: angle >= Angle(1)-eps

c(3)=angle(2)-(goal.Angle(2)+goal.Eps(2)); % i.e.: angle <= Angle(2)+eps
c(4)=-angle(2)+(goal.Angle(2)-goal.Eps(2)); % i.e.: angle >= Angle(2)-eps

c(5)=angle(3)-(90.0+goal.Eps(2)); % i.e.: angle <= 90.0+eps

% set distance constraint    
c(6)=localObj(teta, rob, goal)-goal.Eps(1);




%--
function angle=getAngle(teta, rob, goal)

% get actual line of sight
SettingTeta=goal.Theta;
T=joint2Pos(teta, rob, SettingTeta);

Tjoint=getTCPLocation(rob, T);

% NOTICE: the normal vector (goal.Nref) and the line of sight are opposite each other
Nline=-Tjoint(1:3,3); % flip the line's direction (Z axis)

% get normal target
Nref=goal.R(1,:);
Nt=goal.R(2,:);
Nv=goal.R(3,:);

% get angles
angle(1)=acos(dot(Nline, Nref))*180/pi;
angle(2)=acos(dot(Nline, Nt))*180/pi;
angle(3)=acos(dot(Nline, Nv))*180/pi;


    