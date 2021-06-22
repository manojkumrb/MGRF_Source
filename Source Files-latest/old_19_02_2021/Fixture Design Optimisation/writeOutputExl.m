% write input data file into excel format

function writeOutputExl(inputData, filename, vrmDir)

% INPUT: inputData = input data file
%        filename = excelfile to write
%        vrmdir = VRM directory

% OUTPUT: Excel file


%% Check if the filename exist

if exist(filename)
    delete(filename);
end

source = [vrmDir,'\Fixture Design Optimisation\input_data_RLW_template.xlsx'];
destination = pwd;

copyfile(source,destination);

movefile('input_data_RLW_template.xlsx',filename); %# Make the new name


%% Stitch Processing

sheet = 1;
if isfield(inputData,'Stitch')
    disp('--> Writing Stitch Data')
    
    if ~isempty(inputData.Stitch.Ps)
        
        nRLW = size(inputData.Stitch.Ps,1);
        for i= 1:nRLW
            
            RLW{i,1} = sprintf('RLW %d',i);
            Ps = inputData.Stitch.Ps(i,:);
            Pe = inputData.Stitch.Pe(i,:);
            Length(i,1) = norm(Ps-Pe);
        end
        
        xlRange = 'A4';
        xlswrite(filename,RLW,sheet,xlRange)
        
        if isfield(inputData.Stitch,'Ns')
            xlRange = 'L4';
            xlswrite(filename,inputData.Stitch.Ns,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Ne')
            xlRange = 'O4';
            xlswrite(filename,inputData.Stitch.Ne,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'StfLength') && ~isempty(inputData.Stitch.StfLength)
            xlRange = 'R4';
            xlswrite(filename,inputData.Stitch.StfLength,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Speed')
            xlRange = 'S4';
            xlswrite(filename,inputData.Stitch.Speed,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Ps')
            xlRange = 'E4';
            xlswrite(filename,inputData.Stitch.Ps,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Pe')
            xlRange = 'H4';
            xlswrite(filename,inputData.Stitch.Pe,sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Type')
            xlRange = 'B4';
            xlswrite(filename,inputData.Stitch.Type',sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Slave')
            xlRange = 'D4';
            xlswrite(filename,inputData.Stitch.Slave',sheet,xlRange)
        end
        
        if isfield(inputData.Stitch,'Master')
            xlRange = 'C4';
            xlswrite(filename,inputData.Stitch.Master',sheet,xlRange)
        end
        
        xlRange = 'K4';
        xlswrite(filename,Length,sheet,xlRange)
        
    end
end


%% Dimple Layout Processing

sheet = 2;

if isfield(inputData,'Dimple')
    disp('--> Writing Dimple Data')
    if ~isempty(inputData.Dimple.Ps)
        
        nDimple = size(inputData.Dimple.Ps,1);
        for i= 1:nDimple
            
            Dimple{i,1} = sprintf('Dimple %d',i);
            
        end
        
        xlRange = 'A4';
        xlswrite(filename,Dimple,sheet,xlRange)
        
        if isfield(inputData.Dimple,'Pe')
            xlRange = 'L4';
            xlswrite(filename,inputData.Dimple.Pe,sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Ns')
            xlRange = 'O4';
            xlswrite(filename,inputData.Dimple.Ns,sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Ne')
            xlRange = 'R4';
            xlswrite(filename,inputData.Dimple.Ne,sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Ps')
            xlRange = 'D4';
            xlswrite(filename,inputData.Dimple.Ps,sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'StitchId')
            xlRange = 'U4';
            xlswrite(filename,inputData.Dimple.StitchId',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Slave')
            xlRange = 'C4';
            xlswrite(filename,inputData.Dimple.Slave',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Master')
            xlRange = 'B4';
            xlswrite(filename,inputData.Dimple.Master',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Height')
            xlRange = 'G4';
            xlswrite(filename,inputData.Dimple.Height',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Offset')
            xlRange = 'I4';
            xlswrite(filename,inputData.Dimple.Offset',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Stiffness')
            xlRange = 'H4';
            xlswrite(filename,inputData.Dimple.Stiffness',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'Masterflip')
            xlRange = 'J4';
            inputData.Dimple.Masterflip = double(inputData.Dimple.Masterflip);
            xlswrite(filename,inputData.Dimple.Masterflip',sheet,xlRange)
        end
        
        if isfield(inputData.Dimple,'L')
            xlRange = 'K4';
            xlswrite(filename,inputData.Dimple.L',sheet,xlRange)
        end
    end
end

%% Spot Welding Processing

sheet = 3;
if isfield(inputData,'Spot')
    disp('--> Writing Spot Welding Data')
    
    if isfield(inputData,'Ps')
        
        if ~isempty(inputData.Spot.Ps)

            nSpot = size(inputData.Spot.Ps,1);
            for i= 1:nSpot

                Spot{i,1} = sprintf('Spot %d',i);

            end

            xlRange = 'A4';
            xlswrite(filename,Spot,sheet,xlRange)

            if isfield(inputData.Spot,'Pm')
                xlRange = 'D4';
                xlswrite(filename,inputData.Spot.Pm,sheet,xlRange)
            end

            if isfield(inputData.Spot,'Nm')
                xlRange = 'G4';
                xlswrite(filename,inputData.Spot.Nm,sheet,xlRange)
            end

            if isfield(inputData.Spot,'Slave')
                xlRange = 'C4';
                xlswrite(filename,inputData.Spot.Slave',sheet,xlRange)
            end

            if isfield(inputData.Spot,'Master')
                xlRange = 'B4';
                xlswrite(filename,inputData.Spot.Master',sheet,xlRange)
            end

            if isfield(inputData.Spot,'Operation')
                xlRange = 'J4';
                xlswrite(filename,inputData.Spot.Operation',sheet,xlRange)
            end

            if isfield(inputData.Spot,'Fault')
                xlRange = 'K4';
                xlswrite(filename,inputData.Spot.Fault',sheet,xlRange)
            end

        end

    end
end

%% Rigid Link Processing

sheet = 4;
if isfield(inputData,'RigidLink')
    disp('--> Writing Rigid Link Data')
    
    if ~isempty(inputData.RigidLink.Pm)
        
        nRigidLink = size(inputData.RigidLink.Pm,1);
        for i= 1:nRigidLink
            
            RigidLink{i,1} = sprintf('RigidLink %d',i);
            
        end
        
        xlRange = 'A4';
        xlswrite(filename,RigidLink,sheet,xlRange)
        
        if isfield(inputData.RigidLink,'Pm')
            xlRange = 'D4';
            xlswrite(filename,inputData.RigidLink.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.RigidLink,'Nm')
            xlRange = 'G4';
            xlswrite(filename,inputData.RigidLink.Nm,sheet,xlRange)
        end
        
        if isfield(inputData.RigidLink,'Slave')
            xlRange = 'C4';
            xlswrite(filename,inputData.RigidLink.Slave',sheet,xlRange)
        end
        
        if isfield(inputData.RigidLink,'Master')
            xlRange = 'B4';
            xlswrite(filename,inputData.RigidLink.Master',sheet,xlRange)
        end
        
        if isfield(inputData.RigidLink,'Operation')
            xlRange = 'J4';
            xlswrite(filename,inputData.RigidLink.Operation',sheet,xlRange)
        end
        
    end
end

%% Pin Layout writing

sheet = 5;
% Pin hole writing
if isfield(inputData.PinLayout,'Hole')
    disp('--> Writing Pin Layout Data - Hole')
    
    if ~isempty(inputData.PinLayout.Hole.Pm)
        
        nPinHole = size(inputData.PinLayout.Hole.Pm,1);
        Type=[];
        for i= 1:nPinHole
            
            PinHole{i,1} = sprintf('PinHole %d',i);
            Type(i,1) = 1;
        end
        
        xlRange = 'A4';
        xlswrite(filename,PinHole,sheet,xlRange)
        
        if isfield(inputData.PinLayout.Hole,'Pm')
            xlRange = 'D4';
            xlswrite(filename,inputData.PinLayout.Hole.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Hole,'Nm1')
            xlRange = 'G4';
            xlswrite(filename,inputData.PinLayout.Hole.Nm1,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Hole,'Nm2')
            xlRange = 'J4';
            xlswrite(filename,inputData.PinLayout.Hole.Nm2,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Hole,'Domain')
            xlRange = 'B4';
            xlswrite(filename,inputData.PinLayout.Hole.Domain',sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Hole,'Operation')
            xlRange = 'M4';
            xlswrite(filename,inputData.PinLayout.Hole.Operation',sheet,xlRange)
        end
        
        xlRange = 'C4';
        xlswrite(filename,Type,sheet,xlRange)
    end
end

% Pin Slot writing

if isfield(inputData.PinLayout,'Slot')
    disp('--> Writing Pin Layout Data - Slot')
    
    if ~isempty(inputData.PinLayout.Slot.Pm)
        
        nPinSlot = size(inputData.PinLayout.Slot.Pm,1);
        Type=[];
        for i= 1:nPinSlot
            
            PinSlot{i,1} = sprintf('PinSlot %d',i);
            Type(i,1) = 2;
        end
        
        
        xlRange = 'A4';
        if ~isempty(inputData.PinLayout.Hole)
            aa= sscanf (xlRange,'%c%f');
            aa(2)=aa(2)+nPinHole;
            formatSpec = '%s%g';
            xlRange = sprintf(formatSpec,aa(1),aa(2));
        end
        xlswrite(filename,PinSlot,sheet,xlRange)
        
        if isfield(inputData.PinLayout.Slot,'Pm')
            xlRange = 'D4';
            if ~isempty(inputData.PinLayout.Hole)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nPinHole;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.PinLayout.Slot.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Slot,'Nm1')
            xlRange = 'G4';
            if ~isempty(inputData.PinLayout.Hole)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nPinHole;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.PinLayout.Slot.Nm1,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Slot,'Nm2')
            xlRange = 'J4';
            if ~isempty(inputData.PinLayout.Hole)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nPinHole;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.PinLayout.Slot.Nm2,sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Slot,'Domain')
            xlRange = 'B4';
            if ~isempty(inputData.PinLayout.Hole)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nPinHole;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.PinLayout.Slot.Domain',sheet,xlRange)
        end
        
        if isfield(inputData.PinLayout.Slot,'Operation')
            xlRange = 'M4';
            if ~isempty(inputData.PinLayout.Hole)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nPinHole;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.PinLayout.Slot.Operation',sheet,xlRange)
        end
        
        
        xlRange = 'C4';
        if ~isempty(inputData.PinLayout.Hole)
            aa= sscanf (xlRange,'%c%f');
            aa(2)=aa(2)+nPinHole;
            formatSpec = '%s%g';
            xlRange = sprintf(formatSpec,aa(1),aa(2));
        end
        xlswrite(filename,Type,sheet,xlRange)
    end
end

%% NC block data writing

sheet = 6;
if isfield(inputData,'NcBlock')
    disp('--> Writing NC Block Data')
    
    if ~isempty(inputData.NcBlock.Pm)
        
        nNcBlock = size(inputData.NcBlock.Pm,1);
        for i= 1:nNcBlock
            
            NcBlock{i,1} = sprintf('NcBlock %d',i);
            
        end
        
        xlRange = 'A4';
        xlswrite(filename,NcBlock,sheet,xlRange)
        
        if isfield(inputData.NcBlock,'Pm')
            xlRange = 'C4';
            xlswrite(filename,inputData.NcBlock.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.NcBlock,'Nm')
            xlRange = 'F4';
            xlswrite(filename,inputData.NcBlock.Nm,sheet,xlRange)
        end
        
        if isfield(inputData.NcBlock,'Size')
            xlRange = 'I4';
            xlswrite(filename,inputData.NcBlock.Size',sheet,xlRange)
        end
        
        if isfield(inputData.NcBlock,'Domain')
            xlRange = 'B4';
            xlswrite(filename,inputData.NcBlock.Domain',sheet,xlRange)
        end
        
        if isfield(inputData.NcBlock,'Operation')
            xlRange = 'J4';
            xlswrite(filename,inputData.NcBlock.Operation',sheet,xlRange)
        end
    end
    
end

%% custom constraints

sheet = 7;

if isfield(inputData,'CustomConstraint')
    disp('--> Writing Custom constraints')
    
    if ~isempty(inputData.CustomConstraint.Pm)
        
        ncc = size(inputData.CustomConstraint.Pm,1);
        
        for i= 1:ncc
            CustoCont{i,1} = sprintf('Custom Const %d',i);
        end
        
        xlRange = 'A4';
        xlswrite(filename,CustoCont,sheet,xlRange)
        
        if isfield(inputData.CustomConstraint,'Domain')
            xlRange = 'B4';
            xlswrite(filename,inputData.CustomConstraint.Domain,sheet,xlRange)
        end
        
        if isfield(inputData.CustomConstraint,'Pm')
            xlRange = 'C4';
            xlswrite(filename,inputData.CustomConstraint.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.CustomConstraint,'DoFs')
            xlRange = 'F4';
            xlswrite(filename,inputData.CustomConstraint.DoFs,sheet,xlRange)
        end
        
    end
    
end


%% Reference Clamp writing

sheet = 8;
% Reference Clamp acting on single part
if isfield(inputData.Clamp,'ReferenceS')
    disp('--> Writing Reference Clamp Data-Single Part')
    
    if ~isempty(inputData.Clamp.ReferenceS.Pm)
        
        nRefClampS = size(inputData.Clamp.ReferenceS.Pm,1);
        Type=[];
        for i= 1:nRefClampS
            RefClampS{i,1} = sprintf('Ref Clamp Single %d',i);
            Type(i,1) = 1;
        end
        
        xlRange = 'A4';
        xlswrite(filename,RefClampS,sheet,xlRange)
        
        if isfield(inputData.Clamp.ReferenceS,'Pm')
            xlRange = 'E4';
            xlswrite(filename,inputData.Clamp.ReferenceS.Pm,sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceS,'Nm')
            xlRange = 'H4';
            xlswrite(filename,inputData.Clamp.ReferenceS.Nm,sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceS,'Size')
            xlRange = 'K4';
            xlswrite(filename,inputData.Clamp.ReferenceS.Size',sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceS,'Domain')
            xlRange = 'C4';
            xlswrite(filename,inputData.Clamp.ReferenceS.Domain',sheet,xlRange)
            
            xlRange = 'D4';
            xlswrite(filename,0*inputData.Clamp.ReferenceS.Domain',sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceS,'Operation')
            xlRange = 'L4';
            xlswrite(filename,inputData.Clamp.ReferenceS.Operation',sheet,xlRange)
        end
        
        xlRange = 'B4';
        xlswrite(filename,Type,sheet,xlRange)
    end
    
end

% Reference Clamp acting on Multiple parts

if isfield(inputData.Clamp,'ReferenceM')
    disp('--> Writing Reference Clamp Data-Multiple Parts')
    
    if ~isempty(inputData.Clamp.ReferenceM.Pm)
        
        nRefClampM = size(inputData.Clamp.ReferenceM.Pm,1);
        Type=[];
        for i= 1:nRefClampM
            
            RefClampM{i,1} = sprintf('Ref Clamp Multiple %d',i);
            Type(i,1) = 2;
        end
        
        xlRange = 'A4';
        if ~isempty(inputData.Clamp.ReferenceS)
            aa= sscanf (xlRange,'%c%f');
            aa(2)=aa(2)+nRefClampS;
            formatSpec = '%s%g';
            xlRange = sprintf(formatSpec,aa(1),aa(2));
        end
        xlswrite(filename,RefClampM,sheet,xlRange)
        
        
        if isfield(inputData.Clamp.ReferenceM,'Pm')
            xlRange = 'E4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Pm,sheet,xlRange)
        end
                
        if isfield(inputData.Clamp.ReferenceM,'Nm')
            xlRange = 'H4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Nm,sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceM,'Size')
            xlRange = 'K4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Size',sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceM,'Slave')
            xlRange = 'D4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Slave',sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceM,'Master')
            xlRange = 'C4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Master',sheet,xlRange)
        end
        
        if isfield(inputData.Clamp.ReferenceM,'Operation')
            xlRange = 'L4';
            if ~isempty(inputData.Clamp.ReferenceS)
                aa= sscanf (xlRange,'%c%f');
                aa(2)=aa(2)+nRefClampS;
                formatSpec = '%s%g';
                xlRange = sprintf(formatSpec,aa(1),aa(2));
            end
            xlswrite(filename,inputData.Clamp.ReferenceM.Operation',sheet,xlRange)
        end
        
        xlRange = 'B4';
        if ~isempty(inputData.Clamp.ReferenceS)
            aa= sscanf (xlRange,'%c%f');
            aa(2)=aa(2)+nRefClampS;
            formatSpec = '%s%g';
            xlRange = sprintf(formatSpec,aa(1),aa(2));
        end
        xlswrite(filename,Type,sheet,xlRange)
    end
    
end
%% Variable Clamps writing

sheet = 9;

if isfield(inputData.Clamp,'Variable')
    disp('--> Writing Variable Clamp Data')
    
    if isfield(inputData.Clamp.Variable,'Ps')

        if ~isempty(inputData.Clamp.Variable.Ps)

            nVarClamp = size(inputData.Clamp.Variable.Ps,1);
            for i= 1:nVarClamp

                VarClamp{i,1} = sprintf('Clamp %d',i);

            end

            xlRange = 'A4';
            xlswrite(filename,VarClamp,sheet,xlRange)

            if isfield(inputData.Clamp.Variable,'StitchIdS')
                xlRange = 'B4';
                xlswrite(filename,inputData.Clamp.Variable.StitchIdS',sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'StitchIdE')
                xlRange = 'C4';
                xlswrite(filename,inputData.Clamp.Variable.StitchIdE',sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Master')
                xlRange = 'F4';
                xlswrite(filename,inputData.Clamp.Variable.Master',sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Slave')
                xlRange = 'G4';
                xlswrite(filename,inputData.Clamp.Variable.Slave',sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Ps')
                xlRange = 'H4';
                xlswrite(filename,inputData.Clamp.Variable.Ps,sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Pe')
                xlRange = 'K4';
                xlswrite(filename,inputData.Clamp.Variable.Pe,sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Po')
                xlRange = 'N4';
                xlswrite(filename,inputData.Clamp.Variable.Po,sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Nm')
                xlRange = 'Q4';
                xlswrite(filename,inputData.Clamp.Variable.Nm,sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Size')
                xlRange = 'D4';
                xlswrite(filename,inputData.Clamp.Variable.Size',sheet,xlRange)
            end

            if isfield(inputData.Clamp.Variable,'Operation')
                xlRange = 'E4';
                xlswrite(filename,inputData.Clamp.Variable.Operation',sheet,xlRange)
            end
        end
    end
    
end
%% Contact Pair writing

sheet = 10;

if isfield(inputData,'Contact')
    disp('--> Writing Contact Pair Data')
    
    if ~isempty(inputData.Contact.Master)
        
        nContactPair = size(inputData.Contact.Slave,2);
        for i= 1:nContactPair
            
            ContactPair{i,1} = sprintf('ContactPair %d',i);
            
        end
        
        xlRange = 'A3';
        xlswrite(filename,ContactPair,sheet,xlRange)
        
        if isfield(inputData.Contact,'Slave')
            xlRange = 'B3';
            xlswrite(filename,inputData.Contact.Slave',sheet,xlRange)
        end
        
        if isfield(inputData.Contact,'Master')
            xlRange = 'C3';
            xlswrite(filename,inputData.Contact.Master',sheet,xlRange)
        end
        
        if isfield(inputData.Contact,'Offset')
            xlRange = 'F3';
            xlswrite(filename,inputData.Contact.Offset',sheet,xlRange)
        end
        
        if isfield(inputData.Contact,'Masterflip')
            xlRange = 'D3';
            inputData.Contact.Masterflip = double(inputData.Contact.Masterflip);
            xlswrite(filename,inputData.Contact.Masterflip',sheet,xlRange)
        end
        
        if isfield(inputData.Contact,'Enable')
            xlRange = 'E3';
            inputData.Contact.Enable = double(inputData.Contact.Enable);
            xlswrite(filename,inputData.Contact.Enable',sheet,xlRange)
        end
        
    end
    
end

%% Part Details writing

sheet = 11;

if isfield(inputData,'Part')
    disp('--> Writing Part Detail Data')
    
    if ~isempty(inputData.Part.E)
        
        nPart = size(inputData.Part.E,2);
        
        flagCOP=zeros(nPart,1);
        flagMesh=zeros(nPart,1);
        
        Part=cell(nPart,1);
        Partid=zeros(nPart,1);
        for i= 1:nPart
            
            Part{i} = sprintf('Part %d',i);
            Partid(i) = i;
            
            if ~isempty(inputData.Part.CoP{i})
                flagCOP(i)=1;
            else
                flagCOP(i)=0;
                inputData.Part.CoP{i}='nominal';
            end
            
            if ~isempty(inputData.Part.Mesh{i})
                flagMesh(i)=1;
            else
                flagMesh(i)=0;
                inputData.Part.Mesh{i}='not-available';
            end
            
        end
        
        xlRange = 'A3';
        xlswrite(filename,Part,sheet,xlRange)
        
        xlRange = 'B3';
        xlswrite(filename,Partid,sheet,xlRange)
        
        if isfield(inputData.Part,'Enable')
            xlRange = 'C3';
            inputData.Part.Enable = double(inputData.Part.Enable);
            xlswrite(filename,inputData.Part.Enable',sheet,xlRange)
        end
        
        if isfield(inputData.Part,'E')
            xlRange = 'D3';
            xlswrite(filename,inputData.Part.E',sheet,xlRange)
        end
        
        if isfield(inputData.Part,'nu')
            xlRange = 'E3';
            xlswrite(filename,inputData.Part.nu',sheet,xlRange)
        end
        
        if isfield(inputData.Part,'Th')
            xlRange = 'F3';
            xlswrite(filename,inputData.Part.Th',sheet,xlRange)
        end
             
        
        if isfield(inputData.Part,'Offset')
            xlRange = 'G3';
            xlswrite(filename,inputData.Part.Offset',sheet,xlRange)
        end
        
        if isfield(inputData.Part,'FlexStatus')
            xlRange = 'H3';
            xlswrite(filename,inputData.Part.FlexStatus',sheet,xlRange)
        end
        
        % save mesh
        if isfield(inputData.Part,'Mesh')
            xlRange = 'I3';
            xlswrite(filename,flagMesh,sheet,xlRange)

            xlRange = 'K3';
            xlswrite(filename,inputData.Part.Mesh',sheet,xlRange)
        end

        % save CoPs
        if isfield(inputData.Part,'CoP')
            xlRange = 'J3';
            xlswrite(filename,flagCOP,sheet,xlRange)

            xlRange = 'L3';
            xlswrite(filename,inputData.Part.CoP',sheet,xlRange)
        end
        
    end
    
end

