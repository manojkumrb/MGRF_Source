% A script demonstrating the abilites of non-ideal part modelling and
% simulation using the mGRF methodology
% It shows the modelling and simulation of non-ideal parts of an automotive
% door inner for:
%
% #. Local deformation of flange.
% #. Global deformation of bending.
%
% It also demonstrated various options to find the optimum covariance
% function parameters (hyper-parameters), namely:
%
% #. Learn from cloud of point data
% #. Load parameters from a file.
% #. Set the parameters manually.
% #. Use a default set of parameters.
%

close all;
clear ;
dbstop if error;

curr_file = mfilename('fullpath'); % get complete path for the current file % can use which('filename') as well 
curr_dir = fileparts(curr_file);% Determine where m-file's folder is.
addpath(genpath(curr_dir));% Add that folder plus all subfolders to the path.
inpFiles=strcat(curr_dir,'\input');% Path for input files
fileName{1} =strcat(inpFiles,'\405_inner_contactSurfMesh.inp'); % input part mesh
domainID    =1;
load('normalDev405NewMeshContSurf.mat') % load normal dev (devPatterns=nNodes x instances)        
load('keyPtInr405CtsrfDense.mat');% load key point coordiantes and mesh id (struct keyPoints with fields ID and Coordinate)
load('hypAllAl405NewMeshContSurf.mat');% load optimum correlation length


%% Mesh prerequisites
eps                 =10E-16;
fem                 =femInit();
fem                 =importMultiMesh(fem, fileName);%has provisions for domain separation within code
fem                 =femPreProcessing(fem);
nodeIdDomain        =fem.Domain(domainID).Node;
meshCoord           =fem.xMesh.Node.Coordinate(nodeIdDomain,:); % coordinates for the domain

%% generating master stiffness matrix for interpolation
meshStiffMat        =getAssembledKe(fem,1);

%% Input for nGRF
nSample                 = 2;
keyPointsID             = keyPoints.ID;
% Hyper-parameter options
mGRF.HypParmOpt.Type    ='loadFrmFile';% 'measData'| 'manual' | 'loadFrmFile'|'default'
% For 'measData'
mGRF.HypParmOpt.devPatterns= devPatterns(:,3)';%nInstances x nNodes matrix of non-ideal  deviations
% For 'manual'
mGRF.HypParmOpt.sn      = exp(-1.48) ;%noise standard dev
mGRF.HypParmOpt.lScale  = exp([4.99;1.98;4.30]);%characteristic length scale, 3X1 vector for x,yand z directions
mGRF.HypParmOpt.sf      = exp(0.9140);%scaling factor (set to 1 by default)
% For 'file'
mGRF.HypParmOpt.File    = 'hypAllAl405NewMeshContSurf.mat';%name of the .mat file containing optimised hyper parameter values for a batch of deviations
% Non-ideal deviation options
mGRF.NIdev.Type         = 'flange';%'dent'|'flange'|'bending'|'formErr', String defining the type of non-ideal deformatios
mGRF.NIdev.Probability	= 0.95;%confidence value that max form error is less than specified value (between 0-1)
mGRF.NIdev.MaxFormError = 2;%Maximum specified form error
mGRF.NIdev.NBasis       = 40;%Number of basis to use for interpolating the covariance matric for whole mesh
mGRF.NIdev.Bending.ID 	= [24460;7703];%Vector of length 2 representing two nodes forming the bending axis
mGRF.NIdev.Bending.Theta= 2;
mGRF.NIdev.Local.ID 	= 17512:17568;		% for flange bottom;%vector containing node IDs of all nodes being manipulated
mGRF.NIdev.Local.Dev    = 2.*ones(size(mGRF.NIdev.Local.ID));%nID X 1, vector of local deformation of key points

%% The fuction call
dev=getMgrfDev(mGRF,meshCoord,keyPointsID,meshStiffMat,nSample);

%% verify by plotting
for i=1:nSample    
    contourDomainPlot(fem,1,dev(:,i),1);
    lightangle(45,35);
    lightangle(-45,30);
    view([-35,5]);
    fName= sprintf('nonIdealStBend%i',i);
    %export_fig(fName,'-png','-r400','-transparent');
end
