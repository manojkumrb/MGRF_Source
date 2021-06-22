function Zp=getProcessWindowStochastic(Xp, Yp, varXId, constX, constXId, polymodel, idcon)

% varXId: id related to variables
% constXId: id related to constants

%--
polymodell=polymodel(idcon);

%--------------------
Zp=ones(size(Xp));

for k=idcon
     for i=1:size(Xp,2)
         for j=1:size(Xp,1)
             
             n=2+length(constXId);
        
             x=zeros(1,n);
             x(varXId)=[Xp(i,j) Yp(i,j)];
             x(constXId)=constX;
                     
             Zp(i,j)=Zp(i,j)*evalPolyFit(polymodell{k}, x);
         end 
     end
end

% make sure probability is between [0 1]
Zp(Zp<0)=0.0;
Zp(Zp>1)=1.0;

