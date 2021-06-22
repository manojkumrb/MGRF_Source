
% read input data from filename
function inData=readInputsExl(filename, rowmax)

% INPUT:
% filename: excel input file
% rowmax: max. no. of rows to read

% inData: data structure

%-- SHEET 1a
inData.Stitch=[]; % stitch data
% inData.Stitch.Ps=[];
% inData.Stitch.Pe=[];
% inData.Stitch.Type=[];
% inData.Stitch.Slave=[];
% inData.Stitch.Master=[];

%--
% inData.Stitch.Ns=[];
% inData.Stitch.Ne=[];
% inData.Stitch.StfLength=[];

%-- SHEET 2
inData.Dimple=[]; % dimple data
% inData.Dimple.Ps=[];
% inData.Dimple.L=[];
% inData.Dimple.Slave=[];
% inData.Dimple.Master=[];
% inData.Dimple.Height=[];
% inData.Dimple.Offset=[];
% inData.Dimple.Stiffness=[];          
% inData.Dimple.Masterflip=[];  

%--
% inData.Dimple.Pe=[];
% inData.Dimple.Ns=[];
% inData.Dimple.Ne=[];
% inData.Dimple.StitchId=[];

%-- SHEET 3
inData.Spot=[]; % spot data
% inData.Spot.Pm=[];
% inData.Spot.Ps=[];
% inData.Spot.Nm=[];
% inData.Spot.Slave=[];
% inData.Spot.Master=[];
% inData.Spot.Operation=[];
% inData.Spot.Fault=[];

%-- SHEET 4
inData.RigidLink=[]; % rigid link data
% inData.RigidLink.Pm=[];
% inData.RigidLink.Nm=[];
% inData.RigidLink.Slave=[];
% inData.RigidLink.Master=[];
% inData.RigidLink.Operation=[];

%-- SHEET 5a
inData.PinLayout.Hole=[]; % pin-hole data
% inData.PinLayout.Hole.Pm=[];
% inData.PinLayout.Hole.Nm1=[];
% inData.PinLayout.Hole.Nm2=[];
% inData.PinLayout.Hole.Domain=[];
% inData.PinLayout.Hole.Operation=[];

%-- SHEET 5b
inData.PinLayout.Slot=[]; % pin-slot data
% inData.PinLayout.Slot.Pm=[];
% inData.PinLayout.Slot.Nm1=[];
% inData.PinLayout.Slot.Nm2=[];
% inData.PinLayout.Slot.Domain=[];
% inData.PinLayout.Slot.Operation=[];

%-- SHEET 6
inData.NcBlock=[]; % NC-block data
% inData.NcBlock.Pm=[];
% inData.NcBlock.Pa=[];
% inData.NcBlock.Nm=[];
% inData.NcBlock.Size=[];
% inData.NcBlock.Domain=[];
% inData.NcBlock.Operation=[];

%-- SHEET 7a
inData.Clamp.ReferenceS=[]; % referance clamp on single part
% inData.Clamp.ReferenceS.Pm=[];
% inData.Clamp.ReferenceS.Pa=[];
% inData.Clamp.ReferenceS.Nm=[];
% inData.Clamp.ReferenceSSize=[];
% inData.Clamp.ReferenceS.Domain=[];
% inData.Clamp.ReferenceS.Operation=[];

%-- SHEET 7b
inData.Clamp.ReferenceM=[]; % referance clamp on multiple part
% inData.Clamp.ReferenceM.Pm=[];
% inData.Clamp.ReferenceM.Pam=[];
% inData.Clamp.ReferenceM.Ps=[];
% inData.Clamp.ReferenceM.Pas=[];
% inData.Clamp.ReferenceM.Nm=[];
% inData.Clamp.ReferenceM.Size=[];
% inData.Clamp.ReferenceM.Slave=[];
% inData.Clamp.ReferenceM.Master=[];
% inData.Clamp.ReferenceM.Operation=[];

%-- SHEET 8
inData.Clamp.Variable=[]; % variable clamps
% inData.Clamp.Variable.StitchIdS=[]; % Stitch ID start point
% inData.Clamp.Variable.StitchIdE=[]; % Stitch ID end point
% inData.Clamp.Variable.Master=[];
% inData.Clamp.Variable.Slave=[];
% inData.Clamp.Variable.Ps=[]; % start point
% inData.Clamp.Variable.Pe=[]; % end point
% inData.Clamp.Variable.Po=[]; % optimum point
% inData.Clamp.Variable.Nm=[]; % normal vector
% inData.Clamp.Variable.Size=[];
% inData.Clamp.Variable.Operation=[];

