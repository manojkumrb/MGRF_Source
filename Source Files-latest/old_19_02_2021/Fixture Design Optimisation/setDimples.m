% set dimple layout
function data = setDimples(data,...
                            idst, paraidt,...
                            searchDist, deltad, hdimple, Ldimple,...
                            dimpleopt)

% data: input data
% idst: stitch id
% paraidt: parameter id
% searchDist: searching distance
% deltad: distance of dimple from stitch
% hdimple: dimple height
% Ldimple: dimple laser track
% dimpleopt: 1/2/3/4/5. Define the dimple layout option

if dimpleopt==6
    return
end

% get field
[f, flag]=retrieveStructure(data, 'Stitch', idst);

if ~flag
    return
end

%--
type=f.Type{1};

if type==1 % linear stitch

    % initialised fields
    if dimpleopt==1

          % read counter
          if isfield(data.Input,'Dimple')
                count(1)=length(data.Input.Dimple)+1;
                data.Input.Dimple(count(1))=data.Input.Dimple(count(1)-1);

                data=resetField(data, count(1));
           else
                count(1)=1;
                data.Input.Dimple(count)=initInputDatabase('Dimple');
          end

          count(2)=count(1)+1;
          data.Input.Dimple(count(2))=data.Input.Dimple(count(1));
          data=resetField(data, count(2));

    elseif dimpleopt==2

          % read counter
          if isfield(data.Input,'Dimple')
                count(1)=length(data.Input.Dimple)+1;
                data.Input.Dimple(count(1))=data.Input.Dimple(count(1)-1);
                data=resetField(data, count(1));
           else
                count(1)=1;
                data.Input.Dimple(count)=initInputDatabase('Dimple');
          end

          count(2)=count(1)+1;
          data.Input.Dimple(count(2))=data.Input.Dimple(count(1));
          data=resetField(data, count(2));

          count(3)=count(2)+1;
          data.Input.Dimple(count(3))=data.Input.Dimple(count(2));
          data=resetField(data, count(3));

    elseif dimpleopt==3 || dimpleopt==4

          % read counter
          if isfield(data.Input,'Dimple')
                count(1)=length(data.Input.Dimple)+1;
                data.Input.Dimple(count(1))=data.Input.Dimple(count(1)-1);
                data=resetField(data, count(1));
           else
                count(1)=1;
                data.Input.Dimple(count)=initInputDatabase('Dimple');
          end

          count(2)=count(1)+1;
          data.Input.Dimple(count(2))=data.Input.Dimple(count(1));
          data=resetField(data, count(2));

          count(3)=count(2)+1;
          data.Input.Dimple(count(3))=data.Input.Dimple(count(2));
          data=resetField(data, count(3));

          count(4)=count(3)+1;
          data.Input.Dimple(count(4))=data.Input.Dimple(count(3));
          data=resetField(data, count(4));

    elseif dimpleopt==5

          % read counter
          if isfield(data.Input,'Dimple')
                count(1)=length(data.Input.Dimple)+1;
                data.Input.Dimple(count(1))=data.Input.Dimple(count(1)-1);
                data=resetField(data, count(1));
           else
                count(1)=1;
                data.Input.Dimple(count)=initInputDatabase('Dimple');
          end

          count(2)=count(1)+1;
          data.Input.Dimple(count(2))=data.Input.Dimple(count(1));
          data=resetField(data, count(2));

          count(3)=count(2)+1;
          data.Input.Dimple(count(3))=data.Input.Dimple(count(2));
          data=resetField(data, count(3));

          count(4)=count(3)+1;
          data.Input.Dimple(count(4))=data.Input.Dimple(count(3));
          data=resetField(data, count(4));

          count(5)=count(4)+1;
          data.Input.Dimple(count(5))=data.Input.Dimple(count(4));
          data=resetField(data, count(5));

          count(6)=count(5)+1;
          data.Input.Dimple(count(6))=data.Input.Dimple(count(5));
          data=resetField(data, count(6));
    end
    
