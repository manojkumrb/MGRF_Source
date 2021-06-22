%-- release welding guns (TAG = 'GUN')

% Release gungs

function fem=gunReleasing(fem, inData, searchDist)

% fem: fem structure
% inData: data structure
% searchDist: searching distance

% no. of unilateral constraints
nuni=length(fem.Boundary.Constraint.Unilateral);

%%--
% STEP 1: remove guns from the unilateral constraint set

% loop over all gungs (uni. constraints)
idrem=[];
for i=1:nuni
    
    % check if the i-th constraint is a spot gun
    tag=fem.Boundary.Constraint.Unilateral(i).UserExp.Tag;
    
    if strcmp(tag,'GUN') || strcmp(tag,'gun')
                                               
        % update index to be removed
        idrem=[idrem,i];
                 
    end

end

% release guns
fem.Boundary.Constraint.Unilateral(idrem)=[];

%%--
% STEP 2: add rigid link to model spot weld
count=length(fem.Boundary.Constraint.RigidLink)+1;

if ~isempty(inData.Spot)

    n=size(inData.Spot.Pm,1);
    
    for i=1:n
        
         % check if the spot is NOT failed
        if inData.Spot.Fault(i)==1
            fem.Boundary.Constraint.RigidLink(count).Pm=inData.Spot.Pm(i,:);
            fem.Boundary.Constraint.RigidLink(count).Nm=inData.Spot.Nm(i,:);
            fem.Boundary.Constraint.RigidLink(count).SearchDist=searchDist;
            fem.Boundary.Constraint.RigidLink(count).Master=inData.Spot.Master(i);
            fem.Boundary.Constraint.RigidLink(count).Slave=inData.Spot.Slave(i);
            
            fem.Boundary.Constraint.RigidLink(count).Frame='ref';

            count=count+1;
        end
            
    end

end



