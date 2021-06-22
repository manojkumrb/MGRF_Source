function [covMatern,hyp,likfunc,m0]=setCovStruct(type,varargin)
% A function to help set options of the mean and covariance fuction
% according to gp toolbox. Matern covariance function is used as defalult
% throughout
%
% Args:
%  type     : 'default'|'user' string
%  If_type_is_'user'_three_vectors_are_expected
%  sn       : 1x1 scalar, noise standard dev (makes surface points pass through key points if zero). Default is 0.001
%  lscale   : 3x1 characteristic length scale in x, y and z respectively, default is 20, 20, 10 mm
%  sf       : 1x1 scalar, latent function standard dev or output scaling factor, Default is 1
%
% Returns:
%  Covariance function parameters in syntax compatible with gp toolbox
 


m0 = {'meanZero'};  hyp.mean = [];      % no hyperparameters are needed
likfunc = {'likGauss'};  % gaussian likelihood
covMatern = {@covMaternard,5};  


if strcmp(type,'default')
   sn       =0.001; % noise standard dev
   lScale   =[20;20;10];%rand(D,1);% characteristic length scale    
   sf       =1;           % latent function standard dev
   
elseif strcmp(type,'user') && nargin==4
    sn      =varargin{1};
    lScale  =varargin{2}; % characteristic length scale    
    sf      =varargin{3}; % latent function standard dev
    
else
    error('undefined/ wrong input type');
    return;
end

  
hyp.lik = log(sn);  % gaussian likelihood
hypMat=log([lScale;sf]); % Matern class d=5
% csu = {'covSum',{covMatern}}; 
% hypsu = hypMat; % noise linear, quadratic, periodic
hyp.cov=hypMat;

end