elseif type==2 % circular stitch (Layout only applies to linear stitches)
    
  % read counter
  if isfield(data.Input,'Dimple')
        count(1)=length(data.Input.Dimple)+1;
        data.Input.Dimple(count(1))=data.Input.Dimple(count(1)-1);

        data=resetField(data, count(1));
   else
        count(1)=1;
        data.Input.Dimple(count)=initInputDatabase('Dimple');
  end
    
end

%-----------------------------------
        
% check status
for i=1:length(paraidt)
    
    paraid=paraidt(i);
    [flag, ~]=checkInputStatus(f, paraid, 'Stitch');

    if ~flag
        return
    end

    if type==1 % linear stitch

        % 
        if dimpleopt==1

           data=dimpleOpt1(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

        elseif dimpleopt==2

            data=dimpleOpt2(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

        elseif dimpleopt==3

            data=dimpleOpt3(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

        elseif dimpleopt==4

            data=dimpleOpt4(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

        elseif dimpleopt==5

            data=dimpleOpt5(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

        elseif dimpleopt==6

            %-----------------------
            %-- add any other option
            %-----------------------

        end

    elseif type==2 % circular stitch


        % starting point
        if size(data.Input.Stitch(idst).Pam{1},1)==1
           Ps=data.Input.Stitch(idst).Pam{1};
           N0=data.Input.Stitch(idst).Nam{1};
        else
           Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
           N0=data.Input.Stitch(idst).Nam{1}(paraid,:);
        end
        
        % master
        mastdimple=data.Input.Stitch(idst).Master;

        % slave
        sldimple=data.Input.Stitch(idst).Slave;
                            
        %-- additional output
        NS=null(N0);
        v=NS(:,1)';
        Pe=Ps+v*Ldimple;
        
        %-- additional output
        %--------------------------
        data=dimpleSaveAdditional(data, Ps, Pe, paraid, Ldimple, hdimple, mastdimple, sldimple, count(1), idst, searchDist);
        %--------------------------
        
    end

end


%%-------------------------
% OPTION 1
%%-------------------------
function data=dimpleOpt1(data, idst, paraid, deltad, Ldimple, hdimple, searchDist,count)

% starting point
if size(data.Input.Stitch(idst).Pam{1},1)==1
   Ps=data.Input.Stitch(idst).Pam{1};
else
   Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
end

% ending point
if size(data.Input.Stitch(idst).Pam{2},1)==1
   Pe=data.Input.Stitch(idst).Pam{2};
else
   Pe=data.Input.Stitch(idst).Pam{2}(paraid,:);
end

% master
mastdimple=data.Input.Stitch(idst).Master;

% slave
sldimple=data.Input.Stitch(idst).Slave;

%%
v=(Pe-Ps)/norm(Pe-Ps);

% --
% P1 start
Pds=Ps-deltad*v;

% P1 end
Pde=Ps-(deltad+Ldimple)*v;
      
%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(1), idst, searchDist);
%--------------------------

% --
% P2 start
Pds=Pe+deltad*v;

% P2 end
Pde=Pe+(deltad+Ldimple)*v;
    
%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(2), idst, searchDist);
%--------------------------


%%-------------------------
% OPTION 2
%%-------------------------
function data=dimpleOpt2(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count)

% run option 1 first of all
data=dimpleOpt1(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

% starting point
if size(data.Input.Stitch(idst).Pam{1},1)==1
   Ps=data.Input.Stitch(idst).Pam{1};
else
   Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
end

% ending point
if size(data.Input.Stitch(idst).Pam{2},1)==1
   Pe=data.Input.Stitch(idst).Pam{2};
else
   Pe=data.Input.Stitch(idst).Pam{2}(paraid,:);
end

% master
mastdimple=data.Input.Stitch(idst).Master;

% slave
sldimple=data.Input.Stitch(idst).Slave;

% get middle point
Pm=(Pe+Ps)/2;
        
% get normal vector
[Nm, flagNm]=point2Normal(data.Model.Nominal, Ps, mastdimple, searchDist);

if ~flagNm
    for i=1:length(count)
        data.Input.Dimple(count(i)).Status{1}(paraid)=-1;
    end
    return
end

% get tangent vector perpendicular to the stitch vector
v=(Pe-Ps)/norm(Pe-Ps);
Vd=cross(Nm, v);

% --
% P3 start
Pds=Pm+Vd*deltad;

% P3 end
Pde=Pm+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(3), idst, searchDist);
%--------------------------


%%-------------------------
% OPTION 3
%%-------------------------
function data=dimpleOpt3(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count)

% run option 1 first of all
data=dimpleOpt1(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count);

% starting point
if size(data.Input.Stitch(idst).Pam{1},1)==1
   Ps=data.Input.Stitch(idst).Pam{1};
else
   Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
end

% ending point
if size(data.Input.Stitch(idst).Pam{2},1)==1
   Pe=data.Input.Stitch(idst).Pam{2};
else
   Pe=data.Input.Stitch(idst).Pam{2}(paraid,:);
end

% master
mastdimple=data.Input.Stitch(idst).Master;

% slave
sldimple=data.Input.Stitch(idst).Slave;

%%
% get middle point
Pm=(Pe+Ps)/2;
        
% get normal vector
[Nm, flagNm]=point2Normal(data.Model.Nominal, Ps, mastdimple, searchDist);

if ~flagNm
    for i=1:length(count)
        data.Input.Dimple(count(i)).Status{1}(paraid)=-1;
    end
    return
end

% get tangent vector perpendicular to the stitch vector
v=(Pe-Ps)/norm(Pe-Ps);
Vd=cross(Nm, v);

% --
% P3 start
Pds=Pm+Vd*deltad;

% P3 end
Pde=Pm+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(3), idst, searchDist);
%--------------------------

% --
% P4 start
Pds=Pm-Vd*deltad;

% P4 end
Pde=Pm-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(4), idst, searchDist);
%--------------------------


%%-------------------------
% OPTION 4
%%-------------------------
function data=dimpleOpt4(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count)

% starting point
if size(data.Input.Stitch(idst).Pam{1},1)==1
   Ps=data.Input.Stitch(idst).Pam{1};
else
   Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
end

% ending point
if size(data.Input.Stitch(idst).Pam{2},1)==1
   Pe=data.Input.Stitch(idst).Pam{2};
else
   Pe=data.Input.Stitch(idst).Pam{2}(paraid,:);
end

% master
mastdimple=data.Input.Stitch(idst).Master;

% slave
sldimple=data.Input.Stitch(idst).Slave;
        
% get normal vector
[Nm, flagNm]=point2Normal(data.Model.Nominal, Ps, mastdimple, searchDist);

if ~flagNm
    for i=1:length(count)
        data.Input.Dimple(count(i)).Status{1}(paraid)=-1;
    end
    return
end

% get tangent vector perpendicular to the stitch vector
v=(Pe-Ps)/norm(Pe-Ps);
Vd=cross(Nm, v);

% --
% P1 start
Pds=Ps+Vd*deltad;

% P1 start
Pde=Ps+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(1), idst, searchDist);
%--------------------------

