clc
clear
close all


P0x=sym('P0x'); P0y=sym('P0y'); P0z=sym('P0z');
L2=sym('L2'); 
L3=sym('L3');
L4=sym('L4');
L5=sym('L5');

% define independent angles
teta1=sym('teta1');
teta2=sym('teta2');
teta3=sym('teta3');
teta4=sym('teta4');
teta5=sym('teta5');
teta6=sym('teta6');
teta7=sym('teta7');

%%
% calculate rotation matrices and position vector
T01=[cos(teta1) -sin(teta1)  0 0
     -sin(teta1) -cos(teta1) 0 0
     0            0         -1 0
     0            0          0  1];
 
T12=[sin(teta2) cos(teta2)  0  P0x
     0            0         -1 -P0y
     -cos(teta2) sin(teta2) 0  -P0z
     0           0          0  1];
 
T23=[cos(teta3) -sin(teta3)   0 L2
     -sin(teta3) -cos(teta3)  0 0
     0             0          -1 0
     0             0          0  1];
 
T34=[-cos(teta4) -sin(teta4)   0  L3
     0            0           -1  -L4
     sin(teta4) -cos(teta4)    0  0
     0           0             0  1];

T45=[1 0            0             L5
     0 cos(teta5) -sin(teta5)     0
     0 sin(teta5) cos(teta5)      0
     0 0            0             1];

T56=[cos(teta6)  0   sin(teta6)  0
     0           1   0           0
     -sin(teta6) 0   cos(teta6)  0
     0           0   0           1];
 
T67=[1 0 0 0
     0 1 0 0
     0 0 1 teta7
     0 0 0 1];
 
px=sym('px');
py=sym('py');
pz=sym('pz');

for i=1:3
    for j=1:3
      r(i,j)=sym(sprintf('r(%g,%g)',i,j));
    end
end

r(4,1:4)=[0 0 0 1];
r(1:3,4)=[px, py, pz];

l=simplify(inv(T01*T12)*r)

r=simplify(T23*T34*T45*T56*T67)

