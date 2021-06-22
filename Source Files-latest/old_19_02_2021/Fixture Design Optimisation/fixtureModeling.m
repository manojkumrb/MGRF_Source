% Set fixture data
function fem=fixtureModeling(data, fem, geomparaid)

% data: data structure
% geomparaid: parameter id
% fem: updated fem model structure with boundary conditions

%--------
eps=1e-6;
%--------

%--------------------------------------------------------------------------
% initialise counters
fem.Boundary.Constraint.Bilateral.Node=[];
fem.Boundary.Constraint.Bilateral.Element=[];

fem.Boundary.Constraint.RigidLink=[];

fem.Boundary.Constraint.PinHole=[];
fem.Boundary.Constraint.PinSlot=[];

fem.Boundary.Constraint.Unilateral=[];

fem.Boundary.DimplePair=[];
fem.Boundary.ContactPair=[];

% define rigid links
field='Stitch';
f=get_input_fields(data, field);
n=length(f);
count=1;
for i=1:n

    % get field
    fi=f(i);

    if fi.Type{1}==3 % rigid link
        % check status
        [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, 1);

        if flag

            Nm=fi.Pam{1}(geomparaidi,:) - fi.Pas{1}(geomparaidi,:);

            L=norm(Nm);

            if L>=eps
                Nm=Nm/L;

                fem.Boundary.Constraint.RigidLink(count).Pm=fi.Pam{1}(geomparaidi,:); 
                fem.Boundary.Constraint.RigidLink(count).Nm=Nm;
                fem.Boundary.Constraint.RigidLink(count).SearchDist=fi.SearchDist(1);
                fem.Boundary.Constraint.RigidLink(count).Master=fi.Master;
                fem.Boundary.Constraint.RigidLink(count).Slave=fi.Slave;

                fem.Boundary.Constraint.RigidLink(count).Frame='ref';

                count=count+1;
            end

        end
    end
    
end
          

% define rigid or flexible option 
field='Part';
f=get_input_fields(data, field);
n=length(f);
count=1;         
for i=1:n

    if f(i).Status==0

        fg=f(i).FlexStatus;

        if ~fg % rigid mode
            idnode = fem.Domain(i).Node;

            fem.Boundary.Constraint.Bilateral.Node(count).Node=idnode;
            fem.Boundary.Constraint.Bilateral.Node(count).Reference='cartesian';
            fem.Boundary.Constraint.Bilateral.Node(count).DoF=[1 2 3 4 5 6]; % rigid
            fem.Boundary.Constraint.Bilateral.Node(count).Value=[0 0 0 0 0 0];
            fem.Boundary.Constraint.Bilateral.Node(count).Physic='shell';

            count=count+1;
        end
    end
end

%--------------------------------------------------------------------------
% define sub-model constraints
if isfield(data, 'Assembly')
        if data.Assembly.Solver.UseSubModel % use sub-model
            if ~isempty(data.Assembly.SubModel.Node)
                n=length(data.Assembly.SubModel.Node);

                for i=1:n
                    fem.Boundary.Constraint.Bilateral.Node(count).Node=data.Assembly.SubModel.Node(i);
                    fem.Boundary.Constraint.Bilateral.Node(count).Reference='cartesian';
                    fem.Boundary.Constraint.Bilateral.Node(count).DoF=[1 2 3 4 5 6]; 
                    fem.Boundary.Constraint.Bilateral.Node(count).Value=data.Assembly.SubModel.U(i,:);
                    fem.Boundary.Constraint.Bilateral.Node(count).Physic='shell';

                    count=count+1;
                end
            end
        end
end


%--------------------------------------------------------------------------
% define pin-hole settings
field='Hole';
f=get_input_fields(data, field);
n=length(f);

count=1;
for i=1:n

    % get field
    fi=f(i);

    % check status
    [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, 1);

    if flag
        Nh=fi.Nam{1}(geomparaidi,:);
        Rc=vector2Rotation(Nh);
        
        fem.Boundary.Constraint.PinHole(count).Pm=fi.Pam{1}(geomparaidi,:); 
        fem.Boundary.Constraint.PinHole(count).Nm1=Rc(:,1)'; 
        fem.Boundary.Constraint.PinHole(count).Nm2=Rc(:,2)'; 
        fem.Boundary.Constraint.PinHole(count).Domain=fi.Master; 
        fem.Boundary.Constraint.PinHole(count).SearchDist=fi.SearchDist(1); 
        fem.Boundary.Constraint.PinHole(count).Value=[0.0 0.0 0.0 0.0];
        fem.Boundary.Constraint.PinHole(count).UserExp.Tag='';

        count=count+1;
    end

