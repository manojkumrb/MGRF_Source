% plot refM clamp data
function renderReferenceMInputPlot(fem, inputData, clampgeo)

if ~isempty(inputData.Clamp.ReferenceM.Pm)
    
    for j=1:size(inputData.Clamp.ReferenceM.Pm,1)

        Pm=inputData.Clamp.ReferenceM.Pm(j,:);
        Nm=inputData.Clamp.ReferenceM.Nm(j,:);

        % create object
        [R0c, d0c]=getFrameClamp(-Nm, Pm);
     
        % trsform clamp
        vertex=clampgeo.Vertex;

        vertex=apply4x4(vertex, R0c, d0c);
       
        patch('faces',clampgeo.Face,...
                 'vertices',vertex,...
                 'edgecolor','none',...
                 'facecolor','g',...
                 'parent',fem.Post.Options.ParentAxes)
             
        % create object
        [R0c, d0c]=getFrameClamp(Nm, Pm);
     
        % trsform clamp
        vertex=clampgeo.Vertex;

        vertex=apply4x4(vertex, R0c, d0c);
       
        patch('faces',clampgeo.Face,...
                 'vertices',vertex,...
                 'edgecolor','none',...
                 'facecolor','g',...
                 'parent',fem.Post.Options.ParentAxes)
  
    end

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



