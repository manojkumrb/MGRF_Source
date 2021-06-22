% optimise task planning which includes
    % 1. workpiece placement
    % 2. multiple IK
    % 3. tool orientation
    % 4. collision
    % 5. data quality
    
function taskPlanning = solveTaskPlanningOptimisationKMC(taskSequence, KMC, GAParameter, rob)

% Inputs:
% rob: robot model
% taskSequence:optimum sequence data
% KMC: KMC structure
% GAParameter.: GA settings
	% PopulationSize = 500;
	% TournamentGroup = 6;
	% CrossoverRate = 0.8;
	% MutationRate = 0.3;
	% MaxIteration = 1000;
	% Error = 0.01;
% Output

Ptasks=taskSequence.Point;
taskSequence=taskSequence.Tsp.Sequence;

% number of goal
N = size(Ptasks,1);

% initilaise chromosome
Chromosome = iniChromosome(N);

population(1,1:GAParameter.PopulationSize) =  Chromosome;

% intial feasible population of Chromosome
c=1;
while c<GAParameter.PopulationSize
    chromosomei= constructChromosome(N, taskSequence, rob.Model);
    
    i_psi = chromosomei.Psi;

    for k=1:N
        % build rotation matrix for given "phi" angle
        Rtask = lcnGetRtask(Ptasks(k,:), KMC(k).Vectors.Point, i_psi(k));

        % define goals
        rob.Kinematics.Goal.P=Ptasks(k,:);
        rob.Kinematics.Goal.R=Rtask;

        % define tool
        rob.Parameter.Tool.P = rob.Parameter.Tool.Camera.Centre;

        [~, ~, flag]=solveInverseKinematics(rob);
        
        if ~flag
            break
        end
    end
    
    if flag
        population(c)=chromosomei;
        c=c+1;
    end
        
end

%--
penaltyfact=GAParameter.PenaltyFact;
globalMin = inf;
ConvergenceHistory = zeros(1,GAParameter.MaxIteration);

% loop over max of GA iterations
for iter = 1:GAParameter.MaxIteration
    
    % build fittness function
    all_qik_pop=cell(1, GAParameter.PopulationSize);
    cycleTime = zeros(GAParameter.PopulationSize, 1);
    
    for p=1:GAParameter.PopulationSize   
        [ct, all_qik_chromosome] = calculateFitness(Ptasks, rob, population(p), KMC, penaltyfact);
        cycleTime(p) =  ct;
        all_qik_pop{p} = all_qik_chromosome;
    end

    [minCycleTime, index_min_CT] = min(cycleTime);
    ConvergenceHistory(iter) = minCycleTime;
    
    if minCycleTime <= globalMin
        err = abs(globalMin - minCycleTime);
        if err <= GAParameter.Error &&  minCycleTime < penaltyfact(1) &&  minCycleTime < penaltyfact(2)
            Chromosome = population(index_min_CT);
            GASolution = Chromosome;
            GASolution.CycleTime = minCycleTime;
            GASolution.QIKSet = all_qik_pop{index_min_CT};
            fprintf('.... Solution after %g iterations is %f \n', iter, GASolution.CycleTime);
            fprintf('.... Solution converged after %g iterations\n', iter);
            break
        end
    end
      
    % keep running
    globalMin = minCycleTime;
    Chromosome = population(index_min_CT);
    GASolution = Chromosome;
    GASolution.CycleTime = minCycleTime;
    GASolution.QIKSet = all_qik_pop{index_min_CT};
    fprintf('.... Solution after %g iterations is %f \n', iter, GASolution.CycleTime);

    % Trournament selection for new population
    popTournament = tournamentSelection(cycleTime, population, GAParameter);
    % uniform crossover 
    [popCrossOver, popNonCrossOver] = uniformCrossOver(popTournament, GAParameter);
    % new pouplation after crossover
    newpopulation = [popNonCrossOver, popCrossOver];
    %swap mutation
    [popMutation, popNonMutation] = mutation(newpopulation, GAParameter);
    %new population after mutation
    population = [popNonMutation, popMutation];
    
end % end of GA iterations
 

% save output
GASolution.ConvergenceHistory = ConvergenceHistory;
taskPlanning = GASolution;

if iter == GAParameter.MaxIteration
    fprintf('   maximum no. of iterations reached\n');
end
    
    
%---------------------------------------------    
%---------------------------------------------  
%---------------------------------------------
% initialise chromosome
function Chromosome = iniChromosome(N)

Chromosome.Sequence=randperm(N);
Chromosome.Psi = zeros(1,N);
Chromosome.IKConfiguration = ones(1,N);
Chromosome.WP = ones(1,N);


% ********  construction of chromosome for initial population   ***********
function Chromosome = constructChromosome(N, sequ, robtype)

%1
if nargin==1
    Chromosome.Sequence=randperm(N);
else
    Chromosome.Sequence=sequ;
end

%2
Chromosome.Psi = (2*pi).*rand(1,N);

%3
if strcmp(robtype,'ABB6620')
    Chromosome.IKConfiguration = randi([1, 8],1,N); % ABB IRB6620 (up to 8 feasible IK configurations)
else
    
    % to be completed with new robot models
    
end

%4
Chromosome.WP = zeros(1,6); % [x y z alfa beta gamma]


%****************  Calculate fitness i.e cycle time  **********************
function [cycleTime, all_qik] = calculateFitness(Ptasks, rob, chromosome_i, KMC, penaltyfact)

