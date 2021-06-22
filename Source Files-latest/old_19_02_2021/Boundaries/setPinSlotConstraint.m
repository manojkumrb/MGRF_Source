% set pin-hole constraint for "shell" elements
function fem=setPinSlotConstraint(fem)

nph=length(fem.Boundary.Constraint.PinSlot);

if nph==0
    return
end

for i=1:nph
    
    %---
    Pm=fem.Boundary.Constraint.PinSlot(i).Pm;
    N1=fem.Boundary.Constraint.PinSlot(i).Nm1; % slot axis 1
    N2=fem.Boundary.Constraint.PinSlot(i).Nm2; % slot axis 2
    iddom=fem.Boundary.Constraint.PinSlot(i).Domain;
    dsear=fem.Boundary.Constraint.PinSlot(i).SearchDist;
    
    value=fem.Boundary.Constraint.PinSlot(i).Value;
    
    ustr=fem.Boundary.Constraint.PinSlot(i).UserExp.Tag;
    
    % apply constraint along N1 and around N2

    nc=length(fem.Boundary.Constraint.Bilateral.Element)+1;
       
    % along N1
    fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
    fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorTra';
    fem.Boundary.Constraint.Bilateral.Element(nc).Nm=N1;
    fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(1);
    fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
    fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
    fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
    fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;

    % for thin sheet metal parts rotation around N2 can be neglected
    
        %     % around N2
        %     nc=nc+1;
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Pm=Pm;
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Reference='vectorRot';
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Nm=N2;
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Value=value(2);
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Domain=iddom;
        %     fem.Boundary.Constraint.Bilateral.Element(nc).SearchDist=dsear;
        %     fem.Boundary.Constraint.Bilateral.Element(nc).Physic='shell';
        %     fem.Boundary.Constraint.Bilateral.Element(nc).UserExp.Tag=ustr;
    
    % set references for low-level constraint
    fem.Boundary.Constraint.PinSlot(i).ConstraintId=[nc-1 nc];

end
