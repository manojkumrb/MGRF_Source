% init optimisation solver
function opt=initOptimisationSolver()

opt.Solver.X0=0;
opt.Solver.nVars=1;
opt.Solver.TolX=1e-6;
opt.Solver.TolFun=1e-6;
opt.Solver.PercentageIter=0.1;
opt.Solver.MaxIter=1000;
opt.Solver.PopulationSize=100;
opt.Solver.TournamentGroup=2;
opt.Solver.CrossoverRate=0.9; % it corresponds to the probability P(x)<=CrossoverRate
opt.Solver.MutationRate=0.1; % it corresponds to the probability P(x)<=MutationRate
opt.Solver.MutationType={1, 'swap', 'flip', 'slide'};
opt.Solver.CrossoverType={1, 'uniform', 'OC'}; % uniform; order crossover

opt.Solver.Type={1, 'GA', 'NelderMead'};

opt.Fittness.Fnc.F=@fittnessOptFnc; % fittness
opt.Fittness.Fnc.P=@augFittnessOptFnc; % augmented fittness with constraints (if any)

opt.Solver.Chromosome=@iniChromosome;

opt.Constraints.Enable=false;
opt.Constraints.EnableBnd=false;
opt.Constraints.Bound.Lower=-1;
opt.Constraints.Bound.Upper=1;
opt.Constraints.Fnc.C=@constraintsOptFnc; % constraint functions
opt.Constraints.Fnc.Phi=@penaltyOptFnc; % penalty functions
opt.Constraints.Penalty.Stiffness=10e12;
opt.Constraints.Penalty.Adaptive.Enable=false;
opt.Constraints.Penalty.Adaptive.Fnc=@adaptiveOptPenalty;
opt.Constraints.Penalty.Adaptive.MaxIter=100;
opt.Constraints.Tol=1e-6;

opt.Solution.X=0;
opt.Solution.Flag=2; % 0=solution found and feasible; 1=max iterations reached; 2=no feasible solutions
opt.Solution.Fnc.Fitness=0;
opt.Solution.Fnc.Constraints=[];
opt.Solution.History.Enable=true;
opt.Solution.History.Fittness.Fnc=[];
opt.Solution.NIter=0;

