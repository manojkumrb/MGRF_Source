% get euler angles from Rotation matrix
function [alfa, beta, gamma]=rot2Euler(R)

% perform: Rz*Ry*Rz

% angles are returned in degrees

a=R(1,3);
b=R(2,3);
alfa=atan2(b, a);

a=R(3,3);
b=cos(alfa)*R(1,3) + sin(alfa)*R(2,3);
beta=atan2(b, a);

a=-R(3,1);
b=R(3,2);
gamma=atan2(b, a);

alfa=alfa*180/pi;
beta=beta*180/pi;
gamma=gamma*180/pi;



