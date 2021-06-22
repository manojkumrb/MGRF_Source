% solve optimisation problem
function opt = runOptimisationSolver(opt)

%- INPUT:
% opt: options (see initialisation)

%- OUTPUT:
% opt: updated "opt" structure 
    % opt.Solution.Flag: 0,1,2 => 0=solution found and feasible; 1=max iterations reached; 2=no feasible solution

%----------
% Notice: constrained handled by penalty method
%----------

% init solution
%----------------------
opt.Solution.Flag=2; % 0=solution found and feasible; 1=max iterations reached; 2=no feasible solutions
opt.Solution.Fnc.Fitness=0;
opt.Solution.Fnc.Constraints=[];
opt.Solution.History.Enable=true;
opt.Solution.NIter=0;
%----------------------

typesolver=opt.Solver.Type{opt.Solver.Type{1}+1};

fprintf('Solving optimisation model, please wait...\n');

%--
if opt.Constraints.Enable && opt.Constraints.Penalty.Adaptive.Enable % run adaptive solver
    
    fprintf('    Running ADAPTIVE penalty method...\n');
    
    %--
    count=1;
    while true % repeat until convergency
        
       fprintf('     Penalty refinement %g\n', count);
        
       opt.Constraints.Penalty.Stiffness=opt.Constraints.Penalty.Stiffness*opt.Constraints.Penalty.Adaptive.Fnc(opt);

       % run local solver
       if strcmp(typesolver,'NelderMead')
            opt = runNelderMeadSolver(opt);
       elseif strcmp(typesolver,'GA')
            opt = runGASolver(opt);
       else
           
           % add here any other solver
           
       end

       xsol=opt.Solution.X;
       if opt.Constraints.Fnc.Phi(xsol, opt)<=opt.Constraints.Tol
           fprintf('     Solution found after %g iterations\n', count);
           opt.Solution.Flag=0;
           break
       end

       if count>=opt.Constraints.Penalty.Adaptive.MaxIter      
           fprintf('     (Warning) max no. of iterations reached: %g\n', opt.Constraints.Penalty.Adaptive.MaxIter);
           opt.Solution.Flag=1;
           break
       end

       count=count+1;

       opt.Solver.X0=xsol;
    end
    %--
    
else % run static solver
    
    fprintf('    Running STATIC penalty method...\n');
    
    % run local solver
    if strcmp(typesolver,'NelderMead')
        opt = runNelderMeadSolver(opt);
    elseif strcmp(typesolver,'GA')
        opt = runGASolver(opt);
    else

       % add here any other solver

    end
    
end

% check solutions and feasibility
flag=true;
if opt.Constraints.Enable
    xsol=opt.Solution.X;
    c=opt.Constraints.Fnc.C(xsol);

    for i=1:length(c)
        if c(i)>opt.Constraints.Tol
            flag=false;
            break
        end  
    end
end
     
if flag
    fprintf('     (Message) Solution found in the feasible region\n');
    opt.Solution.Flag=0;
else
    fprintf('     (Warning) No feasible solution found\n');
    opt.Solution.Flag=2;
end


