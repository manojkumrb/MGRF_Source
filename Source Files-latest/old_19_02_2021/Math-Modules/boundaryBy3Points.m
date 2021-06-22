% calculate boundary loop for given 3 points
function [boundPoints, flag]=boundaryBy3Points(fem, pfreeedge, sdist)

% pfreeedge: xyz of the 3 points on (or close) to the free edge 
    % P1: start point (xyz)
    % P2: ending point (xyz)
    % P3: via point(xyz)
% sdist: searching distance
    
% fem: fem model

% boundPoints: boundary points' IDs

%--
flag=true;
boundPoints=[];

% get adjacency matrix
fprintf('    FEMP Boundary - calculating connections...\n')
A=element2Adjacent(fem, 'free edge');

% get ids of free edge nodes
freeedges=lncGetFreeEdges(A);
if isempty(freeedges)
    flag=false;
    return
end

%--
pb=xyz2Id(fem, pfreeedge, freeedges, sdist);

% initial seed
actEdge=find(A(pb(1),:)==1);

if isempty(actEdge)
    flag=false;
    return
end

nloops=length(actEdge); % no. of detected boundaries

% run over loops
for k=1:nloops
     tboundPoints=[pb(1) actEdge(k)]; 
     [tboundPoints, A]=lclSearch(pb, A, tboundPoints);
     
     % check the edge is close to the third point, "pfreeedge(3,:)"
     [~, flag]=xyz2Id(fem, pfreeedge(3,:), tboundPoints, sdist);
     
     if flag
         boundPoints=tboundPoints;
         break
     end

end


%---------------------------------------
% run local search
function [boundEdge, A]=lclSearch(pb, A, boundEdge)

%----------
actVertex=boundEdge(2); % this is the actual vertex. The other vertices are linked to this one

nnode=size(A,1);

% start search 
I=2;
CountVertex=1;
while(CountVertex<=nnode)
    
    actEdge=find(A(actVertex,:)==1); %find next vertex
    
    if isempty(actEdge)
        break
    end
  
    % update A matrix
    A(actVertex,actEdge)=0;
    
    if actEdge(1)==boundEdge(I-1) % equal to previous
        actVertex=actEdge(2);
    else
        actVertex=actEdge(1);
    end
    
    if actVertex~=pb(2) % grow-up current loop
        
        boundEdge=[boundEdge actVertex];
        
        I=I+1; % update counter of the single loop
        
    else % save boundary and exit
       
      boundEdge=[boundEdge pb(2)]; 
      break
      
    end
    
    CountVertex=CountVertex+1;
    
end


% retrieve node ids from coordinates (x y z) - closest to boundary nodes (free edges)
function [id, flag]=xyz2Id(fem, p, bnode, sdist)

% sdist: searching distance

flag=true;

Bnode=fem.xMesh.Node.Coordinate(bnode, :);

nnode=size(Bnode,1);

np=size(p,1);

d=zeros(nnode,3);
id=zeros(np,1);
for i=1:np
    d(:,1)=Bnode(:,1)-p(i,1);
    d(:,2)=Bnode(:,2)-p(i,2);
    d(:,3)=Bnode(:,3)-p(i,3);

    d=sqrt(sum(d.^2, 2));

    [dmin, idi]=min(d);
    if dmin<=sdist % check distance
        id(i)=bnode(idi);
    else
        flag=false;
        break
    end
end


% get ids of boundary nodes
function bnode=lncGetFreeEdges(A)

% INPUT
% A: laplace matrix

% OUTPUT
% bnode: list of boundary nodes ids

% loop over all nodes
[bnode, ~]=find(A==1);

% remove duplicates
bnode=unique(bnode);












% 
% % initial seed
% actEdge=find(A(pb(2),:)==1);
% 
% if ~isempty(actEdge)
%     
%     if actEdge(1)~=pb(1)
%         boundEdge=[pb(2) actEdge(1)]; % take the first one
%     elseif actEdge(2)~=pb(1) 
%         boundEdge=[pb(2) actEdge(2)]; % take the second one
%     else
%         error('FEMP: failed to reconstruct boundary!')
%     end
%     
%         % update A matrix
%         A(pb(2),actEdge)=0; % already visited
% else
%     error('FEMP: failed to reconstruct boundary!')
% end
% 
% %----------
% actVertex=boundEdge(2); % this is the actual vertex. The other vertices are linked to this one
% 
% % start search 
% I=2;
% CountVertex=1;
% while(CountVertex<=nnode)
%     
%     actEdge=find(A(actVertex,:)==1); %find next vertex
%   
%     % update A matrix
%     A(actVertex,actEdge)=0;
%     
%     if actEdge(1)==boundEdge(I-1) % equal to previous
%         actVertex=actEdge(2);
%     else
%         actVertex=actEdge(1);
%     end
%     
%     if actVertex~=pb(3) % grow-up current loop
%         
%         boundEdge=[boundEdge actVertex];
%         
%         I=I+1; % update counter of the single loop
%         
%     else % save boundary
%        
%         boundEdge(end+1)=pb(3);
%         boundEdge(end+1)=pb(1);
%         
%       break
%       
%     end
%     
%     CountVertex=CountVertex+1;
%     
% end
