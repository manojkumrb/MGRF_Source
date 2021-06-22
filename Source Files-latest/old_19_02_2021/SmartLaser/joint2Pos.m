% calculate the trasformation matrices for a given joint set
function T=joint2Pos(teta0, rob, settingteta)

% teta: list of axis joints

% rob:
%   .P0: location of axis[2]
%   .L2: length of link[2]
%   .L3: length of link[3]
%   .L4: length of link[4]
%   .L5: offset between fixed mirror and moving mirror

if nargin<3
    teta=teta0;
else % use settings
    teta=zeros(1, 7);
    teta(settingteta.IdFix)=settingteta.TetaFix;
    teta(settingteta.IdVar)=teta0;
end


% init matrices
T=cell(1,4);

% inital parameters
P0=rob.P0;
L2=rob.L2;
L3=rob.L3;
L4=rob.L4;
L5=rob.L5;

% AXIS[1]
R01=[cos(teta(1)) -sin(teta(1)) 0
     -sin(teta(1)) -cos(teta(1)) 0
     0            0            -1];
d01=[0 0 0];
T01=eye(4,4);
T01(1:3,1:3)=R01; T01(1:3,4)=d01;
T{1}=T01;

% AXIS[2]
R12=[sin(teta(2)) cos(teta(2)) 0
     0            0            -1
     -cos(teta(2)) sin(teta(2)) 0];
d12=[P0(1) -P0(2) -P0(3)];
T12=eye(4,4);
T12(1:3,1:3)=R12; T12(1:3,4)=d12;
T{2}=T12;

% AXIS[3]
R23=[cos(teta(3)) -sin(teta(3)) 0
     -sin(teta(3)) -cos(teta(3)) 0
     0             0             -1];
d23=[L2 0 0];
T23=eye(4,4);
T23(1:3,1:3)=R23; T23(1:3,4)=d23;
T{3}=T23;

% AXIS[4]
R34=[-cos(teta(4)) -sin(teta(4)) 0
     0            0             -1
     sin(teta(4)) -cos(teta(4)) 0];
d34=[L3 -L4 0];
T34=eye(4,4);
T34(1:3,1:3)=R34; T34(1:3,4)=d34;  
T{4}=T34;

% AXIS[5]
R54=[1 0            0
     0 cos(teta(5)) sin(teta(5))
     0 -sin(teta(5)) cos(teta(5))];
d54=[L5 0 0];
T54=eye(4,4);
T54(1:3,1:3)=R54; T54(1:3,4)=d54;  
T{5}=T54;

% AXIS[6]
R65=[cos(teta(6))  0   -sin(teta(6))
     0             1   0
     sin(teta(6)) 0   cos(teta(6))];
d65=[0 0 0];
T65=eye(4,4);
T65(1:3,1:3)=R65; T65(1:3,4)=d65;  
T{6}=T65;

% AXIS[7]
d76=[0 0 teta(7)];
T76=eye(4,4);
T76(1:3,4)=d76;  
T{7}=T76;
      
      
      
