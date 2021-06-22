function f = getSingleObj(X, regmodel, flag)

% X: input parameters (1xp - p=no. of parameters)
% regmodel: regression model
% flag: "maximize"; "minimize"; "evaluate"

% f: evaulate function at X point

fmodel=regmodel.Fitting;

if fmodel==1 % polynomial
    
    polymodel.ModelTerms=regmodel.Model.ModelTerms;
    polymodel.Coefficients=regmodel.Model.Coefficients;
    
    if strcmp(flag,'maximize')
        f =  -evalPolyFit(polymodel, X);
    elseif strcmp(flag,'minimize') || strcmp(flag,'evaluate')
        f =  evalPolyFit(polymodel, X);
    end

else
    
    %--------------------------
    % add additional regression models
    %--------------------------
    
end