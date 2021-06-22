function c=constraintsOptFnc(x, opt)

% x: decision variables
% opt: solver settings

% c: list of constraints

% NOTICE: constraints are assumed as follows:
    
    % disequalities
    % g(i)<=0
    
    % equalities
    % h(i) - h0 = 0; it is converted to 2 disequalities
        % h(i) - h0 - tol <=0 (h(i) - h0 <=tol)
        % -h(i) + h0 - tol <=0 (h(i) - h0 >=-tol)

%--
c=[];

% no. of variables
nVars=opt.Solver.nVars;

% boundary constraints (if any)
lb=opt.Constraints.Bound.Lower;
ub=opt.Constraints.Bound.Upper;

count=1;
if opt.Constraints.EnableBnd
    if nVars==length(lb)
      for i=1:length(lb)    
        c(count)=-x(i)+lb(i);
        count=count+1;
      end
    end

    if nVars==length(ub)
      for i=1:length(ub)
        c(count)=x(i)-ub(i);
        count=count+1;
      end
    end
end

% add here your customised constraints



