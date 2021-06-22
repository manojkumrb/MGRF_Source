% run GA solver
function opt = runGASolver(opt)

%- INPUT:
% opt: options (see initialisation)

%- OUTPUT:
% opt: updated "opt" structure 
    % opt.Solution.Flag: 0,1,2 => 0=solution found and feasible; 1=max iterations reached; 2=no feasible solution
    
%----------
% Notice: constraints handled by penalty method
%----------

% read inputs

% pop size
popSize=opt.Solver.PopulationSize;

% max iter
maxIter=opt.Solver.MaxIter;

% fittness function
fobj=opt.Fittness.Fnc.P;

% no. of variables
nVars=opt.Solver.nVars;

% max iters which gives constant convergence
nIterStop=ceil(opt.Solver.MaxIter*opt.Solver.PercentageIter);

% STEP 1: generate initial population
initChrom=opt.Solver.Chromosome;
pop=zeros(popSize, nVars);
for i=1:popSize
    pop(i,:)=initChrom(opt);
end

% run GA iterations
globalMin = inf;
cstops=0;
for iter = 1:maxIter

    % STEP 2: evaluate fitness function
    fsol=zeros(1,popSize);
    for p=1:popSize
        xp=pop(p,:);
        fsol(p)=fobj(xp,opt);
    end
    
    % check best solution
    [minfsol, indexmin] = min(fsol);
    
    % store if needed
    if opt.Solution.History.Enable
       opt.Solution.History.Fittness.Fnc=[opt.Solution.History.Fittness.Fnc, minfsol];
    end
        
    % check convergency
    if minfsol <= globalMin
        err = abs(globalMin - minfsol);
                
        if err <= opt.Solver.TolFun
            
            % update stopping counter
            if err<eps 
                cstops=cstops+1;
            end

            % check convergency
            if cstops==nIterStop
                xsol=pop(indexmin,:);

                opt.Solution.X = xsol;
                opt.Solution.Fnc.Fitness=minfsol;

                if opt.Constraints.Enable % store constraints values
                    opt.Solution.Fnc.Constraints=opt.Constraints.Fnc.C(xsol);
                end

                opt.Solution.NIter=iter;
                break
            end
        end
    end
      
    % keep running
    globalMin = minfsol;
    
    % Crossover population: loop over the new population's size and create individuals from current population
    % STEP 3/4: selection of parents by tournament selection / crossover
    pop = getCrossOver(pop, fsol, opt);
    
    % STEP 5: Mutate the new population a bit to add some new genetic material
    pop = getMutation(pop, opt);
    
end % end GA iterations

if iter>maxIter
    fprintf('       (Warning) max no. of iterations reached: %g\n', maxIter);
else
    fprintf('       Solution found after %g iterations\n', iter);
end


%----------- Crossover
function popCross = getCrossOver(pop, fsol, opt)

% pop size
popSize=opt.Solver.PopulationSize;

% crossover rate
crossrate=opt.Solver.CrossoverRate;

popCross=pop;
for i=1:popSize
    
    randProb = rand(1);
    if randProb<=crossrate % apply crossover
        
        % select parents
        parent1=getTournament(pop, fsol, opt);
        parent2=getTournament(pop, fsol, opt);
        offspring = getOffSpringCrossOver(parent1, parent2, opt);
                
        % save back
        popCross(i,:)=offspring;
    end
        
end


%----------- Mutation
function popMut = getMutation(pop, opt)

% pop size
popSize=opt.Solver.PopulationSize;

popMut=pop;
for i=1:popSize
    
    % apply mutation
    offspring = getOffSpringMutation(pop(i,:), opt);
    
    % save back
    popMut(i,:)=offspring;
        
end

%-----------
function bestChromose=getTournament(pop, fsol, opt)

% population size
popSize=opt.Solver.PopulationSize;

% no. of parents per group 
K=opt.Solver.TournamentGroup;

% select at random
trmntgrp = randi([1 popSize],1,K); % "K" individuals from the population at random and select the best out of these to become a parent

% get best
fsolgrp = fsol(trmntgrp);
[~, grpIndex] = min(fsolgrp);
bestChromose = pop(trmntgrp(grpIndex),:);
    
%----------- get offspring crossover
function  offspring = getOffSpringCrossOver(parent1, parent2, opt)

% crossover type
crossovertype=opt.Solver.CrossoverType{opt.Solver.CrossoverType{1}+1};

if strcmp(crossovertype,'uniform') % uniform crossover
    offspring = getOffSpringCrossOverUniform(parent1, parent2, opt);
elseif strcmp(crossovertype,'OC') % order crossover
    offspring = getOffSpringCrossOverCO(parent1, parent2, opt);
else
    
    % add here any other model
    
end


%----------- get offspring crossover (uniform)
function  offspring = getOffSpringCrossOverUniform(parent1, parent2, opt)

% no. of variables
nVars=opt.Solver.nVars;

offspring = parent1;
for i=1:nVars
    coin = randi([0,1],1,1);
    
    if coin==0
        offspring(i) = parent2(i);
    end
end

%----------- get offspring crossover (ordered - CO)
function  offspring = getOffSpringCrossOverCO(parent1, parent2, opt)

% no. of variables
nVars=opt.Solver.nVars;

offspring=zeros(1,nVars);

% create random crossover points
genechunk = randi([1,nVars],1, 2);

genechunk=sort(genechunk);
I = genechunk(1);
J = genechunk(2);

% copy the segment between [I J] to the offspring
for i=I:J
    offspring(i)=parent1(i);
end

% tag parent2 ("-1") as used
for i=I:J
    for k=1:nVars
        if parent2(k)==parent1(i)
            parent2(k)=-1;
            break;
        end
    end
end

% start from the second cross-over point and backward copy genes from second parents (if un-used)
idc=[J+1:nVars, 1:J];
count=J;
for k=idc
    if parent2(k)>-1 % un-used
        
        if (count+1)>nVars
            count=1;
        else
            count=count+1;
        end
        offspring(count)=parent2(k); % save it
        
    end
end


%----------- mutation
function offspring = getOffSpringMutation(parent, opt)

% no. of variables
nVars=opt.Solver.nVars;

% mutation rate
mutationrate=opt.Solver.MutationRate;

% mutation type
mutationtype=opt.Solver.MutationType{opt.Solver.MutationType{1}+1};

offspring = parent;

randProb = rand(1);
if randProb<=mutationrate % apply mutation
    genechunk = randi([1,nVars],1, 2);
    
    genechunk=sort(genechunk);
    I = genechunk(1);
    J = genechunk(2);
        
    if strcmp(mutationtype,'flip')
        offspring(I:J) = parent(J:-1:I);
    elseif strcmp(mutationtype,'swap')
        offspring([I J]) = parent([J I]);
    elseif strcmp(mutationtype,'slide')
        offspring(I:J) = parent([I+1:J I]);
    else
        
        % add here any other model
        
    end
    
end


   