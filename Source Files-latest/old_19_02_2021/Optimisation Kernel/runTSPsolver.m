% solve TSP problem
function tsp=runTSPsolver(opt, D, tourType)

% tsp: tsp model

fprintf('Solving TSP model...\n');
   
opt.Solver.Type{1}=1; % use GA
nvars=size(D,1); opt.Solver.nVars=nvars;

% fittness function
opt.Fittness.Fnc.F=@(x)lnc_calculate_fitness(x, D, tourType);

% define bounds for GA
opt.Constraints.Enable=false;
opt.Constraints.Bound.Lower=ones(1, nvars);
opt.Constraints.Bound.Upper=ones(1, nvars)*nvars;

% define chromosome
opt.Solver.Chromosome=@lnc_init_chromosome;

% define mutation and cross over srategy
opt.Solver.MutationType{1}=1; % use "swap" for mutation
opt.Solver.CrossoverType{1}=2; % use "ordered crossover" for crossover

opt.Solver.CrossoverRate=0.95; 
opt.Solver.MutationRate=0.05; 

%-------------------------------
% solve optimisation problem
opt = runGASolver(opt);
%-------------------------------

% save back
tsp.Sequence=opt.Solution.X;
tsp.Length=opt.Solution.Fnc.Fitness;
tsp.History=opt.Solution.History.Fittness.Fnc;
tsp.NIter=opt.Solution.NIter;

if tsp.NIter<=opt.Solver.MaxIter
    fprintf('     (Message) Solution found after %g iterations\n', tsp.NIter);
    tsp.Flag=0;
else
    fprintf('     (Warning) Max no. of iteration reached\n');
    tsp.Flag=1;
end


%---------------------------
% calculate total fitness
function d=lnc_calculate_fitness(x, D, tourType)

n=size(D,1);

% check open/closed tour
if strcmp(tourType,'open')
    d = 0;
elseif strcmp(tourType,'closed')
    d = D(x(n),x(1)); % closed sequence
end

for k = 2:n
    d = d + D(x(k-1),x(k));
end
 
% initialise chromosome
function Chromosome = lnc_init_chromosome(opt)

% no. of variables
nVars=opt.Solver.nVars;
Chromosome=randperm(nVars);


