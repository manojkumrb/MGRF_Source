function model=placeReferenceMInputPlotVrml(inputData, tra)

% load clamp geometry
load clampgeo_Bshape
clampgeoplace=placeReferenceMInputPlot(inputData, clampgeo);

model=initModel2Vrml();

model.Tria.Face=clampgeoplace.Face;
model.Tria.Node=clampgeoplace.Vertex;
model.Tria.Shade='uniform';
model.Tria.Trasparency=tra;
model.Tria.Color=[0 1 0];