% define SPC for Region of Interest (RoI)
function fem=roiSubModelling(fem, inputData)

% NOTICE: current solution is stored in "inputData.SubModel.U"

% read previous constraints
nc=length(fem.Boundary.Constraint.Bilateral.Node);

bnode=fem.Selection.Node.Boundary;

if isempty(bnode)
    fprintf('No RoI has been defined. Sub-model has been skypped\n')
    return
end

nb=length(bnode);

% loop over all constraints
for i=1:nb
    
    id=bnode(i);
    
    dofs=fem.xMesh.Node.NodeIndex(id,:);
    for j=1:6 % loop over all dofs
        dofsj=dofs(j);
        
        valuej=inputData.SubModel.U(dofsj);
        
        % set new constraint
        nc=nc+1;
        
        fem.Boundary.Constraint.Bilateral.Node(nc).Node=id;
        fem.Boundary.Constraint.Bilateral.Node(nc).Reference='cartesian';
        fem.Boundary.Constraint.Bilateral.Node(nc).DoF=j;
        fem.Boundary.Constraint.Bilateral.Node(nc).Value=valuej;
        fem.Boundary.Constraint.Bilateral.Node(nc).Physic='shell';

    end
    
end

