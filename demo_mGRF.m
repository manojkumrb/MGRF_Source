% A script demonstrating the abilites of non-ideal part modelling and
% simulation using the mGRF methodology.
% This script shows the modelling and simulation of non-ideal parts of an automotive
% door inner for the local deformation of flange.
% 
% The optimum covariance function parameters are loaded from a file which
% was generated earlier. 
% Key options with comments describing each of the option are as follows:
%
% .. code-block:: matlab
%    :linenos:  
%
%     % Hyper-parameter options
%     mGRF.HypParmOpt.Type    ='loadFrmFile';% could be 'measData'| 'manual' | 'loadFrmFile'|'default'
%     % For 'file'
%     mGRF.HypParmOpt.File    = 'hypAllAl405NewMeshContSurf.mat';%name of the .mat file containing optimised hyper parameter values for a batch of deviations
% 
%     % Non-ideal deviation options
%     mGRF.NIdev.Type         = 'flange'; String defining the type of non-ideal deformatios
%     mGRF.NIdev.Probability	= 0.97;%confidence value that max form error is less than specified value (between 0-1)
%     mGRF.NIdev.MaxFormError = 2;%Maximum specified form error
%     mGRF.NIdev.NBasis       = 40;%Number of basis to use for interpolating the covariance matric for whole mesh
%     mGRF.NIdev.Local.ID 	= 17512:17568;		% for flange bottom;%vector containing node IDs of all nodes being manipulated
%     mGRF.NIdev.Local.Dev    = 2.*ones(size(mGRF.NIdev.Local.ID));%nID X 1, vector of local deformation of key points
%
%
% Running this script will generate non-ideal parts as illustrated below
%
% .. figure:: /images/flange1.PNG
% 
%     An illustration of generated non-ideal part with flange deformation
%     of 2 mm and a form error of 2 m with statistical confience of 97%


close all;
clear ;
dbstop if error;

curr_file = mfilename('fullpath'); % obtain file name and path
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
% For 'file'
mGRF.HypParmOpt.File    = 'hypAllAl405NewMeshContSurf.mat';%name of the .mat file containing optimised hyper parameter values for a batch of deviations

% Non-ideal deviation options
mGRF.NIdev.Type         = 'flange';%'dent'|'flange'|'bending'|'formErr', String defining the type of non-ideal deformatios
mGRF.NIdev.Probability	= 0.97;%confidence value that max form error is less than specified value (between 0-1)
mGRF.NIdev.MaxFormError = 2;%Maximum specified form error
mGRF.NIdev.NBasis       = 40;%Number of basis to use for interpolating the covariance matric for whole mesh
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
    scatter3(meshCoord(mGRF.NIdev.Local.ID,1),meshCoord(mGRF.NIdev.Local.ID,2),meshCoord(mGRF.NIdev.Local.ID,3),'filled','r')

    %export_fig(fName,'-png','-r400','-transparent');
end
