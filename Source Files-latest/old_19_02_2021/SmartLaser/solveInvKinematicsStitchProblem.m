function [Trobot, log, teta]=solveInvKinematicsStitchProblem(rob,...
                                                       Ptcps, Ptcpe,...
                                                       Ntcps, Ntcpe,...
                                                       normangle, off_defocusing, theta0)

% solve robot position
Pf=mean([Ptcps
        Ptcpe]);

Nf=mean([Ntcps
        Ntcpe]);

goal.P=Pf;
goal.Offset=off_defocusing;
goal.N=Nf;
goal.Angle.Beam.Upper=normangle(1);
goal.Angle.Beam.Lower=normangle(2);
goal.Angle.Offset=1e-4;

rob.jointLim(:,7)=[1100; 1100]; % focal distance

if isempty(theta0)
 [tetar, logr]=pos2JointNumeric(goal, rob, []);
else  
 [tetar, logr]=pos2JointNumeric(goal, rob, [], theta0);
end

consttheta.Id=1:4;
consttheta.Value=tetar(1:4);

% solve TCP position

% start point
Pf=Ptcps;  
Nf=Ntcps;

goal.P=Pf;
goal.N=Nf;

rob.jointLim(:,7)=[1143; 1000]; % focal distance

if isempty(theta0)
    [teta(1,:), log{1}]=pos2JointNumeric(goal, rob, consttheta);
else
    [teta(1,:), log{1}]=pos2JointNumeric(goal, rob, consttheta, theta0);
end
Trobot{1}=joint2Pos(teta(1,:), rob);

% end point
Pf=Ptcpe;  
Nf=Ntcpe;

goal.P=Pf;
goal.N=Nf;

if isempty(theta0)
    [teta(2,:), log{2}]=pos2JointNumeric(goal, rob, consttheta);
else
    [teta(2,:), log{2}]=pos2JointNumeric(goal, rob, consttheta, theta0);
end

Trobot{2}=joint2Pos(teta(2,:), rob);


