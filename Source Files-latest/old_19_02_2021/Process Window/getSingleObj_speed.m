function f = getSingleObj_speed(X, flag)

% X: input parameters (1xp - p=no. of parameters)
%   X=[speed, gap, power,...]

% f: speed

if strcmp(flag,'max')
    f = - X(1); 
elseif strcmp(flag,'min')
    f = X(1); 
end