N=size(Ptasks,1);

i_seq = chromosome_i.Sequence;
i_config = chromosome_i.IKConfiguration;
i_psi = chromosome_i.Psi;

all_qik=cell(N,1);
for i=1:N
    
    % build rotation matrix for given "phi" angle
    Rtask = lcnGetRtask(Ptasks(i,:), KMC(i).Vectors.Point, i_psi(i));

    % define goals
    rob.Kinematics.Goal.P=Ptasks(i,:);
    rob.Kinematics.Goal.R=Rtask;
    
    % define tool
    rob.Parameter.Tool.P = rob.Parameter.Tool.Camera.Centre;
                
    [qik, ~, flag]=solveInverseKinematics(rob);
    
    if flag % feasible solution
        all_qik{i}=qik;
    else % first not feasible solution
        all_qik{i}=qik;
        break
    end

end

if flag % true => all feasible solutions
    
    qiksz = cellfun(@size, all_qik,'uni',false);
    t_qik_max = zeros(1, size(Ptasks,1)-1);
    
    for j=1:N-1 % counting the segment on the path (N-1)

        goal1 = i_seq(j);
        goal2 = i_seq(j+1);
        qik1 = i_config(j);
        qik2 = i_config(j+1);

        if qik1 <= qiksz{goal1}(1,1) && qik2 <= qiksz{goal2}(1,1)

            q12 = [all_qik{goal1}(qik1,:)
                   all_qik{goal2}(qik2,:)];

            c = abs(q12(1,:) - q12(2,:));
            
            %----------------
            % this part could be improved considering acceleration, jerk, etc...
            t_qik = c./rob.SpeedLim; % time calculated in speed unit (default=rad/secs)
            
            
            t_qik_max(j) = max(t_qik);
        else
            
            
            %----------------
            % this part should be made more automatic
            
            t_qik_max(j) = penaltyfact(2); % the generated IK conf exceeds the max feasible IK solution
            
            %----------------
            
        end

    end

    cycleTime = sum(t_qik_max);
    
else  % no feasible IK solution at all   
    cycleTime = penaltyfact(1);
end


%--
function Rtask = lcnGetRtask(Ptask, PointKMC, psi)

vtkmc =  PointKMC - Ptask;
vtkmc = vtkmc/norm(vtkmc);

R0vtkmc=vector2Rotation(vtkmc);
Rpsi=RodriguesRot([0 0 1],psi);

Rtask=R0vtkmc*Rpsi;


%**********************  Uniform Crossover   ******************************
function [popCrossOver, popNonCrossOver] = uniformCrossOver(pop, GAParameter)

randProb = rand(GAParameter.PopulationSize,1);

popNonCrossOver = pop(randProb > GAParameter.CrossoverRate);
popCross = pop(randProb <= GAParameter.CrossoverRate);

for i=1:2:size(popCross,2)-2
    
    id = randi([1,size(popCross,2)-2], 1, 2);
    parent1 = popCross(id(1)).IKConfiguration;
    parent2 = popCross(id(2)).IKConfiguration;
    
    [offspring1, offspring2] = getOffSpringCrossOver(parent1, parent2);
    
    popCross(i).IKConfiguration = offspring1;
    popCross(i+1).IKConfiguration = offspring2;
    
  
    %--------------
    % we might consider to use different "id" for "psi"
    %--------------
    parent1 = popCross(id(1)).Psi;
    parent2 = popCross(id(2)).Psi;
    
    [offspring1, offspring2] = getOffSpringCrossOver(parent1, parent2);
    
    popCross(i).Psi = offspring1;
    popCross(i+1).Psi = offspring2;
       
end

popCrossOver = popCross;


function  [offspring1, offspring2] = getOffSpringCrossOver(parent1, parent2)

mask = randi([0,1],1,size(parent1,2));
ind = find(mask > 0);

offspring1 = parent1;
offspring2 = parent2;

offspring2(ind) = parent1(ind);
offspring1(ind) = parent2(ind);
 
    
 %*************************  Tournament selecetion   **********************
function popTournament = tournamentSelection(cycleTime, pop, GAParameter)  
    
popTournament=pop;
for i = 1:GAParameter.PopulationSize
    trmntGrp = randi([1 GAParameter.PopulationSize],GAParameter.TournamentGroup,1); 
    grpCycleTime = cycleTime(trmntGrp);
    [~, grpIndex] = min(grpCycleTime);
    bestChromose = pop(trmntGrp(grpIndex));
    popTournament(i) = bestChromose;
end



%*********************** Swap Mutation ************************************
function [popMutation, popNonMutation] = mutation(pop, GAParameter)

randProb = rand(GAParameter.PopulationSize,1);

popNonMutation = pop(randProb > GAParameter.MutationRate);
popMut = pop(randProb <= GAParameter.MutationRate);

for i=1:size(popMut,2)
    
    parent = popMut(i).IKConfiguration;
    offspring = getOffSpringMutation(parent);
    popMut(i).IKConfiguration = offspring;
    
    parent = popMut(i).Psi;
    offspring = getOffSpringMutation(parent);
    popMut(i).Psi = offspring;
        
end

popMutation = popMut;


function offspring = getOffSpringMutation(parent)

nodeMute = randi([1,size(parent,2)],1, 2 );
offspring = parent;
offspring(nodeMute(1)) = parent(nodeMute(2));
offspring(nodeMute(2)) = parent(nodeMute(1));


   