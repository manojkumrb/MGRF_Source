function [c ce] = getConstraint(tX, data, idopt, varids_obj, varids_con)

% X: input parameters (1xp - p=no. of parameters)
% regmodel: regression model
% optmodel: optimisation model
% varids_obj=[input id, raw data id]
% varids_con=[input id, raw data id, constant value, function/constraint id]

% c: constraints
% ce: equalities

% get equations
ide=data.database.Optimisation{idopt}.Constraint.Regressione;
Ae=data.database.Optimisation{idopt}.Constraint.Ae;
be=data.database.Optimisation{idopt}.Constraint.be;
   
ce=get_constraints_equations(tX, data, ide, Ae, be, varids_obj, varids_con);

% get constraints
idc=data.database.Optimisation{idopt}.Constraint.Regressionc;
Ac=data.database.Optimisation{idopt}.Constraint.Ac;
bc=data.database.Optimisation{idopt}.Constraint.bc;
    
c=get_constraints_equations(tX, data, idc, Ac, bc, varids_obj, varids_con);

%------------------
%------------------
function c=get_constraints_equations(tX, data, id, A, b, varids_obj, varids_con)

n=size(varids_con,1);

c=[];

m=length(id); % number of constraints
    
for j=1:m % loop over constraints
    
    % allocate design variables
    X=[];
    for i=1:n
        if varids_con(i,4)==j+1
            if varids_con(i,2)==varids_obj(1,2) % same as per design variables
                X=[X, tX( varids_con(i,1) )];
            else
                X=[X, varids_con(i,3)];
            end 
        end
    end
    
    regmodel=data.database.Regression{id(j)};
    
    fmodel=regmodel.Fitting;
    
    if fmodel==1 % polynomial
    
        polymodel.ModelTerms=regmodel.Model.ModelTerms;
        polymodel.Coefficients=regmodel.Model.Coefficients;

        t= A(j) * evalPolyFit(polymodel, X) + b(j);

        c=[c t];
        
    else
        
    %--------------------------
    % add additional regression models
    %--------------------------
    
    end
end