%-- SHEET 9
inData.Contact=[]; % contact pairs
% inData.Contact.Slave=[];
% inData.Contact.Master=[];
% inData.Contact.Offset=[];
% inData.Contact.Masterflip=[];
% inData.Contact.Enable=[];

%-- SHEET 10
inData.Part=[]; % part details
% inData.Part.Enable=[];
% inData.Part.E=[];
% inData.Part.nu=[];
% inData.Part.Th=[];
% inData.Part.Mesh=[];
% inData.Part.CoP=[];
% inData.Part.Offset=[];


inData.SubModel=[]; % sub-modelling field
% inData.SubModel.U=[]; % displacement field 


disp('Reading inputs:')

%--------------------
% read stich and dimple
disp('      stitches...')

%-- SHEET 1
rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,1,rc);

% save stitch
inData.Stitch.Ns=[];
inData.Stitch.Ne=[];
inData.Stitch.StfLength=[];

count=1;
for i=1:size(data,1)
    if data(i,1)==1 % linear stitch
        inData.Stitch.Ps(count,:)=data(i,4:6);
        inData.Stitch.Pe(count,:)=data(i,7:9);
        inData.Stitch.Type(count)=data(i,1);
        
        inData.Stitch.Slave(count)=data(i,3);
        inData.Stitch.Master(count)=data(i,2);
        
        count=count+1;
        
    elseif data(i,1)==2 % circular stitch
        
        inData.Stitch.Ps(count,:)=data(i,4:6);
        inData.Stitch.Pe(count,:)=data(i,4:6);
        inData.Stitch.Type(count)=data(i,1);
        
        inData.Stitch.Slave(count)=data(i,3);
        inData.Stitch.Master(count)=data(i,2);
        
        count=count+1;
        
    elseif data(i,1)==0 % not active
        
        inData.Stitch.Ps(count,:)=data(i,4:6);
        inData.Stitch.Pe(count,:)=data(i,7:9);
        inData.Stitch.Type(count)=data(i,1);
        
        inData.Stitch.Slave(count)=data(i,3);
        inData.Stitch.Master(count)=data(i,2);
        
        count=count+1;
                
    end
end

% save dimple
disp('      dimples...')

%-- SHEET 2
rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,2,rc);

inData.Dimple.Pe=[];
inData.Dimple.Ns=[];
inData.Dimple.Ne=[];
inData.Dimple.StitchId=[];

count=1;
for i=1:size(data,1)
    
    if data(i,1)~=0
        inData.Dimple.Ps(count,:)=data(i,3:5);
        inData.Dimple.Slave(count)=data(i,2);
        inData.Dimple.Master(count)=data(i,1);
        inData.Dimple.Height(count)=data(i,6);
        inData.Dimple.Stiffness(count)=data(i,7);
        inData.Dimple.Offset(count)=data(i,8);
        
        if data(i,9)==1
            inData.Dimple.Masterflip(count)=true;
        elseif data(i,9)==0
            inData.Dimple.Masterflip(count)=false;
        end
        
        inData.Dimple.L(count)=data(i,10);
        
        count=count+1;
    end
               
end