% --
% P2 start
Pds=Ps-Vd*deltad;

% P2 end
Pde=Ps-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(2), idst, searchDist);
%--------------------------

% --
% P3 start
Pds=Pe+Vd*deltad;

% P3 end
Pde=Pe+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(3), idst, searchDist);
%--------------------------

% --
% P4 start
Pds=Pe-Vd*deltad;

% P4 end
Pde=Pe-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(4), idst, searchDist);
%--------------------------


%%-------------------------
% OPTION 5
%%-------------------------
function data=dimpleOpt5(data, idst, paraid, deltad, Ldimple, hdimple, searchDist, count)

% starting point
if size(data.Input.Stitch(idst).Pam{1},1)==1
   Ps=data.Input.Stitch(idst).Pam{1};
else
   Ps=data.Input.Stitch(idst).Pam{1}(paraid,:);
end

% ending point
if size(data.Input.Stitch(idst).Pam{2},1)==1
   Pe=data.Input.Stitch(idst).Pam{2};
else
   Pe=data.Input.Stitch(idst).Pam{2}(paraid,:);
end

% master
mastdimple=data.Input.Stitch(idst).Master;

% slave
sldimple=data.Input.Stitch(idst).Slave;
        
% get normal vector
[Nm, flagNm]=point2Normal(data.Model.Nominal, Ps, mastdimple, searchDist);

