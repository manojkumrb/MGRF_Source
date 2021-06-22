% set pin-hole constraint for "shell" elements
function fem=setPinHoleConstraint(fem)

nph=length(fem.Boundary.Constraint.PinHole);

if nph==0
    return
end

for i=1:nph
    
    %---
    Pm=fem.Boundary.Constraint.PinHole(i).Pm;
    Nm1=fem.Boundary.Constraint.PinHole(i).Nm1;
    Nm2=fem.Boundary.Constraint.PinHole(i).Nm2;
    
    iddom=fem.Boundary.Constraint.PinHole(i).Domain;
    dsear=fem.Boundary.Constraint.PinHole(i).SearchDist;
    
    value=fem.Boundary.Constraint.PinHole(i).Value;
    
    ustr=fem.Boundary.Constraint.PinHole(i).UserExp.Tag;
    
    % apply constraint along Nm1 and Nm2 and rotations around Nm1 and Nm2

    nc=length(fem.Boundary.Constraint.Bilateral.Element)+1;

    % along Nx
    fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
    fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorTra';
    fem.Boundary.Constraint.Bilateral.Element(nc).Nm=Nm1;
    fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(1);
    fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
    fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
    fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
    fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;
 
    % along Ny
    nc=nc+1;
    fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
    fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorTra';
    fem.Boundary.Constraint.Bilateral.Element(nc).Nm=Nm2;
    fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(2);
    fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
    fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
    fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
    fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;
 
    % for thin sheet metals rotation around X and Y can be assumed free 
            %     % around Nx
            %     nc=nc+1;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorRot';
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Nm=Nm1;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(3);
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
            %     fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;
            % 
            %     % around Ny
            %     nc=nc+1;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorRot';
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Nm=Nm2;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(4);
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
            %     fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
            %     fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;

    % set references for low-level constraint
    fem.Boundary.Constraint.PinHole(i).ConstraintId=[nc-3 nc-2 nc-1 nc];

end

