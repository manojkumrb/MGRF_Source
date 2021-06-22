% plot refM clamp data
function clampgeoPlace=placeReferenceMInputPlot(inputData, clampgeo)

clampgeoPlace.Vertex=[];
clampgeoPlace.Face=[];

count=1;

nnode=max(clampgeo.Face(:));

if ~isempty(inputData.Clamp.ReferenceM.Pm)
    
    for j=1:size(inputData.Clamp.ReferenceM.Pm,1)

        Pm=inputData.Clamp.ReferenceM.Pm(j,:);
        Nm=inputData.Clamp.ReferenceM.Nm(j,:);

        % create object
        [R0c, d0c]=getFrameClamp(-Nm, Pm);
     
        % trsform clamp
        vertex=clampgeo.Vertex;

        vertex=apply4x4(vertex, R0c, d0c);
       
         % save
         clampgeoPlace.Vertex=[clampgeoPlace.Vertex
                               vertex];

         ntria=nnode*(count-1);
         count=count+1;

         clampgeoPlace.Face=[clampgeoPlace.Face
                             clampgeo.Face+ntria];
                     
        % create object
        [R0c, d0c]=getFrameClamp(Nm, Pm);
     
        % trsform clamp
        vertex=clampgeo.Vertex;

        vertex=apply4x4(vertex, R0c, d0c);
        
        % save
         clampgeoPlace.Vertex=[clampgeoPlace.Vertex
                               vertex];

         ntria=nnode*(count-1);
         count=count+1;

         clampgeoPlace.Face=[clampgeoPlace.Face
                             clampgeo.Face+ntria];
       

    end

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



