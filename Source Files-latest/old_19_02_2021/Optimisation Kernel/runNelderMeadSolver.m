%- run NelderMead solver
function opt=runNelderMeadSolver(opt)

%- INPUT:
% opt: options (see initialisation)

%- OUTPUT:
% opt: updated "opt" structure 
    % opt.Solution.Flag: 0,1,2 => 0=solution found and feasible; 1=max iterations reached; 2=no feasible solution

%----------
% Notice: constrained handled by penalty method
%----------

%--------------------------
MaxIter=opt.Solver.MaxIter; 

%--------------------------
x0=opt.Solver.X0;

%--------------------------
fobj=opt.Fittness.Fnc.P;

% save log
if opt.Solution.History.Enable
   opt.Solution.History.Fittness.Fnc=[opt.Solution.History.Fittness.Fnc, fobj(x0, opt)];
end

N = length(x0);

S = eye(N);
for i = 1:N % repeat the procedure for each subplane
    
    inext = i + 1;
    if inext > N
        inext = 1;
    end
    
    abc = [x0; x0 + S(i,:); x0 + S(inext,:)]; % each directional subplane
    fabc = [fobj(abc(1,:),opt); fobj(abc(2,:),opt); fobj(abc(3,:),opt)];

    [xsol, fsol, nIter, opt] = callNelderMead(fobj, abc, fabc, MaxIter, opt);
        
    x0=xsol;
    if N < 3
        break
    end % No repetition needed for a 2-dimensional case
    
end

% number of iterations performed
nIter=MaxIter-nIter;

if nIter>MaxIter
    fprintf('       (Warning) max no. of iterations reached: %g\n', MaxIter);
else
    fprintf('       Solution found after %g iterations\n', nIter);
end


% save back
opt.Solution.X=xsol;
opt.Solution.Fnc.Fitness=fsol;

if opt.Constraints.Enable
    opt.Solution.Fnc.Constraints=opt.Constraints.Fnc.C(xsol);
end

opt.Solution.NIter=opt.Solution.NIter+nIter;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% solve uncostrained non-linear problem by means of "NelderMead" procedure
function [xsol, fsol, nIter, opt] = callNelderMead(fobj, abc, fabc, k, opt)

%- INPUT:
%- abc: [3xnvar] vector (triangle points)
%- fabc:[1x3] value of obj function calculated over the triangle points
%- TolX/TolFun: point and function tolerance
%- k: counter for maximum number of iterations

%- OUTPUT:
%- xsol: solution vector
%- fsol: function at solution vector

%--------------------------
TolX=opt.Solver.TolX;
TolFun=opt.Solver.TolFun;

nIter=k;
    
[fabc,abc]=sortNelder(fabc, abc);
a=abc(1,:);
b=abc(2,:);
c=abc(3,:);

fa = fabc(1); fb = fabc(2); fc = fabc(3);
fba = fb - fa;
fcb = fc - fb;

% call the Nelder-Mead alghoritm
if k <= 0 || abs(fba) + abs(fcb) <= TolFun || norm(b - a) + norm(c - b) <= TolX
    xsol = a;
    fsol = fa;
    
    % save log
    if opt.Solution.History.Enable
       opt.Solution.History.Fittness.Fnc=[opt.Solution.History.Fittness.Fnc, fa];
    end
    
    return % convergency criteria
end

    m = (a + b)/2;
    e = 3*m - 2*c;
    fe = fobj(e,opt);
    if fe < fb
        c = e;
        fc = fe;
    else
        r = (m+e)/2;
        fr = fobj(r,opt);
        if fr < fc
            c = r;
            fc = fr;
        end
        if fr >= fb
        s = (c + m)/2;
        fs = fobj(s,opt);
            if fs < fc
                c = s;
                fc = fs;
            else
                b = m;
                c = (a + c)/2;
                fb = fobj(b,opt);
                fc = fobj(c,opt);
            end
        end
    end
    
    % save log
    if opt.Solution.History.Enable
       opt.Solution.History.Fittness.Fnc=[opt.Solution.History.Fittness.Fnc, fa];
    end
    
    % call the procedure in a recursive way
    [xsol,fsol,nIter, opt] = callNelderMead(fobj, [a;b;c],[fa fb fc], k - 1,opt);
   
% sorting routine
function [fabc,abc]=sortNelder(fabc,abc)

for i=1:length(fabc)-1
    for j=i+1:length(fabc)
        
        if fabc(j)<=fabc(i)
            temp=fabc(j);
            fabc(j)=fabc(i);
            fabc(i)=temp;
            
            temp=abc(j,:);
            abc(j,:)=abc(i,:);
            abc(i,:)=temp;
        end
        
    end
end