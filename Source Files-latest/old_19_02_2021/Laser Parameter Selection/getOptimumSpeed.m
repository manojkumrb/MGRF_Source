% calculate the optimum welding speed for a given gap and given constraint on KPIs (penetration, s-value, TC, BC)
function speed=getOptimumSpeed(polymodel, gapRange)

% polymodel: poly model (penetration, s-value, TC, BC)
% gapRange: [min(gap), max(gap)]

id_kpi=1;

sz=size(polymodel{1}.ModelTerms);

% STEP 1: define constraints on KPIs
Tlower=1;
Tthinner=0.75;
Tupper=0.75;

% penetration
con{1}.A=[-1 1];
con{1}.b=[0.3*Tlower -Tlower];

% s-value
con{2}.A=[-1];
con{2}.b=[0.9*Tthinner];

% TC
con{3}.A=[1 -1];
con{3}.b=[-0.5*Tupper 0];

% BC
con{4}.A=[1 -1];
con{4}.b=[-0.5*Tlower 0];

% STEP 2: define constraints on input variables ([speed, gap])
LBx=[1 gapRange(1)];
UBx=[4 gapRange(2)];

options = gaoptimset('PopulationSize',50,'UseParallel','always');
 
% STEP 3: run single optimisation on penetration
xbest=ga(@(X)getSingleObj(X, polymodel{id_kpi}, 'max'), sz(2), [], [], [], [], LBx, UBx, @(X)getConstraint(X, polymodel, con),options);

speed=xbest(1);