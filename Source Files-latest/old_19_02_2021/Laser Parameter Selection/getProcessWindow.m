function Zp=getProcessWindow(Xp, Yp, varXId, constX, constXId, polymodel, con, idcon)

% varXId: id related to variables
% constXId: id related to constants

%--
nc=length(idcon);

polymodell=cell(1,nc);
conl=cell(1,nc);
for i=1:nc
    polymodell{i}=polymodel{idcon(i)};
    conl{i}=con{idcon(i)};
end

%--------------------
Zp=zeros(size(Xp));
for i=1:size(Xp,1)
    for j=1:size(Xp,2)
    
        n=2+length(constXId);
        
        x=zeros(1,n);
        x(varXId)=[Xp(i,j) Yp(i,j)];
        x(constXId)=constX;
        [c, ~] = getConstraint_old(x, polymodell, conl);
        
        if ~isempty(c)
            if all(c<=0)
                Zp(i,j)=1.0; % satisfied
            else              
                Zp(i,j)=0.0; % not satistied
            end
        end
        
    end
end