% plot unilateral constraints
function renderClamp(fem, clampgeo)

% clampgeo: 3d geometry of clamp

% read number of constraints
nc=length(fem.Boundary.Constraint.Unilateral);

%-
if nc==0 
    return
end

for i=1:nc
    
     P0=fem.Boundary.Constraint.Unilateral(i).Pm;
     N0=fem.Boundary.Constraint.Unilateral(i).Nm;

     offset=fem.Boundary.Constraint.Unilateral(i).Offset;

     type=fem.Boundary.Constraint.Unilateral(i).Type{1};
          
     % create object
     [R0c, d0c]=getFrameClamp(-N0, P0+offset*N0);
     
     % trsform clamp
     vertex=clampgeo.Vertex;
     
     vertex=apply4x4(vertex, R0c, d0c);
          
      % plot symbol
      if strcmp(type,'assigned') %% green color

          col='g';
      else %% red color
          col='r';
      end
      
      patch('faces',clampgeo.Face,...
             'vertices',vertex,...
             'edgecolor','none',...
             'facecolor',col,...
             'parent',fem.Post.Options.ParentAxes)
      
         
end


view(3)
axis equal

if fem.Post.Options.ShowAxes
    set(fem.Post.Options.ParentAxes,'visible','on')
else
    set(fem.Post.Options.ParentAxes,'visible','off')
end

function [R0c, d0c]=getFrameClamp(Nm, Pm)

% get rotation matrix
z=Nm;

NS=null(Nm);

xt=NS(:,1);

y=cross(z, xt);
x=cross(y, z);

R0c=[x', y', z'];

d0c=Pm;



