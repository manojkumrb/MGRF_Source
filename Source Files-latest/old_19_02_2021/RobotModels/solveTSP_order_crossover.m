% solve TSP problem by GA
function sol=solveTSP(tsp)

% tsp.
    % D: distance matrix (nxn)
    % PopulationSize: size (1x1)
    % Eps: convergency accuracy (1x1)
    % MaxIter: max no. iterations (1x1)
 
% sol.
    % Path: optimum path
    % Legth: length of optimum path
    
fprintf('Solving TSP problem...\n');
    
% read input
popSize=tsp.PopulationSize;
n=size(tsp.D,1);
eps=tsp.Eps;
maxIter=tsp.MaxIter;

%-- init output
sol.Path=zeros(1,n);
sol.Length=0;
sol.History=0;

%--
globalMin=inf;

%-- STEP 1: randomly initialize the population
pop = zeros(popSize,n);
pop(1,:) = (1:n);
for k = 2:popSize
    pop(k,:) = randperm(n);
end
    
%--
totalDist = zeros(1,popSize);

% loop over total GA iterations
for iter = 1:maxIter

    %-- STEP 2: calculate total fitness for given chromosome
    for p = 1:popSize
%        d=0;
        d = tsp.D(pop(p,n),pop(p,1)); % closed Path
        for k = 2:n
            d = d + tsp.D(pop(p,k-1),pop(p,k));
        end
        totalDist(p) = d;
    end
    
    %-- STEP 3: get best solutions so far (best 2 chromosomes)
    [totalDist, index] = sort(totalDist); % sort ascending
    minDist=totalDist(1);
    bestchromosomes=index(1:2);
    worstchromosomes=index(end-1:end);
    
    sol.History(iter)=minDist;
    
    
    if minDist < globalMin

        
        err=abs(minDist - globalMin);
        
        globalMin = minDist;
        sol.Path = pop(bestchromosomes(1),:);
        sol.Length=minDist;
        
%         if err<=eps
%             fprintf('   solution converging after: %g iterations\n', iter);
%             break
%         end

    end

    %-- STEP 4: crossover (combine best 2 chromosomes) to make new chromosomes
    p1=pop(bestchromosomes(1), :);
    p2=pop(bestchromosomes(2), :);
    
    %-- Crossover
    [c1, c2]=crossover(p1, p2);
    
    %-- Mutation
    type=1;
    c1=mutation(c1, type);
    c2=mutation(c2, type);
    
    %-- Replace with worst
    pop(worstchromosomes,:) = [c1;c2];
    
end

%--
if iter==maxIter
    fprintf('   maximum no. of iterations reached\n');
end


%--------------------
% run crossover (implement the first variant of order crossover - Ox1)
function [c1, c2]=crossover(p1, p2)

n=length(p1);

% define cross nodes (random selection)
crossnodes = sort(ceil(n*rand(1,2)));

% run crossover (1)
c1=runcrossover(p1, p2, crossnodes(1), crossnodes(2));

% run crossover (2)
c2=runcrossover(p2, p1, crossnodes(1), crossnodes(2));

%--
function c=runcrossover(p1, p2, I, J)

% init output
n=length(p1);
c=zeros(1,n);

% get index
idin=I:J;

if J<n
    l=J+1:n;
else
    l=[];
end
r=1:J;

idout=[l, r];

idfillup=[l, 1:I-1];

% fill-up children
tp1=p1(idin);
tp2=p2(idout); 

c(idin)=tp1;
countf=1;
for i=1:n
    flag=true;
    for j=1:length(tp1)
        if tp2(i)==tp1(j)
            flag=false;
            break
        end
    end
    
    % save it...
    if flag
        if countf>length(idfillup)
            break
        else
            c(idfillup(countf))=tp2(i);
            countf=countf+1;
        end
    end
    
end

%--
function cm=mutation(c, type)

% init output
n=length(c);
cm=c;

% define cross nodes (random selection)
mutationnodes = sort(ceil(n*rand(1,2)));
I=mutationnodes(1);
J=mutationnodes(2);

switch type
    case 1 % Flip
        cm(I:J) = c(J:-1:I);
    case 2 % Swap
        cm([I J]) = c([J I]);
    case 3 % Slide
        cm(I:J) = c([I+1:J I]);
end
    