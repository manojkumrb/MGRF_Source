% assembly mass matrix
function fem=femAssemblyMass(fem)

% read # of dofs
nTot=fem.Sol.nDoF;

%-----------------------------------
% STEP 1a: assemblying equations
disp('Assemblying sparse pattern:...')

[irow,...
     icol,...
     Xk]=getAssemblySparsityMass(fem); %# OK MEX
 
 % STEP 1b: get assembly matrix
disp('Assemblying sparse mass matrix:...')

fem.Sol.Kast.Ma=femSparse(irow,...
                           icol, ...
                           Xk, ...
                           nTot, nTot);