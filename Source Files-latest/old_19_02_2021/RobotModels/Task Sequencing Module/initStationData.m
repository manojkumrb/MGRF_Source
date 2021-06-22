% init station model
function StationData=initStationData(robotmodel, workpiecefile, T0wp, reductionvalue, opt)

% robotmodel: robot model
% workpiecefile: wotkpiece file (cell array)

% OPTIONALs
% T0wp: 4x4 placement matrix ( from workpiece ("wp") to robot frame ("0") )
% reductionvalue: % of mesh reduction [0, 1]
% opt: "geom", "file"

% check input
if nargin==1
    workpiecefile=[];
elseif nargin==2
    T0wp{1}=eye(4,4);
    reductionvalue=1;
    opt='file';
elseif nargin==3
    reductionvalue=1;
    opt='file';
elseif nargin==4
    opt='file';
end

% load robot
StationData.Robot=initRobot(robotmodel);

% load workpiece
if isempty(workpiecefile)
    StationData.Workpiece=[];
    return
end

%--
nwp=length(workpiecefile);
dataGeom=cell(1,nwp);
for i=1:nwp

    % check input type
    if strcmpi(opt, 'file')
        [tria, quad, node, flag]=readMesh(workpiecefile{i});

        if ~flag
            fprintf('initStationData (error): failed to read: %s\n', workpiecefile{i});
            return
        end
    else
        node=workpiecefile{i}.Node;
        quad=workpiecefile{i}.Quad;
        tria=workpiecefile{i}.Tria;
    end

    % split quads into trias
    if ~isempty(quad)
        tria=[tria
              splitQuad2Tria(quad)]; %#ok<AGROW>
    end

    % -- apply workpiece placement
    node=apply4x4(node, T0wp{i}(1:3,1:3), T0wp{i}(1:3,4)');

    % run mesh semplification
    FV.faces=tria;
    FV.vertices=node;

    FV=reducepatch(FV, reductionvalue);

    dataGeom{i}.Node=FV.vertices;
    dataGeom{i}.Quad=-1;
    dataGeom{i}.Tria=FV.faces;
end
        
% pre-process it
StationData.Workpiece=femInit();
StationData.Workpiece.Options.StiffnessUpdate=false;
StationData.Workpiece.Options.MassUpdate=false;
StationData.Workpiece.Options.ConnectivityUpdate=true;

StationData.Workpiece=importMultiMesh(StationData.Workpiece, dataGeom, 'geom');

% -- and save...
StationData.Workpiece=femPreProcessing(StationData.Workpiece);

% -- flip normal component if needed
ndom=StationData.Workpiece.Sol.nDom;
for i=1:ndom
%     StationData.Workpiece=flipNormalComponent(StationData.Workpiece, i);
end


