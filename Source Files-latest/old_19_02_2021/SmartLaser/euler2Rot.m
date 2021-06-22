function R=euler2Rot(alfa, beta, gamma)

% perform: Rz*Ry*Rz

% angles are passed in degrees

alfa=alfa*pi/180;
beta=beta*pi/180;
gamma=gamma*pi/180;

% rotation around Z of alfa
Ralfa=[cos(alfa) -sin(alfa) 0
       sin(alfa) cos(alfa) 0
       0          0         1];
   
% rotation around Y of beta
Rbeta=[cos(beta) 0 sin(beta)
       0         1 0
       -sin(beta) 0 cos(beta)];

% rotation around Z of gamma
Rgamma=[cos(gamma) -sin(gamma) 0
       sin(gamma) cos(gamma) 0
       0          0         1];

% calculate rotation matrix
R=Ralfa*Rbeta*Rgamma;



