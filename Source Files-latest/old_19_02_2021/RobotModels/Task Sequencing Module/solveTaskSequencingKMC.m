% solve task sequence problem using "multi-level hierarchical decomposition"
function [taskSequenceData, KMC]=solveTaskSequencingKMC(KMC, WeightData, StationData, HierarchyData)

% Input:
% KMC: KMC structure

% WeightData.
    % Distance
    % Collision
    % Coverage
    % ...

% StationData.
    % Robot
    % Workpiece

% HierarchyData
    % Top: "distance", "collision", "coverage"
    % Bottom: "distance", "collision", "coverage"
    
% Output:
% Ptask=[n, 3] best point within the KMC volume
% taskSequenceData:
    % .Tsp
        % Sequence: optimum sequence
        % Length: length of optimum sequence
        % Convergency.History: solution history
        % Convergency.Iter: convergency iter
    % Point: (xyz) of tasks
    % Status: true/false
    % KMCids: ids of feasible KMCs

fprintf('Solve task sequencing problem...\n');
    
nKmc=length(KMC); 

% init output
taskSequenceData.Tsp=initTSPSolver();
taskSequenceData.Point=[];
taskSequenceData.Status=false;
taskSequenceData.KMCids=[];

% STEP 1: calculate best point within the KMC envelop
c=0;
for i=1:nKmc

    soli=selectBestPointKMC(KMC, i, WeightData, StationData, HierarchyData);
    
    %--
    fprintf('       Summary for KMC[%g]\n', i);
    fprintf('           %s: %g\n',  HierarchyData.Top, soli.Objective);
    for j=1:length(soli.Constraint)
        fprintf('           %s: %g\n',  HierarchyData.Bottom{i}, soli.Constraint(i));
    end
    
    if soli.Status % converged solution
        c=c+1;
        taskSequenceData.Point(c,:)=soli.Point;
        
        taskSequenceData.KMCids(c)=i;
    end
    
end


% STEP 2: solve TSP problem 
if c>0 % STEP 2: calculate best sequence solving the TSP problem
    
    KMC=KMC(taskSequenceData.KMCids); % keep only the feasible KMCs
    
    fprintf('       No. of feasible KMCs: %g\n', c);
    
    d=zeros(c);
    for i=1:c
        Pi=taskSequenceData.Point(i,:);
        for j=i+1:c
            Pj=taskSequenceData.Point(j,:);

            d(i,j)=norm(Pi-Pj);
            d(j,i)=norm(Pi-Pj);
        end
    end

    % solve TSP
    taskSequenceData.Tsp.D=d; % define the distance matrix
    taskSequenceData.Tsp=solveTSP_only_sequence(taskSequenceData.Tsp);
    
    taskSequenceData.Status=true;
    
    taskSequenceData.Point=taskSequenceData.Point(taskSequenceData.Tsp.Sequence,:);
    KMC=KMC(taskSequenceData.Tsp.Sequence);

else
    
    fprintf('       Error: no feasible KMC. Please revise the input definition\n');
    
end


