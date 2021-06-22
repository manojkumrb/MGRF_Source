% load FEM
function fem=loadSimulationData(fem, storeSim)

% load boundary
fem.Boundary=storeSim.ModelSet.Boundary;

% load domain
fem.Domain=storeSim.ModelSet.Domain;
