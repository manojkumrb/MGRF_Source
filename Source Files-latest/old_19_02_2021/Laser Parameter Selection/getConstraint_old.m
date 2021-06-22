function [c, ce] = getConstraint_old(X, polymodel, con)

% X: input parameters (1xp - p=no. of parameters)
% polymodel: poly model
% con{id}.A 
% con{id}.b
%     con{id}.A * KPI + con{id}.b <=0

% f: poly function

nc=length(con);

c=[];
ce=[];
for i=1:nc
    
    n=length(con{i}.A);
    
    for j=1:n
        t= con{i}.A(j) * evalPolyFit(polymodel{i}, X) + con{i}.b(j);
        
        c=[c t];
    end
    
end