%-- SHEET 3
% spot layout
disp('      spots...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,3,rc);

count=1;
for i=1:size(data,1)

    if data(i,1)~=0 % 
        
        inData.Spot.Master(count)=data(i,1);
        inData.Spot.Slave(count)=data(i,2);
        
        
        inData.Spot.Pm(count,:)=data(i, 3:5);
        inData.Spot.Ps(count,:)=data(i, 3:5);

        l=norm(data(i,6:8));

        if l<=1e-6
            warning('FEMP (reading excel input): spot-layout - Vector cannot be zero');
            inData.Spot.Nm(count,:)=data(i, 6:8);
        else
            inData.Spot.Nm(count,:)=data(i, 6:8)/l;
        end

        inData.Spot.Operation(count)=data(i,9);
        
        inData.Spot.Fault(count)=data(i,10);

        count=count+1;
            
    end
        
end


%-- SHEET 4
% rigid link layout
disp('      rigid links...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,4,rc);

count=1;
for i=1:size(data,1)

    if data(i,1)~=0 % 
        
        inData.RigidLink.Master(count)=data(i,1);
        inData.RigidLink.Slave(count)=data(i,2);
        
        inData.RigidLink.Pm(count,:)=data(i, 3:5);

        l=norm(data(i,6:8));

        if l<=1e-6
            warning('FEMP (reading excel input): rigid link - Vector cannot be zero');
            inData.RigidLink.Nm(count,:)=data(i, 6:8);
        else
            inData.RigidLink.Nm(count,:)=data(i, 6:8)/l;
        end

        inData.RigidLink.Operation(count)=data(i,9);

        count=count+1;

    end
        
end


%-- SHEET 5
% read pin layout
disp('      pin layout...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,5,rc);

counth=1;
counts=1;
for i=1:size(data,1)
    if data(i,2)==1 % pin-hole
        
        inData.PinLayout.Hole.Domain(counth)=data(i,1);
        
        inData.PinLayout.Hole.Pm(counth,:)=data(i,3:5);
        
        l=norm(data(i,6:8));
        
        if l<=1e-6
            warning('FEMP (reading excel input): pin-layout - Vector cannot be zero');
            inData.PinLayout.Hole.Nm1(counth,:)=data(i,6:8);
        else
            inData.PinLayout.Hole.Nm1(counth,:)=data(i,6:8)/l;
        end
        
        
        
        l=norm(data(i,9:11));
        
        if l<=1e-6
            warning('FEMP (reading excel input): pin-layout - Vector cannot be zero');
            inData.PinLayout.Hole.Nm2(counth,:)=data(i,9:11);
        else
            inData.PinLayout.Hole.Nm2(counth,:)=data(i,9:11)/l;
        end
        
        inData.PinLayout.Hole.Operation(counth)=data(i,12);
        
        counth=counth+1;
        
    elseif data(i,2)==2 % pin-slot
        
        inData.PinLayout.Slot.Domain(counts)=data(i,1);
        
        inData.PinLayout.Slot.Pm(counts,:)=data(i,3:5);
        
        l=norm(data(i,6:8));
        
        if l<=1e-6
            warning('FEMP (reading excel input): slot-layout - Vector cannot be zero');
            inData.PinLayout.Slot.Nm1(counts,:)=data(i,6:8);
        else
            inData.PinLayout.Slot.Nm1(counts,:)=data(i,6:8)/l;
        end
        
        l=norm(data(i,9:11));
        
        if l<=1e-6
            warning('FEMP (reading excel input): slot-layout - Vector cannot be zero');
            inData.PinLayout.Slot.Nm2(counts,:)=data(i,9:11);
        else
            inData.PinLayout.Slot.Nm2(counts,:)=data(i,9:11)/l;
        end
        
        inData.PinLayout.Slot.Operation(counts)=data(i,12);
        
        counts=counts+1;
        
    end
end

%-- SHEET 6
% read NC-block layout
disp('      NC-block layout...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,6,rc);

count=1;
for i=1:size(data,1)
        
    if data(i,1)~=0
        
        inData.NcBlock.Domain(count)=data(i,1);
        
        inData.NcBlock.Pm(count,:)=data(i,2:4);
        
        l=norm(data(i,5:7));
        
        if l<=1e-6
            warning('FEMP (reading excel input): NC-block - Vector cannot be zero');
            inData.NcBlock.Nm(count,:)=data(i,5:7);
        else
            inData.NcBlock.Nm(count,:)=data(i,5:7)/l;
        end
        
        if data(i,8)>0;
            inData.NcBlock.Size(count)=data(i,8);
            
        else
            inData.NcBlock.Size(count)=0;
        end
        
        inData.NcBlock.Operation(count)=data(i,9);
        
        count=count+1;
    end
        
end

%-- SHEET 7
% read reference clamps
disp('      reference clamps...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,7,rc);

countm=1;
count=1;
for i=1:size(data,1)
        
    if data(i,1)==1 % single reference clamp
        
        inData.Clamp.ReferenceS.Domain(count)=data(i,2);
        inData.Clamp.ReferenceS.Pm(count,:)=data(i,4:6);
        
        l=norm(data(i,7:9));
        
        if l<=1e-6
            warning('FEMP (reading excel input): ref. clamp single part - Vector cannot be zero');
            inData.Clamp.ReferenceS.Nm(count,:)=data(i,7:9);
        else
            inData.Clamp.ReferenceS.Nm(count,:)=data(i,7:9)/l;
        end
        
        if data(i,10)>0;
            inData.Clamp.ReferenceS.Size(count)=data(i,10);
            
        else
            inData.Clamp.ReferenceS.Size(count)=0;
            
        end
        
        inData.Clamp.ReferenceS.Operation(count)=data(i,11);
        
        count=count+1;
        
    elseif data(i,1)==2 % multiple reference clamp
        
        inData.Clamp.ReferenceM.Master(countm)=data(i,2);
        inData.Clamp.ReferenceM.Slave(countm)=data(i,3);
        
        inData.Clamp.ReferenceM.Pm(countm,:)=data(i,4:6);
        
        l=norm(data(i,7:9));
        
        if l<=1e-6
            warning('FEMP (reading excel input): ref. clamp multiple part - Vector cannot be zero');
            inData.Clamp.ReferenceM.Nm(countm,:)=data(i,7:9);
        else
            inData.Clamp.ReferenceM.Nm(countm,:)=data(i,7:9)/l;
        end
        
        if data(i,10)>0;
            inData.Clamp.ReferenceM.Size(countm)=data(i,10);
            
        else
            inData.Clamp.ReferenceM.Size(countm)=0;
            
        end
        
        inData.Clamp.ReferenceM.Operation(countm)=data(i,11);
        
        countm=countm+1;
        
    end
        
end

%-- SHEET 8
% read variable clamps
disp('      variable clamps...')

rc=sprintf('B4:AZ%g',rowmax);
data = xlsread(filename,8,rc);

count=1;
for i=1:size(data,1)
    
    if data(i,4)~=0
                
        inData.Clamp.Variable.StitchIdS(count)=data(i,1);
        inData.Clamp.Variable.StitchIdE(count)=data(i,2);
        
        if data(i,3)>0
            inData.Clamp.Variable.Size(count)=data(i,3);
            
        else
            inData.Clamp.Variable.Size(count)=0;
            
        end
        
        inData.Clamp.Variable.Operation(count)=data(i,4);
        
        inData.Clamp.Variable.Master(count)=data(i,5);
        inData.Clamp.Variable.Slave(count)=data(i,6);
        
        inData.Clamp.Variable.Ps(count,:)=data(i,7:9);
        inData.Clamp.Variable.Pe(count,:)=data(i,10:12);
        
        inData.Clamp.Variable.Po(count,:)=data(i,13:15);
        
        inData.Clamp.Variable.Nm(count,:)=data(i,16:18);
                
        count=count+1;
    end
 
end

%-- SHEET 9
% read contact pair
disp('      contact pair...')

rc=sprintf('B3:AZ%g',rowmax);
data = xlsread(filename,9,rc);

count=1;
for i=1:size(data,1)
    
    if data(i,1)~=0
        inData.Contact.Slave(count)=data(i,1);
        inData.Contact.Master(count)=data(i,2);

        if data(i,3)==1
            inData.Contact.Masterflip(count)=true;
        elseif data(i,3)==0
            inData.Contact.Masterflip(count)=false;
        end
        
        if data(i,4)==1
            inData.Contact.Enable(count)=true;
        elseif data(i,4)==0
            inData.Contact.Enable(count)=false;
        end
        
        inData.Contact.Offset(count)=data(i,5);
        
        count=count+1;
    end
end


%-- SHEET 10
% read part info
disp('      part details...')

rc=sprintf('B3:AZ%g',rowmax);
[data, txt] = xlsread(filename,10,rc); % read numeric data and text

count=1;
for i=1:size(data,1)
    
    if data(i,1)~=0
        
        if data(i,2)==1
            inData.Part.Enable(count)=true;
        elseif data(i,2)==0
            inData.Part.Enable(count)=false;
        end
        
        inData.Part.E(count)=data(i,3);
        inData.Part.nu(count)=data(i,4);
        inData.Part.Th(count)=data(i,5);
        
        inData.Part.Offset(count)=data(i,6);
        
        % mesh file
        if data(i,7)==1
            inData.Part.Mesh{count}=txt{i,1}; % NB: modified for excel 2010
        else
            inData.Part.Mesh{count}='';
        end
        
        % CoP
        if data(i,8)==1
            inData.Part.CoP{count}=txt{i,2}; % NB: modified for excel 2010
        else
            inData.Part.CoP{count}='';
        end
        
        count=count+1;
    end
end

