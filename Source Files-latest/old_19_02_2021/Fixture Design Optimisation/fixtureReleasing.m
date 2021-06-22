%-- release fixture (TAG = 'RELEASE')

% Release fixtures

function fem=fixtureReleasing(fem)

%-------------------------------------
% bilateral constraints at node side
%-------------------------------------

ncnode=length(fem.Boundary.Constraint.Bilateral.Node);

% loop over
idrem=[];
for i=1:ncnode
    
    % check if the i-th constraint can be realeased
    tag=fem.Boundary.Constraint.Bilateral.Node(i).UserExp.Tag;
    
    if strcmp(tag,'RELEASE') || strcmp(tag,'release')
         
         % save ids to be removed
         idrem=[idrem,i];
         
    end
    
end

% remove constraints
fem.Boundary.Constraint.Bilateral.Node(idrem)=[];

%-------------------------------------
% bilateral constraints at element side
%-------------------------------------
         
ncele=length(fem.Boundary.Constraint.Bilateral.Element);

% loop over
idrem=[];
for i=1:ncele
    
    % check if the i-th constraint can be realeased
    tag=fem.Boundary.Constraint.Bilateral.Element(i).UserExp.Tag;   
             
    if strcmp(tag,'RELEASE') || strcmp(tag,'release')   
        
        % save ids to be removed
        idrem=[idrem,i];
    
    end
    
end

% remove constraints
fem.Boundary.Constraint.Bilateral.Element(idrem)=[];

%-------------------------------------
% pin-hole
%-------------------------------------

nph=length(fem.Boundary.Constraint.PinHole);

% loop over
idrem=[];
for i=1:nph
    
    % check if the i-th constraint can be realeased
    tag=fem.Boundary.Constraint.PinHole(i).UserExp.Tag;   
             
    if strcmp(tag,'RELEASE') || strcmp(tag,'release')   
        
        % save ids to be removed
        idrem=[idrem,i];
    
    end
    
end

% remove constraints
fem.Boundary.Constraint.PinHole(idrem)=[];


%-------------------------------------
% pin-slot
%-------------------------------------

nph=length(fem.Boundary.Constraint.PinSlot);

% loop over
idrem=[];
for i=1:nph
    
    % check if the i-th constraint can be realeased
    tag=fem.Boundary.Constraint.PinSlot(i).UserExp.Tag;   
             
    if strcmp(tag,'RELEASE') || strcmp(tag,'release')   
        
        % save ids to be removed
        idrem=[idrem,i];
    
    end
    
end

% remove constraints
fem.Boundary.Constraint.PinSlot(idrem)=[];


%-------------------------------------
% unilateral constraints at element side
%-------------------------------------

nuni=length(fem.Boundary.Constraint.Unilateral);

% loop over all gungs
idrem=[];
for i=1:nuni
    
    % check if the i-th constraint is a spot gun
    tag=fem.Boundary.Constraint.Unilateral(i).UserExp.Tag;
    
    if strcmp(tag,'RELEASE') || strcmp(tag,'release')  
                        
        % update index to be removed
        idrem=[idrem,i];
        
    end
    
end

% remove constraints
fem.Boundary.Constraint.Unilateral(idrem)=[];


