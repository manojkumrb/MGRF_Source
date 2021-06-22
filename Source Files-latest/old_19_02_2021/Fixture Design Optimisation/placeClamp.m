% plot unilateral constraints
function clampgeoPlace=placeClamp(fem, clampgeo)

% clampgeo: 3d geometry of clamp

% read number of constraints
nc=length(fem.Boundary.Constraint.Unilateral);

%-
if nc==0 
    return
end

clampgeoPlace.Vertex=[];
clampgeoPlace.Face=[];

nnode=max(clampgeo.Face(:));

for i=1:nc
    
     P0=fem.Boundary.Constraint.Unilateral(i).Pm;
     N0=fem.Boundary.Constraint.Unilateral(i).Nm;

     offset=fem.Boundary.Constraint.Unilateral(i).Offset;
          
     % create object
     [R0c, d0c]=getFrameClamp(-N0, P0+offset*N0);
     
     % trsform clamp
     vertex=clampgeo.Vertex;
     
     vertex=apply4x4(vertex, R0c, d0c);
     
     % save
     clampgeoPlace.Vertex=[clampgeoPlace.Vertex
                           vertex];
                       
     ntria=nnode*(i-1);
     
     clampgeoPlace.Face=[clampgeoPlace.Face
                         clampgeo.Face+ntria];
        
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



