% solve TSP problem
function tsp=runTSPsolver(tsp)

% tsp: tsp model

fprintf('Solving TSP problem...\n');
    
% read input
popSize=tsp.Solver.PopulationSize;
n=size(tsp.D,1);
maxIter=tsp.Solver.MaxIter;
nIterStop=ceil(tsp.Solver.MaxIter*tsp.Solver.PercentageIter);
eps=tsp.Solver.Tol;

%-----------------------
globalMin=inf;

vcross=4:4:popSize;
popSize=vcross(end);

%-- STEP 1: randomly initialize the population
pop = zeros(popSize,n);
pop(1,:) = (1:n);
for k = 2:popSize
    pop(k,:) = randperm(n);
end
    
%--
totalDist = zeros(1,popSize);
tmpPop = zeros(4,n);
newPop = zeros(popSize,n);

if tsp.Solution.History.Enable
    tsp.Solution.History.Length=zeros(1, maxIter);
end

% loop over total iterations
cstops=0;
for iter = 1:maxIter
    
    %-- STEP 2: calculate total fitness
    for p = 1:popSize
        
        % check open/closed tour
        tour_type=tsp.Solver.Tour{tsp.Solver.Tour{1}+1};
        if strcmp(tour_type,'open')
            d = 0;
        elseif strcmp(tour_type,'closed')
            d = tsp.D(pop(p,n),pop(p,1)); % closed sequence
        end
        
        for k = 2:n
            d = d + tsp.D(pop(p,k-1),pop(p,k));
        end
        totalDist(p) = d;
    end
    
    %-- STEP 3: best solution (min)
    [minDist, index] = min(totalDist);
    
    if tsp.Solution.History.Enable
        tsp.Solution.History.Length(iter)=minDist;
    end
    
    % check stopping criteria
    if minDist <= globalMin % best solution so far

        err=abs(globalMin - minDist);
        
        % update stooping counter
        if err<eps 
            cstops=cstops+1;
        end
        
        % check convergency
        if cstops==nIterStop
            tsp.Solution.Sequence = pop(index,:);
            tsp.Solution.Length=minDist;
            
            tsp.Solution.NIter=iter;
            
            fprintf('   solution converging after %g iterations\n', iter);
            
            break
        end
        
        % keep rolling
        globalMin = minDist;
        
        sol.Sequence = pop(index,:);
        sol.Length=minDist;
    end

    %-- STEP 4: shuffle population ("tournament selection method")
    randomOrder = randperm(popSize);
    for p = vcross
        rdnp = pop(randomOrder(p-3:p),:);
        dists = totalDist(randomOrder(p-3:p));
        [~,idx] = min(dists); 
        bestpath = rdnp(idx,:);
        
        % define mutations nodes
        crossnodes = sort(ceil(n*rand(1,2)));
        I = crossnodes(1);
        J = crossnodes(2);
        
        % mutate the best to get 3 new chromosomes
        for k = 1:4 
            tmpPop(k,:) = bestpath;
            switch k
                case 2 % Flip
                    tmpPop(k,I:J) = tmpPop(k,J:-1:I);
                case 3 % Swap
                    tmpPop(k,[I J]) = tmpPop(k,[J I]);
                case 4 % Slide
                    tmpPop(k,I:J) = tmpPop(k,[I+1:J I]);
            end
        end
        newPop(p-3:p,:) = tmpPop;
    end
    
    pop = newPop;
    
end

%--
if iter==maxIter
    tsp.Solution.Flag=false;
    fprintf('   maximum no. of iterations reached\n');
end

