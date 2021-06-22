% augmented fitness function
function P=augFittnessOptFnc(x, opt)

% x: decision variables
% opt: solver settings

% f: fittness value

% read fittness function
P=0;

if isempty(opt.Fittness.Fnc.F)
    return
end
P=opt.Fittness.Fnc.F(x);

% add penalty (if needed)
if opt.Constraints.Enable
    if isempty(opt.Constraints.Fnc.Phi)
        return
    end
    P = P + opt.Constraints.Fnc.Phi(x, opt);
end
