
% post process simulation data and get gap variables
function [gap, Pgap]=postProcessGap(fem, inData, npoint, searchDist)

% INPUT:
% fem: initial fem structure
% inData: input data
% npoint: no. of points per stitch
% searchDist: searching distance

% OUTPUT:
% gap: gap distribution [id stitch] [points per stitch]
% Pgap: xyx coordinates of evaluation points  [id stitch] [points per stitch]

%--------------
% define diameter for circular stitches
dia=8;
%--------------

% run over all stitches
ns=size(inData.Stitch.Ps,1);

% no. of pairs
ncp=length(fem.Boundary.ContactPair);

% set intial values
gap=cell(1,ns);
Pgap=cell(1,ns);

% run over contact pairs
for z=1:ncp
    
    fprintf('Processing contact pair ID: %g\n', z);
    
    % init data
    data.stitchid=[];
    data.p=[];
    data.g=[];
    data.pid{1}=[];
    data.part=[];
    data.pair=z;
    
    count=1;
    
    idpart=fem.Boundary.ContactPair(z).Slave;
    
    % run over all stitches
    for i=1:ns

        typest=inData.Stitch.Type(i);

        if typest~=0

            % read stitch master and slave
            mast=inData.Stitch.Master(i);

            sla=inData.Stitch.Slave(i);
            
            if (idpart==mast & fem.Domain(idpart).Status ) | (idpart==sla & fem.Domain(idpart).Status ) 
                
               data.stitchid(end+1)=i;
               data.part=sla;
               
               data.pid{count}=(1:npoint) + npoint*(count-1);
               count=count+1;
                
               if typest==1 %% linear
                   
                   % set parameter
                   tpara=0:1/(npoint-1):1;
                   nt=length(tpara);
                 
                   Ps=inData.Stitch.Ps(i,:);
                   Pe=inData.Stitch.Pe(i,:);

                    for k=1:nt
                         data.p=[data.p
                                    Ps+tpara(k)*(Pe-Ps)];
                    end

                elseif typest==2 %% circular
                    
                    P0=inData.Stitch.Ps(i,:);
                    N0=inData.Stitch.Ns(i,:);
                    
                    Pc=sampleCircularStitch(N0, P0, dia, npoint);

                    data.p=[data.p
                              Pc];
               end
               
            end

        end

    end
    
    % interpolate
    if ~isempty(data.stitchid)
    
        fem.Post.Interp.InterpVariable='gap';
        fem.Post.Interp.Domain=data.part;
        fem.Post.Interp.ContactPair=data.pair;
        fem.Post.Interp.SearchDist=searchDist;

         % get interpolation
        fem.Post.Interp.Pm=data.p;
        fem=getInterpolationData(fem);
        
        % save data
        gapi=fem.Post.Interp.Data;

        % point not projected are set to "0"
        %------------------------------------
        flagi=fem.Post.Interp.Flag;
        gapi(flagi==false)=0;
        %------------------------------------

        % store all
        n=length(data.stitchid);
        
        fprintf('  Summary:\n');
        fprintf('     No. of stitches: %g\n', n);
        
        for i=1:n
            gap{data.stitchid(i)}=gapi(data.pid{i});

            Pgap{data.stitchid(i)}=fem.Post.Interp.Pmp(data.pid{i},:);
        end
        
    end
    
end


% sample points for circular stitches
function Pc=sampleCircularStitch(N0, P0, dia, npoint)

% dia = stitch diameter
% npoint = no. of sampling point
% idst = stitch id

% build ref. frame
NS=null(N0);
x=NS(:,1);
y=NS(:,2);

R0l=[x, y, N0'];

if det(R0l)<0
    R0l(:,2)=-R0l(:,2);
end

% define circle into the local frame
teta=0:2*pi/(npoint-1):2*pi;

x=dia/2*cos(teta);
y=dia/2*sin(teta);
z=zeros(1,length(x));

Pc=[x', y', z'];

% trasform point back to global frame
Pc=apply4x4(Pc, R0l, P0);



