% read input data from filename
function inData=readInputsExl(filename, rowmax)

% define local variables
%------------------------
eps=1e-6;
%------------------------

% INPUT:
% filename: excel input file
% rowmax: max. no. of rows to read

% OUTPUT:
% inData: data structure

inData.Assembly=[]; % assembly details
% inData.Assembly.A=[]; % no. of rows/columns is equal to no. of stations
% inData.Assembly.Graphic=[];
% inData.Assembly.Station(1).Name=[];
% inData.Assembly.Station(1).Part=[];
% inData.Assembly.Station(1).Stitch.Id=[]; % ids
% inData.Assembly.Station(1).Stitch.ParaId=[]; % parameter id to be used for next operations

%------------------------
%------------------------
%-- SHEET 1
inData.Part=[]; % part details
% inData.Part(1).Name=[];
% inData.Part(1).Enable=[];
% inData.Part(1).E=[];
% inData.Part(1).nu=[];
% inData.Part(1).Th=[];
% inData.Part(1).FlexStatus=[];
% inData.Part(1).CoP=[];
% inData.Part(1).Mesh=[];
% inData.Part(1).Offset=[];

% inData.Part(1).SearchDist=[];

% inData.Part(1).Graphic.Color='g';
% inData.Part(1).Graphic.EdgeColor='k';
% inData.Part(1).Graphic.ShowPatch=true;
% inData.Part(1).Graphic.ShowEdge=true;


% read part info
fprintf('Reading EXCEL database: part...\n')

rc=sprintf('A3:AZ%g',rowmax);
[data, txt] = xlsread(filename,1,rc); % read numeric data and text

count=1;
cna=0;
for i=1:size(data,1)
    
    inData.Part(count).Name=txt{i,1};
    
    t=data(i,1);
    
    if t==0
        cna=cna+1;
        inData.Part(count).Enable=false;
    else
        inData.Part(count).Enable=true;
    end
        
    inData.Part(count).E=data(i,2);
    inData.Part(count).nu=data(i,3);
    inData.Part(count).Th=data(i,4);

    inData.Part(count).Offset=data(i,5);

    t=data(i,6);
    
    if t==0
        inData.Part(count).FlexStatus=false;
    else
        inData.Part(count).FlexStatus=true;
    end
        
    % mesh file
    if data(i,7)==1
        inData.Part(count).Mesh=txt{i,2};
    else
        inData.Part(count).Mesh='';
    end

    % CoP
    if data(i,8)==1
        inData.Part(count).CoP=txt{i,3};
    else
        inData.Part(count).CoP='';
    end
        
    % set default
    inData.Part(count).Graphic.Color='g';
    inData.Part(count).Graphic.EdgeColor='k';
    inData.Part(count).Graphic.ShowPatch=true;
    inData.Part(count).Graphic.ShowEdge=true;
    
    inData.Part(count).SearchDist=5.0;

    count=count+1;
end


fprintf('       no. of not-active part %g\n', cna)
fprintf('       no. of part: %g\n', count-1)


