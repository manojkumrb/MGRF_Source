% calculate best point within the KMC
function sol=selectBestPointKMC(KMC, idkmc, WeightData, StationData, HierarchyData)

% INPUT
% WeightData.
    % Distance
    % Collision
    % Coverage
    % ...

% StationData.
    % Robot
    % Workpiece

% HierarchyData
    % Top: "distance", "collision", "coverage" (string)
    % Bottom: "distance", "collision", "coverage" (cell array [1xnc])
    
% OUTPUT
% sol.
    % Point=[1x3] point location 
    % Objective [1x1] => HierarchyData.Top 
    % Constraint [1xnc] => HierarchyData.Bottom
    % Status

% init output
sol.Point=[];
sol.Objective=[];
sol.Constraint=[];
sol.Status=false;

% set optimisation settings
options = optimset ( 'Algorithm' , 'active-set', ... 
                    'MaxFunEvals', 1000 , ... % Maximum number of evaluations
                    'TolFun', 1e-9, ... % f value tolerance
                    'TolX', 1e-9);  %                     'display','none'

%--  define initial conditions
X0(1)=mean(KMC(idkmc).Constraints.Distance);
X0(2)=mean(KMC(idkmc).Constraints.Angle.Normal)*pi/180;
X0(3)=mean(KMC(idkmc).Constraints.Angle.Tangent)*pi/180;
   
% upper limits (radians)
Ub=[KMC(idkmc).Constraints.Distance(2)
    KMC(idkmc).Constraints.Angle.Normal(2)*pi/180
    KMC(idkmc).Constraints.Angle.Tangent(2)*pi/180];

% lower limits (radians)
Lb=[KMC(idkmc).Constraints.Distance(1)
    KMC(idkmc).Constraints.Angle.Normal(1)*pi/180
    KMC(idkmc).Constraints.Angle.Tangent(1)*pi/180];

%------------------------------------------
% define objective function
if isempty(HierarchyData.Top)
    return
end
    
Fobj=@(X)getMultiLevelAttributeKMC(X, KMC, idkmc, WeightData, StationData, HierarchyData.Top);
%------------------------------------------

% define constraints
if ~isempty(HierarchyData.Bottom)
    Fcon=@(X)lcnGetConstraints(X, KMC, idkmc, WeightData, StationData, HierarchyData);
else
    Fcon=[];
end
%------------------------------------------

% solve problem
Xbest=fmincon(Fobj, X0,...
              [],[],[],[],...
              Lb, Ub,...
              Fcon,...
              options);

% options = gaoptimset('PopulationSize',50);
% Xbest =ga(Fobj, 3, [], [], [], [], Lb, Ub, Fcon, options);

%-- save out 
sol.Point=getMultiLevelAttributeKMC(Xbest, KMC, idkmc, WeightData, StationData, 'point');

sol.Objective=getMultiLevelAttributeKMC(Xbest, KMC, idkmc, WeightData, StationData, HierarchyData.Top);

[sol.Constraint, ~]=lcnGetConstraints(Xbest, KMC, idkmc, WeightData, StationData, HierarchyData);

sol.Status=true;
for i=1:length(sol.Constraint)
    if sol.Constraint(i)~=-1
        sol.Status=false;
        break
    end
end


%--------------------------------------------------------------
% assembly multiple constraints
function [c, ce]=lcnGetConstraints(X, KMC, id, WeightData, StationData, HierarchyData)

ce=[];

nc=length(HierarchyData.Bottom);
c=zeros(1,nc);
for i=1:nc
    c(i)=getMultiLevelAttributeKMC(X, KMC, id, WeightData, StationData, HierarchyData.Bottom{i});
end

