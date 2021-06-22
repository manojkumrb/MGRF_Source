% solve linear set if equations
function fem=femLinearSolve(fem)

% solver type:
tsolver=fem.Options.Solver.Method;

% read # of dofs
ndof=fem.Sol.nDoF;

% tot. # of dofs
if strcmp(tsolver,'lagrange')
    
    nSpc=fem.Sol.nLSPC; 
    nMpc=fem.Sol.nLMPC; 
    nCt=fem.Sol.nLCt; 

    nTot=ndof+nSpc+nMpc+nCt; % augmented matrix
elseif strcmp(tsolver,'penalty')
    
    nTot=ndof; % work just on primary variables
else
    
    error('FEMP (Linear Solver): Constraint handling method not recognised!') 
end

%-----------------------------------
% STEP 1a: assemblying equations
disp('     Writing Working Set Equations:...')

[irow,...
     icol,...
     Xk,...
     Fmod]=getAssemblySparsityStiffness(fem); %# OK MEX
 
 % STEP 1b: get assembly matrix
 disp('     Assemblying Working Set Equations:...')
 
 Ka=femSparse(irow,...
               icol, ...
               Xk, ...
               nTot, nTot);

% store assembled stiffness matrix, "Ka"
storeKa=fem.Options.Solver.StoreAssembly;           
if storeKa     
    fem.Sol.Kast.Ka=Ka;
end 

 % STEP 2: solve model based on UMFPACK architecture

 % release memory before LU decomposition
 clear irow icol Xk;
 
 lsol=fem.Options.Solver.LinearSolver;
 if strcmp(lsol,'umfpack')
    
    disp('     Solving Working Set Equations (UMFPACK SOLVER):...')
    fem.Sol.U=umfpack2(Ka,'\',Fmod);
 elseif strcmp(lsol,'cholmod')
    
    disp('     Solving Working Set Equations (CHOLMOD SOLVER):...')
    fem.Sol.U=cholmod2(Ka,Fmod);
elseif strcmp(lsol,'bs')
    
    disp('     Solving Working Set Equations (MatLAB "BACK SLASH" SOLVER):...')
    fem.Sol.U=Ka\Fmod;
    
    elseif strcmp(lsol,'pardiso')
    
    disp('     Solving Working Set Equations (PARDISO SOLVER):...')
    fem.Sol.U=call_pardiso_symm_pos_def(tril(Ka), Fmod);
 else
     
    error('FEMP (Linear Solver): Linear Solver not recognised!') 
 end
  
 if any(isnan(fem.Sol.U))
     fem.Sol.U(:)=0;
     warning('Residuals are greater than allowed tolerance! Default solution was set to zero!')
 end
 
 % save residuals
 fem.Sol.res=Ka*fem.Sol.U-Fmod;
 
 % save reaction forces
 if strcmp(tsolver,'lagrange')
    fem.Sol.RLamda=-fem.Sol.U(ndof+1:end); % "-" for reaction force
 end
 