%-- SHEET 2
inData.Stitch=[]; % stitch data
% inData.Stitch(1).Name=[];
% inData.Stitch(1).Enable=[];
% inData.Stitch(1).Type=[];
% inData.Stitch(1).Ps=[];
% inData.Stitch(1).Pe=[];
% inData.Stitch(1).Master=[];
% inData.Stitch(1).Slave=[];
% inData.Stitch(1).Diameter=[];
% inData.Stitch(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"
% inData.Stitch(1).Parametrisation.Geometry.Nt=[];
% inData.Stitch(1).Parametrisation.Geometry.T=[];
% inData.Stitch(1).Parametrisation.Geometry.V=[];
% inData.Stitch(1).Parametrisation.Geometry.N=[];
% inData.Stitch(1).Parametrisation.DoF=[]; 

%--
% inData.Stitch(1).Ns=[];
% inData.Stitch(1).Ne=[];

%--
% inData.Stitch(1).Graphic.Color='g';
% inData.Stitch(1).Graphic.Width=1;
% inData.Stitch(1).Graphic.Marker='o';

% inData.Stitch(1).Constraint.Ds=[]; % distance from starting point
% inData.Stitch(1).Constraint.De=[]; % distance from ending point
% inData.Stitch(1).Constraint.Dc=[]; % cylindrical zone

% inData.Stitch(1).SearchDist=[]; 

% inData.Stitch(1).Status=[]; 

%--------------------
% read stitch
fprintf('Reading EXCEL database: stitches...\n')

rc=sprintf('A4:AZ%g',rowmax);
[data,txt] = xlsread(filename,2,rc);

count=1;
cl=0;
cc=0;
cna=0;
for i=1:size(data,1)
    
    inData.Stitch(count).Name=txt{i};
    
    if data(i,1)==0 % not active
        cna=cna+1;
        inData.Stitch(count).Enable=false;
    else
        inData.Stitch(count).Enable=true;
    end
        
    t=data(i,2);
    
    if t==1 % linear
        cl=cl+1;
    elseif t==2 % circular
        cc=cc+1;
    end
    
    inData.Stitch(count).Type=t;
    
    ps=data(i,3);
    if ps==0
        inData.Stitch(count).Parametrisation.Geometry.Type{1}='ref';
    else
        inData.Stitch(count).Parametrisation.Geometry.Type{1}='TV';
    end
    
    pe=data(i,4);
    if pe==0
        inData.Stitch(count).Parametrisation.Geometry.Type{2}='ref';
    else
        inData.Stitch(count).Parametrisation.Geometry.Type{2}='TV';
    end
     
    inData.Stitch(count).Master=data(i,5);
    inData.Stitch(count).Slave=data(i,6);
    
    Ps=data(i,7:9);
    inData.Stitch(count).Pm(1,:)=Ps; 
    
    % get normal vector
    l=norm(data(i,19:21));

    if l<=eps
        warning('FEMP (reading excel input): stitch - Vector cannot be zero');
        inData.Stitch(count).Nm(1,:)=data(i,19:21);
    else
        inData.Stitch(count).Nm(1,:)=data(i,19:21)/l;
    end
            
    if ps>0
        % Nt
        P2=data(i,13:15);

        l=norm(P2-Ps);

        if l<=eps
            warning('FEMP (reading excel input): stitch - Vector cannot be zero');
            inData.Stitch(count).Parametrisation.Geometry.Nt{1}=P2-Ps;
        else
            inData.Stitch(count).Parametrisation.Geometry.Nt{1}=(P2-Ps)/l;
        end
    else
        inData.Stitch(count).Parametrisation.Geometry.Nt{1}=[];
    end
    
    inData.Stitch(count).Parametrisation.Geometry.T{1}=0;
    inData.Stitch(count).Parametrisation.Geometry.V{1}=0;
    inData.Stitch(count).Parametrisation.Geometry.N{1}=0;

    inData.Stitch(count).Parametrisation.Geometry.R{1}=eye(3,3);
    
    Pe=data(i,10:12);
    inData.Stitch(count).Pm(2,:)=Pe;

    if pe>0
        % Nt
        P2=data(i,16:18);

        l=norm(P2-Pe);

        if l<=eps
            warning('FEMP (reading excel input): stitch - Vector cannot be zero');
            inData.Stitch(count).Parametrisation.Geometry.Nt{2}=P2-Pe;
        else
            inData.Stitch(count).Parametrisation.Geometry.Nt{2}=(P2-Pe)/l;
        end
    else
        inData.Stitch(count).Parametrisation.Geometry.Nt{2}=[];
    end
    

    inData.Stitch(count).Parametrisation.Geometry.T{2}=0;
    inData.Stitch(count).Parametrisation.Geometry.V{2}=0;
    inData.Stitch(count).Parametrisation.Geometry.N{2}=0;
    
    inData.Stitch(count).Parametrisation.Geometry.R{2}=eye(3,3);
    
    % set default
    inData.Stitch(count).Diameter=8.0;

    inData.Stitch(count).Graphic.Color='g';
    inData.Stitch(count).Graphic.Width=1;
    inData.Stitch(count).Graphic.Marker='o';

    inData.Stitch(count).Constraint.Ds=1; % distance from starting point
    inData.Stitch(count).Constraint.De=1; % distance from ending point
    inData.Stitch(count).Constraint.Dc=1; % cylindrical zone
    
    inData.Stitch(count).Parametrisation.DoF{1}=[];
    inData.Stitch(count).Parametrisation.DoF{2}=[];
    
    inData.Stitch(count).SearchDist=5.0; 
    
    inData.Stitch(count).Pam=[]; 
    inData.Stitch(count).Pas=[]; 
        
    inData.Stitch(count).Nam=[]; 
    inData.Stitch(count).Nas=[]; 
        
    inData.Stitch(count).NormalType='model'; 
    
    inData.Stitch(count).Status{1}=-1; 

    count=count+1;           
end

fprintf('       no. of linear stitches: %g\n', cl)
fprintf('       no. of circular stitches: %g\n', cc)
fprintf('       no. of not-active stitches: %g\n', cna)
fprintf('       no. of stitches: %g\n', count-1)


%-- SHEET 3
inData.Dimple=[]; % dimple data
% inData.Dimple(1).Name=[];
% inData.Dimple(1).Enable=[];
% inData.Dimple(1).Ps=[];
% inData.Dimple(1).Master=[];
% inData.Dimple(1).Slave=[];
% inData.Dimple(1).Height=[];
% inData.Dimple(1).Offset=[];
% inData.Dimple(1).Stiffness=[];          
% inData.Dimple(1).Masterflip=[];  
% inData.Dimple(1).Length=[];

%--
% inData.Dimple(1).Pe=[];
% inData.Dimple(1).Ns=[];
% inData.Dimple(1).Ne=[];
% inData.Dimple(1).StitchId=[];

%--
% inData.Dimple(1).Graphic.Color='g';
% inData.Dimple(1).Graphic.Marker='o';

% inData.Dimple(1).Constraint.Ds=[]; % distance from starting point
% inData.Dimple(1).Constraint.De=[]; % distance from ending point
% inData.Dimple(1).Constraint.Dc=[]; % cylindrical zone

% inData.Dimple(1).SearchDist=[];

% inData.Dimple(1).Status=[];

fprintf('Reading EXCEL database: dimples...\n')

rc=sprintf('A4:AZ%g',rowmax);
[data,txt] = xlsread(filename,3,rc);

count=1;
cna=0;
for i=1:size(data,1)
    
    inData.Dimple(count).Name=txt{i};
    
    t=data(i,1);
    
    if t==0 % not active
        cna=cna+1;
        inData.Dimple(count).Enable=false;
    else
        inData.Dimple(count).Enable=true;
    end
    
    inData.Dimple(count).Master=data(i,2);
    inData.Dimple(count).Slave=data(i,3);
        
    inData.Dimple(count).Ps=data(i,4:6);

    inData.Dimple(count).Height=data(i,7);
    inData.Dimple(count).Stiffness=data(i,8);
    inData.Dimple(count).Offset=data(i,9);

    if data(i,10)==0
        inData.Dimple(count).Masterflip=false;
    else
        inData.Dimple(count).Masterflip=true;
    end

    inData.Dimple(count).Length=data(i,11);
    
    % set defualt
    inData.Dimple(count).Pe=[];
    inData.Dimple(count).Ns=[];
    inData.Dimple(count).Ne=[];
    inData.Dimple(count).StitchId=0;

    inData.Dimple(count).Graphic.Color='g';
    inData.Dimple(count).Graphic.Marker='o';

    inData.Dimple(count).Constraint.Ds=1; % distance from starting point
    inData.Dimple(count).Constraint.De=1; % distance from ending point
    inData.Dimple(count).Constraint.Dc=1; % cylindrical zone

    inData.Dimple(count).SearchDist=5.0;
    
    inData.Dimple(count).Status{1}=-1;

    count=count+1;
 
end

fprintf('       no. of not-active dimples: %g\n', cna)
fprintf('       no. of dimples: %g\n', count-1)


%-- SHEET 4
inData.PinLayout.Hole=[]; % pin-hole data
% inData.PinLayout.Hole(1).Name=[];
% inData.PinLayout.Hole(1).Enable=[];
% inData.PinLayout.Hole(1).Domain=[];
% inData.PinLayout.Hole(1).Pm=[];
% inData.PinLayout.Hole(1).Nm1=[];
% inData.PinLayout.Hole(1).Nm2=[];
% inData.PinLayout.Hole(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"
% inData.PinLayout.Hole(1).Parametrisation.Geometry.Nt=[];
% inData.PinLayout.Hole(1).Parametrisation.Geometry.T=[];
% inData.PinLayout.Hole(1).Parametrisation.Geometry.V=[];
% inData.PinLayout.Hole(1).Parametrisation.Geometry.N=[];

% inData.PinLayout.Hole(1).Parametrisation.DoF=[];

%--
% inData.PinLayout.Hole(1).Graphic.Color='g';

% inData.PinLayout.Hole(1).Constraint.Ds=1; % distance from starting point
% inData.PinLayout.Hole(1).Constraint.De=1; % distance from ending point
% inData.PinLayout.Hole(1).Constraint.Dc=1; % cylindrical zone
    
% inData.PinLayout.Hole(1).SearchDist=[];

% inData.PinLayout.Hole(1).Status=[];

inData.PinLayout.Slot=[]; % pin-slot data
% inData.PinLayout.Slot(1).Name=[];
% inData.PinLayout.Slot(1).Enable=[];
% inData.PinLayout.Slot(1).Domain=[];
% inData.PinLayout.Slot(1).Pm=[];
% inData.PinLayout.Slot(1).Nm1=[];
% inData.PinLayout.Slot(1).Nm2=[];
% inData.PinLayout.Slot(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"
% inData.PinLayout.Slot(1).Parametrisation.Geometry.Nt=[];
% inData.PinLayout.Slot(1).Parametrisation.Geometry.T=[];
% inData.PinLayout.Slot(1).Parametrisation.Geometry.V=[];
% inData.PinLayout.Slot(1).Parametrisation.Geometry.N=[];

% inData.PinLayout.Slot(1).Parametrisation.DoF=[];

%--
% inData.PinLayout.Slot(1).Graphic.Color='g';

% inData.PinLayout.Slot(1).Constraint.Ds=1; % distance from starting point
% inData.PinLayout.Slot(1).Constraint.De=1; % distance from ending point
% inData.PinLayout.Slot(1).Constraint.Dc=1; % cylindrical zone

% inData.PinLayout.Slot(1).SearchDist=[];

% inData.PinLayout.Slot(1).Status=[];

fprintf('Reading EXCEL database: pin and slot...\n')

rc=sprintf('A4:AZ%g',rowmax);
[data,txt] = xlsread(filename,4,rc);

counth=0;
counts=0;
cnah=0;
cnas=0;
for i=1:size(data,1)
        
    t=data(i,2);

    if t==1 % pin hole

        if data(i,1)==0
           cnah=cnah+1; 
        end

        inData=setFieldPinSlot(inData, 'Hole', data, txt, i, eps);

        counth=counth+1;

    elseif t==2 % pin-slot 

        if data(i,1)==0
           cnas=cnas+1; 
        end

        inData=setFieldPinSlot(inData, 'Slot', data, txt, i, eps);

        counts=counts+1;

    end
        
end

    
fprintf('       no. of not-active pin-hole: %g\n', cnah)
fprintf('       no. of pin-hole: %g\n', counth)

fprintf('       no. of not-active pin-slot: %g\n', cnas)
fprintf('       no. of pin-slot: %g\n', counts)


%-- SHEET 5
inData.CustomConstraint=[]; % custom constraint
% inData.CustomConstraint(1).Name=[];
% inData.CustomConstraint(1).Enable=[];
% inData.CustomConstraint(1).Domain=[];
% inData.CustomConstraint(1).Pm=[];
% inData.CustomConstraint(1).DoFs=[];

% inData.CustomConstraint(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"
% inData.CustomConstraint(1).Parametrisation.Geometry.Nt=[];
% inData.CustomConstraint(1).Parametrisation.Geometry.T=[];
% inData.CustomConstraint(1).Parametrisation.Geometry.V=[];
% inData.CustomConstraint(1).Parametrisation.Geometry.N=[];

% inData.CustomConstraint(1).Parametrisation.DoF=[];

% inData.CustomConstraint(1).SearchDist=[];

% inData.CustomConstraint(1).Status=[];


% read custom constraints
fprintf('Reading EXCEL database: custom constraint...\n')

rc=sprintf('A4:AZ%g',rowmax);
[data, txt] = xlsread(filename,5,rc);

count=1;
cna=0;
for i=1:size(data,1)
       
    inData.CustomConstraint(count).Name=txt{i};
    
    t=data(i,1);
    if t==0
        cna=cna+1;
        inData.CustomConstraint(count).Enable=false;
    else
        inData.CustomConstraint(count).Enable=true;
    end
    
    para=data(i,2);
    if para==0
        inData.CustomConstraint(count).Parametrisation.Geometry.Type{1}='ref';
    else
        inData.CustomConstraint(count).Parametrisation.Geometry.Type{1}='TV';
    end

    inData.CustomConstraint(count).Master=data(i,3);

    Pm=data(i,4:6);
    inData.CustomConstraint(count).Pm=Pm;

    inData.CustomConstraint(count).DoFs=data(i,7:12);

    if para>0
        % Nt
        P2=data(i,13:15);

        l=norm(P2-Pm);

        if l<=eps
            warning('FEMP (reading excel input): custom constraint - Vector cannot be zero');
            inData.CustomConstraint(count).Parametrisation.Geometry.Nt{1}=P2-Pm;
        else
            inData.CustomConstraint(count).Parametrisation.Geometry.Nt{1}=(P2-Pm)/l;
        end
    else
        inData.CustomConstraint(count).Parametrisation.Geometry.Nt{1}=[];
    end

    inData.CustomConstraint(count).Parametrisation.Geometry.T{1}=0;
    inData.CustomConstraint(count).Parametrisation.Geometry.V{1}=0;
    inData.CustomConstraint(count).Parametrisation.Geometry.N{1}=0;

    inData.CustomConstraint(count).Parametrisation.Geometry.R{1}=eye(3,3);
    
    inData.CustomConstraint(count).Parametrisation.DoF{1}=[0 0 0 0 0 0];

    % set defualt
    inData.CustomConstraint(count).SearchDist=5.0;
    
    inData.CustomConstraint(count).Pam=[];
    inData.CustomConstraint(count).Pas=[];
        
    inData.CustomConstraint(count).Graphic.Color='g';
    
    inData.CustomConstraint(count).Status{1}=-1;
    
    count=count+1;
        
end

fprintf('       no. of not-active custom constraint: %g\n', cna)
fprintf('       no. of custom constraint: %g\n', count-1)

%-- SHEET 6
inData.Locator.NcBlock=[]; % NC-block data
% inData.Locator.NcBlock(1).Name=[];
% inData.Locator.NcBlock(1).Enable=[];
% inData.Locator.NcBlock(1).Pm=[];
% inData.Locator.NcBlock(1).Pam=[];
% inData.Locator.NcBlock(1).Pas=[];
% inData.Locator.NcBlock(1).Nm=[];
% inData.Locator.NcBlock(1).Geometry.Type=[]; % "point"; "sgeom" (simplified geometry); "rgeom" (real geometry) 
% inData.Locator.NcBlock(1).Geometry.Size.A=[];
% inData.Locator.NcBlock(1).Geometry.Size.B=[];
% inData.Locator.NcBlock(1).Geometry.Face=[];
% inData.Locator.NcBlock(1).Geometry.Vertex=[];
% inData.Locator.NcBlock(1).Slave=[];
% inData.Locator.NcBlock(1).Master=[];
% inData.Locator.NcBlock(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"; "TVN"
% inData.Locator.NcBlock(1).Parametrisation.Geometry.Nt=[];
% inData.Locator.NcBlock(1).Parametrisation.Geometry.T=[];
% inData.Locator.NcBlock(1).Parametrisation.Geometry.V=[];
% inData.Locator.NcBlock(1).Parametrisation.Geometry.N=[];

% inData.Locator.NcBlock(1).Parametrisation.DoF=[];

%--
% inData.Locator.NcBlock(1).Graphic.Color='g';

% inData.Locator.NcBlock(1).Status=[];

inData.Locator.ClampS=[]; % referance clamp on single part
% inData.Locator.ClampS(1).Name=[];
% inData.Locator.ClampS(1).Enable=[];
% inData.Locator.ClampS(1).Pm=[];
% inData.Locator.ClampS(1).Pam=[];
% inData.Locator.ClampS(1).Pas=[];
% inData.Locator.ClampS(1).Nm=[];
% inData.Locator.ClampS(1).Geometry.Type=[]; % "point"; "sgeom" (simplified geometry); "rgeom" (real geometry) 
% inData.Locator.ClampS(1).Geometry.Size.A=[];
% inData.Locator.ClampS(1).Geometry.Size.B=[];
% inData.Locator.ClampS(1).Geometry.Face=[];
% inData.Locator.ClampS(1).Geometry.Vertex=[];
% inData.Locator.ClampS(1).Slave=[];
% inData.Locator.ClampS(1).Master=[];
% inData.Locator.ClampS(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"; "TVN"
% inData.Locator.ClampS(1).Parametrisation.Geometry.Nt=[];
% inData.Locator.ClampS(1).Parametrisation.Geometry.T=[];
% inData.Locator.ClampS(1).Parametrisation.Geometry.V=[];
% inData.Locator.ClampS(1).Parametrisation.Geometry.N=[];

% inData.Locator.ClampS(1).Parametrisation.DoF=[];

%--
% inData.Locator.ClampS(1).Graphic.Color='g';

% inData.Locator.ClampS(1).Status=[];

inData.Locator.ClampM=[]; % reference clamp on multiple part
% inData.Locator.ClampM(1).Name=[];
% inData.Locator.ClampM(1).Enable=[];
% inData.Locator.ClampM(1).Pm=[];
% inData.Locator.ClampM(1).Pam=[];
% inData.Locator.ClampM(1).Pas=[];
% inData.Locator.ClampM(1).Nm=[];
% inData.Locator.ClampM(1).Geometry.Type=[]; % "point"; "sgeom" (simplified geometry); "rgeom" (real geometry) 
% inData.Locator.ClampM(1).Geometry.Size
% inData.Locator.ClampM(1).Geometry.Face=[];
% inData.Locator.ClampM(1).Geometry.Vertex=[];
% inData.Locator.ClampM(1).Slave=[];
% inData.Locator.ClampM(1).Master=[];
% inData.Locator.ClampM(1).Parametrisation.Geometry.Type=[]; % "ref"; "TV"; "TVN"
% inData.Locator.ClampM(1).Parametrisation.Geometry.Nt=[];
% inData.Locator.ClampM(1).Parametrisation.Geometry.T=[];
% inData.Locator.ClampM(1).Parametrisation.Geometry.V=[];
% inData.Locator.ClampM(1).Parametrisation.Geometry.N=[];

% inData.Locator.ClampM(1).Parametrisation.DoF=[];

%--
% inData.Locator.ClampM(1).Graphic.Color='g';

% inData.Locator.ClampM(1).Status=[];


% read reference clamps
fprintf('Reading EXCEL database: locator...\n')

rc=sprintf('A4:AZ%g',rowmax);
[data, txt] = xlsread(filename,6,rc);

countcs=0;
countcm=0;
countnk=0;

cnacs=0;
cnacm=0;
cnank=0;
for i=1:size(data,1)
       
    st=data(i,1); % status
    t=data(i,2); % type
    
    if t==1 % single part clamp
        
        if st==0
            cnacs=cnacs+1;
        end
        
        inData=setFieldLocator(inData, 'ClampS', data, txt, i, eps);
        
        countcs=countcs+1;
        
    elseif t==2 % multiple part clamp
        
        if st==0
            cnacm=cnacm+1;
        end
        
        inData=setFieldLocator(inData, 'ClampM', data, txt, i, eps);
        
        countcm=countcm+1;
        
    elseif t==3 % NC-block
        
        if st==0
            cnank=cnank+1;
        end
        
        inData=setFieldLocator(inData, 'NcBlock', data, txt, i, eps);
        
        countnk=countnk+1;
               
    end
    
end

fprintf('       no. of not-active single part clamp: %g\n', cnacs)
fprintf('       no. of single part clamp: %g\n', countcs)

fprintf('       no. of not-active multiple part clamp: %g\n', cnacm)
fprintf('       no. of multiple part clamp: %g\n', countcm)

fprintf('       no. of not-active NC-block: %g\n', cnank)
fprintf('       no. of NC-block: %g\n', countnk)
    

%-- SHEET 7
inData.Contact=[]; % contact pairs
% inData.Contact(1).Name=[];
% inData.Contact(1).Enable=[];
% inData.Contact(1).Master=[];
% inData.Contact(1).Slave=[];
% inData.Contact(1).Masterflip=[];
% inData.Contact(1).Offset=[];

%--
% inData.Contact(1).Graphic.MasterColor='g';
% inData.Contact(1).Graphic.SlaveColor='b';

% inData.Contact(1).Status=false;


fprintf('Reading EXCEL database: contact pair...\n')

rc=sprintf('A3:AZ%g',rowmax);
[data, txt] = xlsread(filename,7,rc);

count=1;
cna=0;
for i=1:size(data,1)
    
    inData.Contact(count).Name=txt{i};
    
    t=data(i,1);
    
    if t==0
        cna=cna+1;
        inData.Contact(count).Enable=false;
    else
        inData.Contact(count).Enable=true; 
    end
    
    inData.Contact(count).Master=data(i,2);
    inData.Contact(count).Slave=data(i,3);
        
    if data(i,4)==1
        inData.Contact(count).Masterflip=true;
    elseif data(i,4)==0
        inData.Contact(count).Masterflip=false;
    end
 
    inData.Contact(count).Offset=data(i,5);
    
    % set defualt
    inData.Contact(count).Graphic.MasterColor='g';
    inData.Contact(count).Graphic.SlaveColor='b';

    inData.Contact(count).SearchDist=5.0;
    
    inData.Contact(count).Status{1}=-1;

    count=count+1;

end

fprintf('       no. of not-active contact pair: %g\n', cna)
fprintf('       no. of contact pair: %g\n', count-1)


%----------------
function inData=setFieldLocator(inData, field, data, txt, id, eps)

%--
f.Name=txt{id};

if data(id,1)==0
    f.Enable=false;
else
    f.Enable=true;
end

f.Master=data(id,4);
f.Slave=data(id,5);

% P1
P1=data(id,6:8);
f.Pm=P1;

% get normal vector
l=norm(data(id,9:11));
       
if l<=eps
    warning('FEMP (reading excel input): locator - Vector cannot be zero');
    f.Nm=data(id,9:11);
else
    f.Nm=data(id,9:11)/l;
end

p=data(id,3);

if p>0
    % Nt
    P2=data(id,12:14);

    l=norm(P2-P1);

    if l<=eps
        warning('FEMP (reading excel input): locator - Vector cannot be zero');
        f.Parametrisation.Geometry.Nt{1}=P2-P1;
    else
        f.Parametrisation.Geometry.Nt{1}=(P2-P1)/l;
    end
else
    f.Parametrisation.Geometry.Nt{1}=[];
end

if p==0
    f.Parametrisation.Geometry.Type{1}='ref';
elseif p==1
    f.Parametrisation.Geometry.Type{1}='TV';
elseif p==2
    f.Parametrisation.Geometry.Type{1}='TVN';
end

f.Parametrisation.Geometry.T{1}=0;
f.Parametrisation.Geometry.V{1}=0;
f.Parametrisation.Geometry.N{1}=0;
f.Parametrisation.Geometry.R{1}=eye(3,3);

f.Parametrisation.DoF{1}=[];

s=data(id,15);
if s>0;
    f.Geometry.Size=s;
    
    f.Geometry.Type='sgeom'; 

else
    f.Geometry.Size=0;
    
    f.Geometry.Type='point'; 
end

% set initial struture
f.Geometry.Face=[];
f.Geometry.Vertex=[];

f.Graphic.Color='g';

f.SearchDist=5.0;

% default
f.Pam=[];
f.Pas=[];

f.Nam=[];
f.Nas=[];

f.NormalType='model'; % "model", "user"

f.Status{1}=-1;

% store back

% get existing fields
fsave=getfield(inData.Locator, field);

% counter
count=length(fsave);

if count==0
    fsave=f;
else
    fsave(count+1)=f;
end

inData.Locator=setfield(inData.Locator, field, fsave);

%--
function inData=setFieldPinSlot(inData, field, data, txt, id, eps)

f.Name=txt{id};

if data(id,1)==0
   f.Enable=false;
else
   f.Enable=true; 
end
     
f.Master=data(id,4);

Pm=data(id,5:7);
f.Pm=Pm;
           
l=norm(data(id,8:10));

if l<=eps
    warning('FEMP (reading excel input): hole-slot layout - Vector cannot be zero');
    f.Nm(1,:)=data(id,8:10);
else
    f.Nm(1,:)=data(id,8:10)/l;
end

l=norm(data(id,11:13));

if l<=eps
    warning('FEMP (reading excel input): hole-slot layout - Vector cannot be zero');
    f.Nm(2,:)=data(id,11:13);
else
    f.Nm(2,:)=data(id,11:13)/l;
end
            
para=data(id,3);
if para==0
    f.Parametrisation.Geometry.Type{1}='ref';
else
    f.Parametrisation.Geometry.Type{1}='TV';
end

if para>0
    % Nt
    P2=data(id,14:16);

    l=norm(P2-Pm);

    if l<=eps
        warning('FEMP (reading excel input): hole-slot layout - Vector cannot be zero');
        f.Parametrisation.Geometry.Nt{1}=P2-Pm;
    else
        f.Parametrisation.Geometry.Nt{1}=(P2-Pm)/l;
    end
else
    f.Parametrisation.Geometry.Nt{1}=[];
end

f.Parametrisation.Geometry.T{1}=0;
f.Parametrisation.Geometry.V{1}=0;
f.Parametrisation.Geometry.N{1}=0;
f.Parametrisation.Geometry.R{1}=eye(3,3);

if strcmp(field,'Hole')
    f.Parametrisation.DoF{1}=[0 0 0 0];
elseif strcmp(field,'Slot')
    f.Parametrisation.DoF{1}=[0 0];
end

f.Graphic.Color='g';
f.Constraint.Ds=1; % distance from starting point
f.Constraint.De=1; % distance from ending point
f.Constraint.Dc=1; % cylindrical zone
    
f.SearchDist=5.0;

f.Pam=[];
f.Pas=[];

f.Status{1}=-1;

% store back

% get existing fields
fsave=getfield(inData.PinLayout, field);

% counter
count=length(fsave);

if count==0
    fsave=f;
else
    fsave(count+1)=f;
end

inData.PinLayout=setfield(inData.PinLayout, field, fsave);


