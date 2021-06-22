function [hyp,allNoiseVar,allParm]=getAvgKrigParmSpace(devPatterns,nodeCoord,keyPointID)
% Function to find average optiaml covariance function parameters describing spatial pattern of non-ideal part deviations
%
% Args:
%   devPatterns: nInstances x nNodes matrix of non-ideal  deviations
%   nodeCoord: coordinates of mesh nodes, a nNodes x 3 matrix
%   keyPointID: a vector containing key points node ids. vector of length = nKeyPoints
% 
%
% Returns:
%   **hyp**   - average of optimum parameters in format required by the gp toolbox
% 
%   - **allNoiseVar, allParam** -optimum value of parameters for individual deviation sets
%   - **devPatterns** - Simulated or measured node deviations for the whole part
%
%
% .. note:: 
%   
%   - depends on gpr toolboxpath
%   - for now gives only provides matern covariance funciton parameters as output


% mean and covariance setting
nSets			= size(devPatterns,1);
allNoiseVar		= zeros(1,nSets);
allParm			= zeros(4,nSets);
devPatKey		= devPatterns(:,keyPointID);
for i=1:nSets
	m0              ={'meanZero'};  hyp.mean = [];                      % no hyperparameters are needed
	sn              =0.001;                                             % noise standard dev
	likfunc         ={'likGauss'};										% gaussian likelihood
	hyp.lik			= log(sn);                 
	sf              =1;                                                 % latent function standard dev
	lScale          =[60;50;100]*rand(1);                               %rand(D,1);% characteristic length scale
	covMatern       ={@covMaternard,5};  hypMat=log([lScale;sf]);      % Matern class d=5
	hyp.cov			=hypMat;
	hyp             =minimize(hyp, @gp, -300, @infExact, m0, covMatern, likfunc, nodeCoord(keyPointID,:), devPatKey(i,:)'); % for regular covariance calculation
	
	
	%% for approximate cov function calculations
	% xLimited        =sampleNodesDomain(fem,domainID,nodeLimit);
	% covFuncI        ={@covFITC, csu,xLimited};
	% log marginal likelihood optimization
	% hyp = minimize(hyp, @gp, -50,  @infFITC, m0, covFuncI, likfunc,  x, devSmooth(sourcePattern,:)); % for covFITC
	
	%%
	allNoiseVar(1,i)	= hyp.lik;
	allParm(:,i)		= hyp.cov;
	
	
end

hyp.lik		=log(mean(exp(allNoiseVar)));
hyp.cov		=log(mean(exp(allParm),2));




end