if ~flagNm
    for i=1:length(count)
        data.Input.Dimple(count(i)).Status{1}(paraid)=-1;
    end
    return
end

% get tangent vector perpendicular to the stitch vector
v=(Pe-Ps)/norm(Pe-Ps);
Vd=cross(Nm, v);

% --
% P1 start
Pds=Ps+Vd*deltad;

% P1 end
Pde=Ps+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(1), idst, searchDist);
%--------------------------

% --
% P2 start
Pds=Ps-Vd*deltad;

% P2 end
Pde=Ps-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(2), idst, searchDist);
%--------------------------

% --
% P3 start
Pds=Pe+Vd*deltad;

% P3 end
Pde=Pe+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(3), idst, searchDist);
%--------------------------

% --
% P4 start
Pds=Pe-Vd*deltad;

% P4 end
Pde=Pe-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(4), idst, searchDist);
%--------------------------

% --
% get middle point
Pm=(Pe+Ps)/2;

% P5 start
Pds=Pm+Vd*deltad;

% P5 end
Pde=Pm+Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(5), idst, searchDist);
%--------------------------

% P6 start
Pds=Pm-Vd*deltad;

% P6 end
Pde=Pm-Vd*(deltad+Ldimple);

%-- additional output
%--------------------------
data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count(6), idst, searchDist);
%--------------------------


%%----------------------------------------
% save additional output for dimpling tasks
function data=dimpleSaveAdditional(data, Pds, Pde, paraid, Ldimple, hdimple, mastdimple, sldimple, count, idst, searchDist)

%-- additional output
%--------------------------
data.Input.Dimple(count).Slave=sldimple;
data.Input.Dimple(count).Master=mastdimple;
data.Input.Dimple(count).Height=hdimple;
data.Input.Dimple(count).L=Ldimple;
data.Input.Dimple(count).StitchId=idst;

[Psp, Ns, flags]=point2PointNormalProjection(data.Model.Nominal, Pds, mastdimple, searchDist);
   
if flags
    data.Input.Dimple(count).Nam{1}(paraid,:)=Ns;
    data.Input.Dimple(count).Pam{1}(paraid,:)=Psp;
    data.Input.Dimple(count).Status{1}(paraid)=0;
else
    data.Input.Dimple(count).Status{1}(paraid)=-1;
end

[Pep, Ne, flage]=point2PointNormalProjection(data.Model.Nominal, Pde, mastdimple, searchDist);

if flage
    data.Input.Dimple(count).Nam{2}(paraid,:)=Ne;
    data.Input.Dimple(count).Pam{2}(paraid,:)=Pep;
    data.Input.Dimple(count).Status{2}(paraid)=0;
else
    data.Input.Dimple(count).Status{2}(paraid)=-1;
end
%--------------------------

%--
function data=resetField(data, count)

% reset fields
data.Input.Dimple(count).Pam{1}=[];
data.Input.Dimple(count).Nam{1}=[];
data.Input.Dimple(count).Pam{2}=[];
data.Input.Dimple(count).Nam{2}=[];
data.Input.Dimple(count).Status{1}=-1;
data.Input.Dimple(count).Status{2}=-1;

