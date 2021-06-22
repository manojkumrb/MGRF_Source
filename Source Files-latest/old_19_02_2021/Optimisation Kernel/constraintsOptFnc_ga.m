function [c, ce]=constraintsOptFnc_ga(x, opt)

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
tol=opt.Constraints.Tol;

% add here your customised constraints
c(1)=x(1)+2*x(2)-1;
c(2)=-2*x(1)-x(2)+(1-tol);
c(3)=2*x(1)+x(2)-(1+tol);

ce=[];
