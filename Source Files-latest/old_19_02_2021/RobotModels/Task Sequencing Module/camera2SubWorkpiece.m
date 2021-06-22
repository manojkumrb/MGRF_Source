% extract the workpiece enclosed within the cone (Pc, Nc)
function workpieces=camera2SubWorkpiece(rob, workpiece, Pc, Nc)

% read cone property
[~, Lmax, alfa]=getCamFoVCone(rob);

% extract ids of nodes belonging to cone (FoV of the scanner)
Pi=workpiece.xMesh.Node.Coordinate;
ids=inCone3D(Pi, Pc, Nc, alfa, Lmax);

% connected elements
elems=unique(cell2mat(workpiece.Sol.Node2Element(ids)));

% save out the sub-structure
workpieces=workpiece;
workpieces.xMesh.Element=workpiece.xMesh.Element(elems);
