% assign additional constraint to robot path
function [c, ce]=additionalConstraintRobotPath(rob, teta)

% add consraint on the fixed mirror

% move on a line parallel to (x, y) plane
P01=[];
P02=[];

T=joint2Pos(teta, rob);

Tfix=setTransformation(T, 4);
Pfix=Tfix(1:3,4);

% get distance
c=[];

ce=Pfix(3)-d0;