end
    

%--------------------------------------------------------------------------
% define pin-slot settings
field='Slot';
f=get_input_fields(data, field);
n=length(f);

count=1;
for i=1:n

    % get field
    fi=f(i);

    % check status
    [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, 1);

    if flag
        
        % calculate rotation matrix
        Nh=fi.Nam{1}(geomparaidi,:);
        
        angle=fi.Geometry.Shape.Rotation;
        angle=angle*pi/180;
        Rc=RodriguesRot(Nh, angle)*vector2Rotation(Nh);
        
        fem.Boundary.Constraint.PinSlot(count).Pm=fi.Pam{1}(geomparaidi,:); 
        fem.Boundary.Constraint.PinSlot(count).Nm1=Rc(:,1)'; 
        fem.Boundary.Constraint.PinSlot(count).Nm2=Rc(:,2)'; 
        fem.Boundary.Constraint.PinSlot(count).Domain=fi.Master; 
        fem.Boundary.Constraint.PinSlot(count).SearchDist=fi.SearchDist(1); 
        fem.Boundary.Constraint.PinSlot(count).Value=[0 0];
        fem.Boundary.Constraint.PinSlot(count).UserExp.Tag='';

        count=count+1;
    end

end


%--------------------------------------------------------------------------
% define custom constraints    
field='CustomConstraint';
f=get_input_fields(data, field);
n=length(f);

count=1;
for i=1:n

    % get field
    fi=f(i);

    % check status
    [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, 1);

    if flag

        tdofs=fi.DoFs;

        dofs=[];
        values=[];
        for j=1:6
            if tdofs(j)
                dofs=[dofs j];
                values=[values 0];
            end
        end

        fem.Boundary.Constraint.Bilateral.Element(count).Pm=fi.Pam{1}(geomparaidi,:); 
        fem.Boundary.Constraint.Bilateral.Element(count).Reference='cartesian'; 
        fem.Boundary.Constraint.Bilateral.Element(count).SearchDist=fi.SearchDist(1); 
        fem.Boundary.Constraint.Bilateral.Element(count).DoF=dofs;
        fem.Boundary.Constraint.Bilateral.Element(count).Value=values;
        fem.Boundary.Constraint.Bilateral.Element(count).Domain=fi.Master; 
        fem.Boundary.Constraint.Bilateral.Element(count).Physic='shell';

        count=count+1;

    end
            
end 


%--------------------------------------------------------------------------
%--
count=1; % INITIALISE COUNTER FOR UNILATERAL CONSTRAINTS
%--

% define locators: NC-Block
field='NcBlock';
f=get_input_fields(data, field);
n=length(f);
for i=1:n

    % get field
    fi=f(i);

    np=length(fi.Status); % number of points

    for j=1:np

        % check status
        [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, j);

        if flag

            fem.Boundary.Constraint.Unilateral(count).Pm=fi.Pam{j}(geomparaidi,:); 
            fem.Boundary.Constraint.Unilateral(count).SearchDist=fi.SearchDist(1); 
            fem.Boundary.Constraint.Unilateral(count).Nm=fi.Nam{j}(geomparaidi,:); 
            fem.Boundary.Constraint.Unilateral(count).Size=false; 
            fem.Boundary.Constraint.Unilateral(count).Offset=0.0;
            fem.Boundary.Constraint.Unilateral(count).Domain=fi.Master; 
            fem.Boundary.Constraint.Unilateral(count).Constraint='free'; % use free option
            fem.Boundary.Constraint.Unilateral(count).Frame='ref';

            count=count+1;
        end

    end

end



% define locators: ClampS
field='ClampS';
f=get_input_fields(data, field);
n=length(f);
for i=1:n

    % get field
    fi=f(i);

    np=length(fi.Status); % number of points

    for j=1:np

        % check status
        [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, j);
        
        if flag

            fem.Boundary.Constraint.Unilateral(count).Pm=fi.Pam{j}(geomparaidi,:); 
            fem.Boundary.Constraint.Unilateral(count).SearchDist=fi.SearchDist(1); 
            fem.Boundary.Constraint.Unilateral(count).Nm=fi.Nam{j}(geomparaidi,:); 
            fem.Boundary.Constraint.Unilateral(count).Size=false; 
            fem.Boundary.Constraint.Unilateral(count).Offset=0.0;
            fem.Boundary.Constraint.Unilateral(count).Domain=fi.Master; 
            fem.Boundary.Constraint.Unilateral(count).Constraint='lock'; % use lock option
            fem.Boundary.Constraint.Unilateral(count).Frame='ref';

            count=count+1;
        end
    end
    
