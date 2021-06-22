function R=euler2Rot(alfa, beta, gamma, m)

% [alfa, beta, gamma]: euler angles in degrees
% m: a string of 3 characters from the set {'x','y','z'} e.g. "zxz" or "zyx" or, equivalently, a vector whose elements are 1, 2 or 3

% R: 3x3 rotation matrix

%-------------------------------------
if nargin==3
    m='zyz';
end

%--
if ischar(m)
    m=lower(m)-'w'; % convert in numeric index (1 to 3)
end

alfa=alfa*pi/180;
beta=beta*pi/180;
gamma=gamma*pi/180;

% calculate rotation matrix
R=eye(3,3);
for i=1:3
    if m(i)==1
        R=R*callRotX(alfa);
    elseif m(i)==2
        R=R*callRotY(beta);
    elseif m(i)==3
        R=R*callRotZ(gamma);
    end
end


% rotation around X of alfa
function Rx=callRotX(alfa)

Rx=[1    0          0
    0    cos(alfa) -sin(alfa)
    0    sin(alfa) cos(alfa)];

% rotation around Y of beta
function Ry=callRotY(beta)

Ry=[cos(beta) 0 sin(beta)
       0         1 0
       -sin(beta) 0 cos(beta)];

   % rotation around Z of gamma
function Rz=callRotZ(gamma)

Rz=[cos(gamma) -sin(gamma) 0
       sin(gamma) cos(gamma) 0
       0          0         1];
   
