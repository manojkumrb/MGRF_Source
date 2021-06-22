% initialise chromosome
function Chromosome = iniChromosome(opt)

% no. of variables
nVars=opt.Solver.nVars;

xl=opt.Constraints.Bound.Lower;
xu=opt.Constraints.Bound.Upper;

if size(xl,2)==1
    xl=xl';
end
if size(xu,2)==1
    xu=xu';
end

Chromosome=xl+(xu-xl).*rand(1,nVars);