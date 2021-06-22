function dev=getMgrfDev(mGRF,meshCoord,keyPointsID,meshStiffMat,nSample)
% The main function to simulate non-ideal parts using morphing-Gaussian Random
% Fields(mGRF). All options to the generation of non-ideal parts are to be provided in the
% mGRF structure. The mGRF structure has to main inputs: 
% 
% #. mGRF.HypParmOpt.Type - corresponding to the different ways to input the hyper-parameters of the Gaussian Random Field
% #. mGRF.NIdev.Type - corresponding to the type of non-ideal deviatons to be slimulated
% 
%
%
% Args:
%   meshCoord               : coordinates of all mesh nodes an nNodes X 3 matrix
%   keyPointsID             : node ID of all the key points
%   meshStiffMat            : The stiffness matrix for the whole mesh
%   nSample                 : Number of non-ideal part instances to be simulated
%   mGRF.HypParmOpt.Type    :'measData' | 'manual' | 'load'
%   Options_specific_to_'measData'
%   mGRF.HypParmOpt.devPatterns: nInstances x nNodes matrix of non-ideal  deviations
%   Options_specific_to_'manual'
%   mGRF.HypParmOpt.sn      : noise standard dev
%   mGRF.HypParmOpt.lScale  : characteristic length scale, 3X1 vector for x,yand z directions
%   mGRF.HypParmOpt.sf      : scaling factor (set to 1 by default)
%   Options_specific_to_'file'
%   mGRF.HypParmOpt.File    : name of the .mat file containing optimised hyper parameter values for a batch of deviations%
%   mGRF.NIdev.Type         : 'dent'|'flange'|'bending'|'formErr', String defining the type of non-ideal deformatios
%   mGRF.NIdev.Probability	: confidence value that max form error is less than specified value (between 0-1)
%   mGRF.NIdev.MaxFormError : Maximum specified form error
%   mGRF.NIdev.NBasis       : Number of basis to use for interpolating the covariance matric for whole mesh
%   Options_specific_to_'bending'
%   mGRF.NIdev.Bending.ID 	: Vector of length 2 representing two nodes forming the bending axis
%   mGRF.NIdev.Bending.Theta: Bending angleabout the axis in degrees
%   Options_specific_to_'dent'|'flange'_local_deformations 
%   mGRF.NIdev.Local.ID 	: vector containing node IDs of all nodes being manipulated
%   mGRF.NIdev.Local.Dev    : nID X 1, vector of local deformation of key points
%
% Returns:
%   dev - The nNodes X nSamples matrix of non-ideal part deviations
%
% .. Note::
%       The function depends on `gp Toolbox`_ and should be in the matlab path before
%       the :func:`getMgrfDev` is called.
%
% .. _gp Toolbox: http://www.gaussianprocess.org/gpml/code/matlab/doc/index.html

%% 
nNode	=size(meshCoord,1);
xKey    =meshCoord(keyPointsID,:);

%% hyperParm Optimisation

switch mGRF.HypParmOpt.Type
    
    case 'measData'        
        [~,allNoiseVar,allParm]=getAvgKrigParmSpace(mGRF.HypParmOpt.devPatterns,meshCoord,keyPointsID);           
        sn       =mean(exp(allNoiseVar)); % noise standard dev
        lScale   =mean(exp(allParm(1:3,:)),2);% characteristic length scale in length unit of the mesh
        sf       =mean(exp(allParm(4,:)));
        [covMatern,hyp,likfunc,m0]=setCovStruct('user',sn,lScale,sf);
        
    case 'manual'
        sn       =mGRF.HypParmOpt.sn; % noise standard dev
        lScale   =mGRF.HypParmOpt.lScale;% characteristic length scale
        sf       =mGRF.HypParmOpt.sf; % scaling factor
        [covMatern,hyp,likfunc,m0]=setCovStruct('user',sn,lScale,sf);
        
    case 'loadFrmFile'
        load(mGRF.HypParmOpt.File);
        sn       =mean(exp(allCovHyp.lik)); % noise standard dev
        lScale   =mean(exp(allCovHyp.cov(1:3,:)),2);%rand(D,1);% characteristic length scale
        sf       =mean(exp(allCovHyp.cov(4,:)));
        [covMatern,hyp,likfunc,m0]=setCovStruct('user',sn,lScale,sf);
        
    case 'default'
        % Set to the following default values
        % sn       =0.001; % noise standard dev
        % lScale   =[20;20;10];%rand(D,1);% characteristic length scale
        % sf       =1;           % latent function standard dev
        [covMatern,hyp,likfunc,m0]=setCovStruct('default');
        
