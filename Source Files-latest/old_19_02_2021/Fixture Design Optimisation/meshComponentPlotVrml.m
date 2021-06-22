% plotta la mesh (campo "fem.xMesh")
function model=meshComponentPlotVrml(fem, idcomp)

fem.Post.Options.ColorPatch=[0.3 0.3 0.3];

model=initModel2Vrml();
    
% PLOT TRIA:
nele=length(fem.Domain(idcomp).ElementTria);

tria=zeros(nele,3);
for i=1:nele
      id=fem.Domain(idcomp).ElementTria(i);

      tria(i,:)=fem.xMesh.Element(id).Element;
end

if nele>0

    model.Tria.Face=tria;
    model.Tria.Node=fem.xMesh.Node.Coordinate;
    model.Tria.Trasparency=0.6;
    model.Tria.Color=fem.Post.Options.ColorPatch;
    model.Tria.Shade='uniform';

end


% PLOT QUAD:
nele=length(fem.Domain(idcomp).ElementQuad);

quad=zeros(nele,4);
for i=1:nele
      id=fem.Domain(idcomp).ElementQuad(i);

      quad(i,:)=fem.xMesh.Element(id).Element;
end

if nele>0

    model.Quad.Face=quad;
    model.Quad.Node=fem.xMesh.Node.Coordinate;
    model.Quad.Trasparency = 0.6;
    model.Quad.Color=fem.Post.Options.ColorPatch;
    model.Quad.Shade='uniform';

end




