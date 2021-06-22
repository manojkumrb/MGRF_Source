function plotModelSim(fem, storeSim, sgap, idpair, inputData)

% INPUT:
% fem: fem structure
% storeSim: simulation results
% sgap: max. gap value
% idpair: pair to be plotted
% inputData: input data structure

nd=fem.Sol.nDom;

for i=1:nd
    fem.Post.Options.ColorPatch=rand(1,3);
    meshComponentPlot(fem, i)
end

pinholeBcPlot(fem)
pinslotBcPlot(fem)
unilateralBcPlot(fem)
dimpleBcPlot(fem)
bilateralElementBcPlot(fem)
rigidlinkBcPlot(fem)

%--------------------
% load solution

% gap variables
fem.Sol.UserExp=storeSim.Gap(idpair).Gap;

% disp variables
fem.Sol.U=storeSim.U;

idslave=fem.Boundary.ContactPair(idpair).Slave;

fem.Post.Contour.Domain=idslave;
fem.Post.Contour.ContourVariable='gap'; % gap distribution
fem.Post.Contour.ContactPair=idpair; 
fem.Post.Contour.MaxRange=sgap; 
fem.Post.Contour.MinRange=-10; 
fem.Post.Contour.ScaleFactor=1.0;
fem.Post.Contour.Resolution=1.0;

contourPlot(fem)

% plot input data set
% stitch
stitchInputPlot(fem, inputData)

% NC block
NCBlockInputPlot(fem, inputData)

% clamp
referenceSInputPlot(fem, inputData)
referenceMInputPlot(fem, inputData)
variableClampInputPlot(fem, inputData)

