clc
clear
close all

opt=initOptimisationSolver();

opt.Solver.nVars=2;
opt.Fittness.Fnc.F=@fittnessOptFnc;
opt.Solver.Type{1}=1;
opt.Solver.PopulationSize=500;
opt.Constraints.Enable=true;
opt.Constraints.EnableBnd=true;
opt.Solution.History.Enable=true;
opt.Constraints.Bound.Lower=[-512 -512];
opt.Constraints.Bound.Upper=[512 512];

opt = runOptimisationSolver(opt);

fobj=opt.Solution.Fnc.Fitness


optNM=opt;

optNM.Solver.X0=opt.Solution.X;
optNM.Solver.Type{1}=2;
optNM.Constraints.Enable=true;
optNM.Constraints.EnableBnd=true;
optNM = runOptimisationSolver(optNM);

fobj=optNM.Solution.Fnc.Fitness


% xsol=opt.Solution.X
% fobj=opt.Solution.Fnc.Fitness
% c=opt.Solution.Fnc.Constraints
% n=opt.Solution.NIter

% %%
% %--
% subplot(1,2,1)
% plot(optGA.Solution.History.Fittness.Fnc)
% grid on
% box on
% 
% xlabel('# iterations')
% ylabel('fitness function')
% 
% subplot(1,2,2)
% plot(optNM.Solution.History.Fittness.Fnc)
% grid on
% box on
% 
% xlabel('# iterations')
% ylabel('fitness function')


