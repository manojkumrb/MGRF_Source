% assembly stiffness matrix
function fem=femAssemblyStiffness(fem)

% read # of dofs
nTot=fem.Sol.nDoF;

%-----------------------------------
% STEP 1a: assemblying equations
disp('Assemblying sparse pattern:...')

[irow,...
     icol,...
     Xk,...
     ~]=getAssemblySparsityStiffness(fem); %# OK MEX
 
 % STEP 1b: get assembly matrix
disp('Assemblying sparse stiffness matrix:...')

fem.Sol.Kast.Ka=femSparse(irow,...
                           icol, ...
                           Xk, ...
                           nTot, nTot);