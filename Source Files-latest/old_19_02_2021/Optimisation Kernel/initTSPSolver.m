% initialise TSP solver
function tsp=initTSPSolver()

tsp.D=[];
tsp.Solver.Tour={1,'open', 'close'};

%--
tsp.Solution.Sequence=[];
tsp.Solution.Length=[];
tsp.Solution.History.Length=[];
tsp.Solution.NIter=0;

