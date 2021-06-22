% initialise TSP solver
function tsp=initTSPSolver()

tsp.D=[];
tsp.Solver.Tour={1,'open', 'close'};
tsp.Solver.PopulationSize=1000;
tsp.Solver.MaxIter=5000;
tsp.Solver.PercentageIter=0.5;
tsp.Solver.Tol=0.1;

%--
tsp.Solution.Sequence=[];
tsp.Solution.Length=[];
tsp.Solution.Flag=true; % true/false
tsp.Solution.History.Enable=true;
tsp.Solution.History.Length=[];
tsp.Solution.NIter=0;

