function model=render3dFixture(fileFixture)

% comau fixture
[v, f] = stlread(fileFixture);

fv.faces=f;
fv.vertices=v;
fv = reducepatch(fv,0.5); 

model=initModel2Vrml();

model.Tria.Face=fv.faces;
model.Tria.Node=fv.vertices;
model.Tria.Shade='uniform';
model.Tria.Trasparency=0.0;
model.Tria.Color=[0.95 0.97 0.95];

