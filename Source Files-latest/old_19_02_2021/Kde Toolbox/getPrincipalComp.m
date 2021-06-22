% get PCA decomposition
function data=getPrincipalComp(data)

% data.mu=[]; % [1, Nn] - average vector
% data.Dm=[]; % [nsample, Nn] - D-mu
% data.phi=[]; % [Nn, Nt] - load vector
% data.sigma=[]; % [Nt, 1] - principal variance vector
% data.score=[]; % [Nt, nsample] - score vector
% data.res=[]; % [Nn, nsample] - residual vector

% 
[nsample, ndim]=size(data.D);

% STEP 1: get mean
data.mu=mean(data.D,1);

data.Dm=data.D - repmat(data.mu,nsample,1);

% STEP 2: build Z=1/sqrt(nsample-1) * (X - mu);
Z=1/sqrt(nsample-1) * data.Dm;

% STEP 3: get eigenvectors and eigenvalues (USE SVD DECOMPOSITION)
if ndim>=nsample
    [~,s,V] = svd(Z,0); % use "eco" decomposition... only the first "nsample" vectors are collected
else
    [~,s,V] = svd(Z);
end

% get eigenvalues (square of singular value). These correspond to variances
lamda=diag(s).^2;

% STEP 4: get main sources of variance
lamdacum=lamda./sum(lamda);

id=find(lamdacum>=data.thold);

%--
data.sigma=lamda(id);
data.phi=V(:,id);

% get additional outputs
data.score=data.phi'*data.Dm';

data.res=data.Dm'-data.phi * data.score;
