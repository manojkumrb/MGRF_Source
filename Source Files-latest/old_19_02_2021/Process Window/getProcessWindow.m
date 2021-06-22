function Zp=getProcessWindow(Xp, Yp, varXId, constXId, constX, polymodel, con, idcon)

% varXId: id related to variables
% constXId: id related to constants
% constX: constant values
% polymodel: model

% con: constraints
% con{id}.Type: ">=", "<="
% con{id}.b
%     con{id}.Type{i} of con{id}.b(i)

% idcon: list of constraint (true/false)

%--
nc=length(idcon);
listcon=[];
for i=1:nc
    if idcon(i)
        listcon=[listcon, i];
    end
end

nc=length(listcon);
polymodell=cell(1,nc);
conl=cell(1,nc);
for i=1:nc
    polymodell{i}=polymodel{listcon(i)};
    conl{i}=con{listcon(i)};
end

%--------------------
Zp=zeros(size(Xp));
for i=1:size(Xp,1)
    for j=1:size(Xp,2)
    
        n=2+length(constXId);
        
        x=zeros(1,n);
        x(varXId)=[Xp(i,j) Yp(i,j)];
        x(constXId)=constX;
        
        cij=1;
        for cc=1:length(conl)
            zij=evalPolyFit(polymodell{cc}, x);
            cij=cij*zij; 
            for k=1:length(conl{cc}.b)
                 ck=conl{cc}.b(k);

                 if strcmp(conl{cc}.Type{k},'<=')
                    if zij>ck
                        cij=cij*nan;
                    end
                 elseif strcmp(conl{cc}.Type{k},'>=')
                    if zij<ck
                        cij=cij*nan;
                    end
                 end
            end
        end
        
        Zp(i,j)=cij; % update constraint
               
    end
end



                    % 
                    % 
                    % 
                    % function Zp=getProcessWindow(Xp, Yp, varXId, constXId, constX, polymodel, con, idcon)
                    % 
                    % % varXId: id related to variables
                    % % constXId: id related to constants
                    % % constX: constant values
                    % % polymodel: model
                    % 
                    % % con: constraints
                    % % con{id}.Type: ">=", "<="
                    % % con{id}.b
                    % %     con{id}.Type{i} of con{id}.b(i)
                    % 
                    % % idcon: list of constraint (true/false)
                    % 
                    % %--
                    % nc=length(idcon);
                    % listcon=[];
                    % for i=1:nc
                    %     if idcon(i)
                    %         listcon=[listcon, i];
                    %     end
                    % end
                    % 
                    % nc=length(listcon);
                    % polymodell=cell(1,nc);
                    % conl=cell(1,nc);
                    % for i=1:nc
                    %     polymodell{i}=polymodel{listcon(i)};
                    %     conl{i}=con{listcon(i)};
                    % end
                    % 
                    % %--------------------
                    % Zp=zeros(size(Xp));
                    % for i=1:size(Xp,1)
                    %     for j=1:size(Xp,2)
                    %     
                    %         n=2+length(constXId);
                    %         
                    %         x=zeros(1,n);
                    %         x(varXId)=[Xp(i,j) Yp(i,j)];
                    %         x(constXId)=constX;
                    %         
                    %         cij=1;
                    %         for cc=1:length(conl)
                    %             for k=1:length(conl{cc}.b)
                    %                  ck=conl{cc}.b(k);
                    %                  
                    %                  zij=evalPolyFit(polymodell{cc}, x);
                    %                  if strcmp(conl{cc}.Type{k},'<=')
                    %                     if zij>ck
                    %                         cij=cij*0;
                    %                     end
                    %                  elseif strcmp(conl{cc}.Type{k},'>=')
                    %                     if zij<ck
                    %                         cij=cij*0;
                    %                     end
                    %                  end
                    %             end
                    %         end
                    %         
                    %         Zp(i,j)=cij; % update constraint
                    %                
                    %     end
                    % end