end


% define locators: ClampM
field='ClampM';
f=get_input_fields(data, field);
n=length(f);
for i=1:n

    % get field
    fi=f(i);

    np=length(fi.Status); % number of points

    for j=1:np

        % check status
        [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, j);

        if flag

                % master
                fem.Boundary.Constraint.Unilateral(count).Pm=fi.Pam{j}(geomparaidi,:); 
                fem.Boundary.Constraint.Unilateral(count).SearchDist=fi.SearchDist(1); 
                fem.Boundary.Constraint.Unilateral(count).Nm=fi.Nam{j}(geomparaidi,:); 
                fem.Boundary.Constraint.Unilateral(count).Size=false; 
                fem.Boundary.Constraint.Unilateral(count).Offset=0.0;
                fem.Boundary.Constraint.Unilateral(count).Domain=fi.Master; 
                fem.Boundary.Constraint.Unilateral(count).Constraint='free'; 
                fem.Boundary.Constraint.Unilateral(count).Frame='ref';

                count=count+1;

                % slave
                fem.Boundary.Constraint.Unilateral(count).Pm=fi.Pas{j}(geomparaidi,:); 
                fem.Boundary.Constraint.Unilateral(count).SearchDist=fi.SearchDist(1); 
                fem.Boundary.Constraint.Unilateral(count).Nm=fi.Nas{j}(geomparaidi,:); 
                fem.Boundary.Constraint.Unilateral(count).Size=false; 
                fem.Boundary.Constraint.Unilateral(count).Offset=0.0;
                fem.Boundary.Constraint.Unilateral(count).Domain=fi.Slave; 
                fem.Boundary.Constraint.Unilateral(count).Constraint='free'; 
                fem.Boundary.Constraint.Unilateral(count).Frame='ref';

                count=count+1;
        end
    end
end



% define dimples
field='Dimple';
f=get_input_fields(data, field);
n=length(f);
    
count=1;
for i=1:n 
    
    % get field
    fi=f(i);

    [flag, geomparaidi]=checkInputStatusGivenPoint(fi, geomparaid, 1);

    if flag

        fem.Boundary.DimplePair(count).Pm=fi.Pam{1}(geomparaidi,:); 
        fem.Boundary.DimplePair(count).Master=fi.Master;
        if fi.MasterFlip
             fem.Boundary.DimplePair(count).MasterFlip=true;
        else
             fem.Boundary.DimplePair(count).MasterFlip=false;
        end
        fem.Boundary.DimplePair(count).Slave=fi.Slave;
        fem.Boundary.DimplePair(count).SearchDist=fi.SearchDist(1);
        fem.Boundary.DimplePair(count).Height=fi.Height;
        fem.Boundary.DimplePair(count).Offset=0.0;
        fem.Boundary.DimplePair(count).Physic='shell'; 
        fem.Boundary.DimplePair(count).Frame='ref';
        
        count=count+1;
    end
end


% define contact pair
field='Contact';
f=get_input_fields(data, field);
n=length(f);  

count=1;
for i=1:n

    fi=f(i);
    
    if fi.Status==0   
        fem.Boundary.ContactPair(count).Master=fi.Master;
        
        if fi.MasterFlip
             fem.Boundary.ContactPair(count).MasterFlip=true;
        else
             fem.Boundary.ContactPair(count).MasterFlip=false;
        end
        
        fem.Boundary.ContactPair(count).Slave=fi.Slave;
        fem.Boundary.ContactPair(count).SearchDist=fi.SearchDist(1);
        fem.Boundary.ContactPair(count).SharpAngle=fi.SearchDist(2); 
        fem.Boundary.ContactPair(count).Offset=fi.Offset;  
        
        if fi.Use  
             fem.Boundary.ContactPair(count).Enable=true;
        else % use it only for post-processing purposes but not for constraint solving
            fem.Boundary.ContactPair(count).Enable=false;
        end
        
        fem.Boundary.ContactPair(count).Sampling=fi.Sampling;
        
        fem.Boundary.ContactPair(count).Physic='shell';
        fem.Boundary.ContactPair(count).Frame='ref';

        count=count+1;
    end
end

