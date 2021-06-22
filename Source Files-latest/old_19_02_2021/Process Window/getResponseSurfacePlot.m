function Zp=getResponseSurfacePlot(Xp, Yp, varXId, constXId, constX, polymodel)

% varXId: id related to variables
% constXId: id related to constants
% constX: constant values
% polymodel: model

%--------------------
Zp=zeros(size(Xp));
for i=1:size(Xp,1)
    for j=1:size(Xp,2)
    
        n=2+length(constXId);
        
        x=zeros(1,n);
        x(varXId)=[Xp(i,j) Yp(i,j)];
        x(constXId)=constX;
        
        Zp(i,j)=evalPolyFit(polymodel, x);
                        
    end
end
