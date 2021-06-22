% plot stitch data
function model=renderSnagStitchInputPlotVrml(inputData, radius, tolleng, tra)

% initial model for VRML
model=initModel2Vrml();

faces=[];
vertices=[];

st=cell(0,1);
pos=[];
fontsize=[];
col=[];
if ~isempty(inputData.Stitch.Ps)
    
    for j=1:size(inputData.Stitch.Ps,1)

        ts=inputData.Stitch.Type(j);

        flag=true;
        if ts==1 % linear
            
            Ps=inputData.Stitch.Ps(j,:);
            Pe=inputData.Stitch.Pe(j,:);

            pj=mean([Ps
                     Pe]);

            L=norm(Pe-Ps);
            Nz=(Pe-Ps)/L;
            
        elseif ts==2 % circular
            
            Ps=inputData.Stitch.Ps(j,:);

            pj=Ps;
            
            L=5;
         
            Nz=inputData.Stitch.Ns(j,:);
        else
            flag=false;                        
        end

        if flag
            
            % create object
            [X,Y,Z]=renderStitch(radius, L, Nz, Ps);

             % plot symbol
             pfv=surf2patch(X,Y,Z);

             %
             if ~isempty(faces)
               nnode=max(faces(:));
             else
               nnode=0;
             end

             tface=pfv.faces+nnode;

              faces=[faces
                     tface];

              vertices=[vertices
                     pfv.vertices];

                if  inputData.Stitch.StfLength(j)<=tolleng
                    stk=sprintf('RLW%g: Gap-Length NOT Satisfactory: %.1f%s', j, inputData.Stitch.StfLength(j)*100, '%');

                    st{end+1}=stk;
                    pos=[pos
                         pj];
                    fontsize=[fontsize
                              12];
                    col=[col
                         1 0 0];
                end
        end

    end

end

% save text
model.Text.String=st;
model.Text.Position=pos;
model.Text.FontSize=fontsize;
model.Text.Color=col;

% save quads
model.Quad.Face=faces;
model.Quad.Node=vertices;
model.Quad.Trasparency = tra;
model.Quad.Color=[0 0 0];
model.Quad.Shade='uniform';
        

%...             
function [X,Y,Z]=renderStitch(radius, L, Nz,d)

res=10;
[X,Y,Z]=cylinder(radius,res);

%...
Z(1,:)=0;
Z(2,:)=L;

% get base:
NS=null(Nz);

Nx=NS(:,1);
Ny=cross(Nz,Nx);

R=[Nx,Ny',Nz'];

%...
P1=[X(1,:);Y(1,:);Z(1,:)]';
P2=[X(2,:);Y(2,:);Z(2,:)]';

P1=apply4x4(P1, R, d)';

P2=apply4x4(P2, R, d)';

%... then
X=[P1(1,:);P2(1,:)];
Y=[P1(2,:);P2(2,:)];
Z=[P1(3,:);P2(3,:)];

