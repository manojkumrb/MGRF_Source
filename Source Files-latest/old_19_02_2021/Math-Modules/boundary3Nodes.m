% calculate nodes ids for the given selected boundary (3-nodes are given)
function boundEdge=boundary3Nodes(pb, element, nnode)

% pb: ids of the 3 nodes on the boundary
% element: 3-node element connection
% nnode: no. of nodes

% get adjacency matrix
A=element2AdjacentTrias(element, nnode);

% initial seed
actEdge=find(A(pb(2),:)==1);

if ~isempty(actEdge)
    
    if actEdge(1)~=pb(1)
        boundEdge=[pb(2) actEdge(1)]; % take the first one
    elseif actEdge(2)~=pb(1) 
        boundEdge=[pb(2) actEdge(2)]; % take the second one
    else
        error('FEMP: failed to reconstruct boundary!')
    end
    
        % update A matrix
        A(pb(2),actEdge)=0; % already visited
else
    error('FEMP: failed to reconstruct boundary!')
end

%----------
actVertex=boundEdge(2); % this is the actual vertex. The other vertices are linked to this one

% start search 
I=2;
CountVertex=1;
while(CountVertex<=nnode)
    
    actEdge=find(A(actVertex,:)==1); %find next vertex
  
    % update A matrix
    A(actVertex,actEdge)=0;
    
    if actEdge(1)==boundEdge(I-1) % equal to previous
        actVertex=actEdge(2);
    else
        actVertex=actEdge(1);
    end
    
    if actVertex~=pb(3) % grow-up current loop
        
        boundEdge=[boundEdge actVertex];
        
        I=I+1; % update counter of the single loop
        
    else % save boundary
       
        boundEdge(end+1)=pb(3);
        boundEdge(end+1)=pb(1);
        
      break
      
    end
    
    CountVertex=CountVertex+1;
    
end


