% A script demonstrating the abilites of non-ideal part modelling and
% simulation using the mGRF methodology.
% This script shows the modelling and simulation of non-ideal parts of an automotive
% door inner for the global deformation of bending.
% 
% The optimum covariance function parameters are obtained from the a
% complete part measurent. This demo uses a single part measurement, many
% measuremets can be used and average or any other statistical sampling can be used to
% obtain the optimum parameters. The optimsation process to obtain
% covariance function parameters is computationally intensive.
%
% Key options with comments describing each of the option are as follows:
%
% .. code-block:: matlab
%    :linenos:  
%
%     % Hyper-parameter options
%     mGRF.HypParmOpt.Type    ='measData';% could be 'measData'| 'manual' | 'loadFrmFile'|'default'
%     mGRF.HypParmOpt.devPatterns= devPatterns(:,3)';% 1 x nNodes vector of non-ideal part  deviations
% 
%     % Non-ideal deviation options
%     mGRF.NIdev.Type           = 'bending'; String defining the type of non-ideal deformatios
%     mGRF.NIdev.Probability	= 0.97;%confidence value that max form error is less than specified value (between 0-1)
%     mGRF.NIdev.MaxFormError   = 1;%Maximum specified form error
%     mGRF.NIdev.NBasis         = 40;%Number of basis to use for interpolating the covariance matric for whole mesh
%     mGRF.NIdev.Bending.ID 	= [24460;7703];%Vector of length 2 representing two nodes forming the bending axis
%     mGRF.NIdev.Bending.Theta  = 0.2; % the angle of bending about the axis in degrees
%
%
% Running this script will generate non-ideal parts similar to the
% illustration below. The non-ideal part will not be same as the
% illustration due to the stochastic nature of form error.
%
% .. figure:: /images/bending1.PNG
% 
%     An illustration of generated non-ideal part with bending deformation
%     of 0.1 degrees about axis defined by two nodes a1 and a2. A form error
%     of 1 mm with statistical confience of 97 % is also superimposed.


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
% For 'file'
mGRF.HypParmOpt.File    = 'hypAllAl405NewMeshContSurf.mat';%name of the .mat file containing optimised hyper parameter values for a batch of deviations
% Non-ideal deviation options
mGRF.NIdev.Type         = 'bending';%'dent'|'flange'|'bending'|'formErr', String defining the type of non-ideal deformatios
mGRF.NIdev.Probability	= 0.97;%confidence value that max form error is less than specified value (between 0-1)
mGRF.NIdev.MaxFormError = 1;%Maximum specified form error
mGRF.NIdev.NBasis       = 40;%Number of basis to use for interpolating the covariance matric for whole mesh
mGRF.NIdev.Bending.ID 	= [24460;7703];%Vector of length 2 representing two nodes forming the bending axis
mGRF.NIdev.Bending.Theta= 0.2;
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
    hold all
    scatter3(meshCoord(mGRF.NIdev.Bending.ID,1),meshCoord(mGRF.NIdev.Bending.ID,2),meshCoord(mGRF.NIdev.Bending.ID,3),'filled','r')
    %export_fig(fName,'-png','-r400','-transparent');
end