end
        


%% mean deviation calculation

switch mGRF.NIdev.Type
    case {'dent', 'flange'}
        %  flange or dent
        id=mGRF.NIdev.Local.ID;
        [mpredictedD, ~] = gp(hyp, @infExact, m0, covMatern, likfunc,  meshCoord(id,:), mGRF.NIdev.Local.Dev, meshCoord);
        mpredicted=mpredictedD;
        
    case 'bending'
        id=mGRF.NIdev.Bending.ID;
        % deviations for  bending
        [perpDist]=keyPointDistances(meshCoord(id(1),:),meshCoord(id(2),:), xKey,[0,0,0] );
        ytB=abs(perpDist).*((mGRF.NIdev.Bending.Theta*pi/180));% for bending of theta degrees
        [mpredictedB, ~] = gp(hyp, @infExact, m0, covMatern, likfunc, xKey, ytB, meshCoord);
        mpredicted=mpredictedB;
        
end

%% Form error calculation
nBasis			=mGRF.NIdev.NBasis;%size(Ktest,1)

switch mGRF.NIdev.Type
    
    case 'formErr'
        
        % scale RF by changing sf the scaling factor
        p1			=1-(1-mGRF.NIdev.Probability)/2; % considering tail
        mu			=0; %std gaussian mean
        sigStd		=1;% std gaussian stdDev
        zc          =icdf('normal',p1,mu,sigStd); % z for given p
        sigTrans    =mGRF.NIdev.MaxFormError/zc; % sigma(standard dev) for which the probaility of having
        % form error greater than the given value (fe) is p
        hyp.cov(end)	=log(sigTrans);
        %
        Ktest			=feval(covMatern{:}, hyp.cov, xKey);
        
        % interpolating for all points
        [U,S,~]	=eigs(Ktest,nBasis);
        EV              =diag(S);        
        uBoundary		=zeros(nNode,size(U,2));
        uBoundary(keyPointsID,:)=U;
        
        % settign the stiffness matrix for particular interpolation
        L_sym               = meshStiffMat;
        L_sym(keyPointsID,:)=0;
        
        for i  =1:length(keyPointsID)
            L_sym(keyPointsID(i),keyPointsID(i))	=1;
        end
        % interpolated basis of covariance function for the whole mesh
        uInterp	=L_sym\uBoundary;  
        % sampling correlated form error
        corX2   =(uInterp*diag(sqrt(EV)))*randn(nBasis,nSample);% is already scaled        
        dev     =corX2;
        
        
    case {'dent','flange','bending'}
        
        % scale RF by changing sf the scaling factor
        p1			=1-(1-mGRF.NIdev.Probability)/2; % considering tail
        mu			=0; %std gaussian mean
        sigStd		=1;% std gaussian stdDev
        zc          =icdf('normal',p1,mu,sigStd); % z for given p
        sigTrans    =mGRF.NIdev.MaxFormError/zc; % sigma(standard dev) for which the probaility of having
        
        % form error greater than the given value (fe) is p
        hyp.cov(end)	=log(sigTrans);
        Ktest			=feval(covMatern{:}, hyp.cov, xKey);
        % interpolating for all points        
        [U,S,~]	=eigs(Ktest,nBasis);
        EV              =diag(S);        
        uBoundary		=zeros(nNode,size(U,2));
        uBoundary(keyPointsID,:)=U;        
        % settign the stiffness matrix for particular interpolation
        L_sym			= meshStiffMat;
        L_sym(keyPointsID,:)=0;
        for i  =1:length(keyPointsID)
            L_sym(keyPointsID(i),keyPointsID(i))	=1;
        end
        % interpolated basis of covariance function for the whole mesh
        uInterp			=L_sym\uBoundary;
        % sampling correlated form error
        corX2   =(uInterp*diag(sqrt(EV)))*randn(nBasis,nSample);% is already scaled
        
        % conditioning by krigging
        errToKrig		=corX2(id,:); 
        krigEstimate    =zeros(nNode,nSample);
        for i=1:nSample
            krigEstimate(:,i)	=gp(hyp, @infExact, m0, covMatern, likfunc,  meshCoord(id,:), errToKrig(:,i), meshCoord);
        end        
        X1          =repmat(mpredicted,1,nSample);        
        condSim		=X1+corX2-krigEstimate;        
        dev         =condSim;
        
    otherwise
        disp('Undefined non-ideal deformation type specified, empty deviation returned')
        dev=[];
        return
end

end