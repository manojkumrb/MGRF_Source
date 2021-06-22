% *****************  function for GA Parameters   *************************
function GAParameter = initGAParameter()

GAParameter.PopulationSize = 500;
GAParameter.TournamentGroup = 6;
GAParameter.CrossoverRate = 0.8;
GAParameter.MutationRate = 0.3;
GAParameter.MaxIteration = 1000;
GAParameter.Error = 0.01;

GAParameter.PenaltyFact=[100 10]; % [no IK solution; mutation and cross-over penalty for max counter on IK]