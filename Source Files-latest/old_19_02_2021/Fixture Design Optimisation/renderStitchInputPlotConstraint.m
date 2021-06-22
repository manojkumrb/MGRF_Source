% plot stitch data
function renderStitchInputPlotConstraint(fem, inputData, geomConstr)

faces=[];
vertices=[];

if ~isempty(inputData.Stitch.Ps)
    
    for j=1:size(inputData.Stitch.Ps,1)

        ts=inputData.Stitch.Type(j);

        flag=true;
        
        radius=geomConstr.dc;
        
        if ts==1 % linear
            
            Ps=inputData.Stitch.Ps(j,:);
            Pe=inputData.Stitch.Pe(j,:);

            Nz=(Pe-Ps)/norm(Pe-Ps);
            
            Ps=Ps-geomConstr.ds*Nz;
            
            L=norm(Pe-Ps)+geomConstr.de;
            
        elseif ts==2 % circular
            
            Ps=inputData.Stitch.Ps(j,:);
            
            L=radius;
         
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

        end

    end

end


patch('faces',faces,...
      'vertices',vertices,...
          'facecolor','g',...
          'edgecolor','none',...
          'parent',fem.Post.Options.ParentAxes,...
          'facealpha',0.5)
              
view(3)
axis equal

if fem.Post.Options.ShowAxes
    set(fem.Post.Options.ParentAxes,'visible','on')
else
    set(fem.Post.Options.ParentAxes,'visible','off')
end

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

