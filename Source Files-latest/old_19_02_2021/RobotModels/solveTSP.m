% solve TSP problem
function sol=solveTSP(rob, tsp)

% rob: robot model
% tsp. 
    % Q.
        % Joint: solution of IK
        % nSol: no. of solutions
    % PopulationSize: size (1x1)
    % MaxIter: max no. of iterations (1x1)
    % Stopping.Eps: stopping error (1x1)
    % Stopping.PercentageIter: percentage of iterations to check (1x1)
    % Option.Tour: "closed"; "open"
    
% sol.
    % Sequence: optimum task sequence
    % Length: length of optimum sequence
    % Convergency.History: solution history
    % Convergency.Iter: convergency iter
        
fprintf('Solving TSP problem...\n');
    
% read inputs
popSize=tsp.PopulationSize; % population size
n=length(tsp.Q); % no. of genes for chromosome

maxIter=tsp.MaxIter;

nIterStop=ceil(tsp.MaxIter*tsp.Stopping.PercentageIter);
eps=tsp.Stopping.Eps;

%-- init output
sol=initChromosome(n);
sol.Length=0;
sol.Convergency.History=zeros(1, maxIter);
sol.Convergency.Iter=1;

%-----------------------
globalMin=inf;

vcross=4:4:popSize;
popSize=vcross(end);

% STEP 1: initialize population
%- init
pop(1)=initChromosome(n);
pop(popSize)=initChromosome(n);

newPop(1) = initChromosome(n); newPop(popSize) = initChromosome(n);

%- random sample of initial population
for k = 2:popSize
    pop(k)=sampleChromosome(tsp);
end
         
% loop over total iterations
cstops=0;
for iter = 1:maxIter
    
    %--
    sol.Convergency.Iter=iter;
    
    %-- STEP 2: calculate total fitness
    totalDist=calculateFittness(rob, tsp, pop);

    %-- STEP 3: best solution (min)
    [minDist, index] = min(totalDist);
    
    sol.Convergency.History(iter)=minDist;
            
    % check stopping criteria
    if minDist <= globalMin % best solution so far

        err=abs(globalMin - minDist);
        
        % update stopping counter
        if err<eps 
            cstops=cstops+1;
        end
        
        % check convergency
        if cstops==nIterStop
            sol.Sequence = pop(index).Sequence;
            sol.Configuration = pop(index).Configuration;
            sol.Length=minDist;
            
            fprintf('   solution converging after %g iterations\n', iter);
            break
        end
        
        % keep rolling
        globalMin = minDist;
        
        sol.Sequence = pop(index).Sequence;
        sol.Configuration = pop(index).Configuration;
        sol.Length=minDist;
    end

    %-- STEP 4: shuffle population ("tournament selection method")
    randomOrder = randperm(popSize);
    for p = vcross
        rp=randomOrder(p-3:p); %--
        
        rdnp = pop(rp);
        dists = totalDist(rp);
        [~,idx] = min(dists); 
        bestchromosome = rdnp(idx);
        
        % mutate the best to get 3 new chromosomes (and preserve the best)
        mPop=mutateChromosome(tsp, bestchromosome); % [best, 3 new mutated chromosomes]
        
        newPop(p-3:p) = mPop;
    end
    
    pop = newPop;
    
end

%--
if iter==maxIter
    fprintf('   maximum no. of iterations reached\n');
end

% calculate fitness (distance matrix)
function totalDist=calculateFittness(rob, tsp, pop)

% read inputs
popSize=tsp.PopulationSize; % population size
n=length(tsp.Q); % no. of genes for chromosome

totalDist=zeros(1,popSize);

% loop over all chromosomes
for p = 1:popSize

    % read chromosome
    chromosomei=pop(p);
    
    % check open/closed tour
    d=0;
    if strcmp(tsp.Option.Tour,'closed') % closed sequence
        s=chromosomei.Sequence(1); e=chromosomei.Sequence(n); % start/end genes
        sc=chromosomei.Configuration(1); ec=chromosomei.Configuration(n); % start/end configuration
        
        joint(1,:)=tsp.Q(s).Joint(sc,:);
        joint(2,:)=tsp.Q(e).Joint(ec,:);
        d=lcnDistance(rob, joint);
    end

    for k = 2:n
        s=chromosomei.Sequence(k); e=chromosomei.Sequence(k-1); % start/end genes
        sc=chromosomei.Configuration(k); ec=chromosomei.Configuration(k-1); % start/end configuration
        
        joint(1,:)=tsp.Q(s).Joint(sc,:);
        joint(2,:)=tsp.Q(e).Joint(ec,:);
        dk=lcnDistance(rob, joint);
        
        d = d + dk;
    end
    totalDist(p) = d;
end
      
%-- 
function d=lcnDistance(rob, Joint)

intData=interpolationRobotMotion(rob, Joint);
d=intData.Length;

%--
function c=initChromosome(n)

c.Sequence=1:n;
c.Configuration=ones(1,n);


%--
function chromosome=sampleChromosome(tsp)

% read inputs
n=length(tsp.Q); % no. of genes for chromosome

% define chromosome
%-- sequence
chromosome.Sequence=randperm(n);

%-- configuration
conf=zeros(1,n);
for j=1:n
  nsolconf=tsp.Q(j).nSol;
  if nsolconf>1
    conf(j)=ceil(nsolconf*rand(1));
  else
    conf(j)=1;
  end
end

chromosome.Configuration=conf;

%--
function mPop=mutateChromosome(tsp, bestchromosome)

% read inputs
n=length(tsp.Q); % no. of genes for chromosome

% init mutated population
mPop(1) = initChromosome(n); mPop(4) = initChromosome(n);

% define mutations genes
mutationnodes = sort(ceil(n*rand(1,2)));
I = mutationnodes(1);
J = mutationnodes(2);

% mutate the best to get 3 new chromosomes
for k = 1:4 
    
    %-- sequence
    bestchromosomesk=bestchromosome.Sequence;
    
    switch k
        case 2 % Flip
            bestchromosomesk(I:J)=bestchromosomesk(J:-1:I);
        case 3 % Swap
            bestchromosomesk([I J])=bestchromosomesk([J I]);
        case 4 % Slide
            bestchromosomesk(I:J)=bestchromosomesk([I+1:J I]);
    end
    
    %-- configuration
    bestchromosomeck=zeros(1,n);
    for j=1:n
      nsolconf=tsp.Q(j).nSol;
      if nsolconf>1
        bestchromosomeck(j)=ceil(nsolconf*rand(1));
      else
        bestchromosomeck(j)=1;
      end
    end

    % save back
    bestchromosome.Sequence=bestchromosomesk;
    bestchromosome.Configuration=bestchromosomeck;
    
    % save back
    mPop(k) = bestchromosome;
end
