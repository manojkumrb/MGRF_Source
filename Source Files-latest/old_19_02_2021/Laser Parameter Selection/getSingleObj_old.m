function f = getSingleObj(X, polymodel, flag)

% X: input parameters (1xp - p=no. of parameters)
% polymodel: poly model

% f: poly function 

if strcmp(flag,'max')
    f =  -evalPolyFit(polymodel, X);
elseif strcmp(flag,'min')
    f =  evalPolyFit(polymodel, X);
end

