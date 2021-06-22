% define penalty function
function p=penaltyOptFnc(x, opt)

% x: decision variables
% opt: solver settings

% p: penalty function

%---
tol=opt.Constraints.Tol;

% init
p=0;

% raed penalty stiffness
pn=opt.Constraints.Penalty.Stiffness;

if ~opt.Constraints.Enable
    return
end

% calculate constraints
c=opt.Constraints.Fnc.C(x);

% penalise those constraints which violates the conditions  (c(i)>0)
nc=length(c);
for i=1:nc
    if c(i)>tol
        p = p + pn*c(i)^2; % quadratic penalisation
    end
end

