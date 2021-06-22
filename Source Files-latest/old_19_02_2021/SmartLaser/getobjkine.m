function d=getobjkine(teta, rob, pgoal)

% set joints
Tinv=joint2Pos(teta, rob);
T=setTransformation(Tinv, 4);

% get fixed mirror
pfix=T(1:3,4)';
Rfix=T(1:3,1:3);

% get moving mirror location
pmov=fix2MoveFrame(pfix, Rfix, rob);

d=norm(pgoal-pmov);