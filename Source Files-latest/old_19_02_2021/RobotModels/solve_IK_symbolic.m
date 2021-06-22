clc
clear

% define independent angles
teta1=sym('teta1');
teta2=sym('teta2');
teta3=sym('teta3');
teta4=sym('teta4');
teta5=sym('teta5');
teta6=sym('teta6');
teta7=sym('teta7');

% teta6=0;

% define geometry
L1=sym('L1');
L2=sym('L2');
L31=sym('L31');
L32=sym('L32');
L4=sym('L4');
L51=sym('L51');
L52=sym('L52');
L6=sym('L6');
L7=sym('L7');

% AXIS[5]
T45c=[0 0  1 L51
      1 0  0 -L52
      0 1  0 0
      0 0  0 1];
R=getRotZ(teta5);
T45r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T45=T45c*T45r;

% AXIS[6]
T56c=[0 1  0 0
      0 0  1 0
      1 0  0 L6
      0 0  0 1];
R=getRotZ(teta6);
T56r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T56=T56c*T56r;

% AXIS[7]
T67c=[0 0  1 L7
      1 0  0 0
      0 1  0 0
      0 0  0 1];
R=getRotZ(teta7);
T67r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T67=T67c*T67r;

T47=T45*T56*T67;
R47=T47(1:3,1:3);

% teta6=0;
pretty(simplify(eval(R47)))

return






teta1=0;
L1=0;



% AXIS[1] - track
T01c=[1 0 0 L1
      0 1 0 0
      0 0 1 0
      0 0 0 1];
T01r=[1 0 0 teta1
      0 1 0 0
      0 0 1 0
      0 0 0 1];
T01=T01c*T01r;

% AXIS[2]
T12c=[1 0 0 0
      0 1 0 0
      0 0 1 L2
      0 0 0 1];
R=getRotZ(teta2);
T12r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T12=T12c*T12r;

% AXIS[3]
T23c=[1 0  0 L31
      0 0  1 0
      0 -1 0 L32
      0 0  0 1];
R=getRotZ(teta3);
T23r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T23=T23c*T23r;

% AXIS[4]
T34c=[1 0  0 0
      0 1  0 -L4
      0 0  1 0
      0 0  0 1];
R=getRotZ(teta4);
T34r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T34=T34c*T34r;

% AXIS[5]
T45c=[0 0  1 L51
      1 0  0 -L52
      0 1  0 0
      0 0  0 1];
R=getRotZ(teta5);
T45r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T45=T45c*T45r;

% AXIS[6]
T56c=[0 1  0 0
      0 0  1 0
      1 0  0 L6
      0 0  0 1];
R=getRotZ(teta6);
T56r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T56=T56c*T56r;

% AXIS[7]
T67c=[0 0  1 L7
      1 0  0 0
      0 1  0 0
      0 0  0 1];
R=getRotZ(teta7);
T67r=[R(1,1) R(1,2) R(1,3) 0
     R(2,1) R(2,2) R(2,3) 0
     R(3,1) R(3,2) R(3,3) 0
     0      0      0      1];
T67=T67c*T67r;



ptx=sym('ptx');
pty=sym('pty');
ptz=sym('ptz');

for i=1:3
    for j=1:3
      Tt(i,j)=sym(sprintf('rt%g%g',i,j));
    end
end

Tt(4,1:4)=[0 0 0 1];
Tt(1:3,4)=[ptx, pty, ptz];


lhs=simplify(inv(T01*T12)*Tt)
rhs=simplify(T23*T34*T45*T56*T67)

return

lhs{1}=simplify(inv(T01)*Tt);
rhs{1}=simplify(T12*T23*T34*T45*T56*T67);

lhs{2}=simplify(inv(T01*T12)*Tt);
rhs{2}=simplify(T23*T34*T45*T56*T67);

lhs{3}=simplify(inv(T01*T12*T23)*Tt);
rhs{3}=simplify(T34*T45*T56*T67);

lhs{4}=simplify(inv(T01*T12*T23*T34)*Tt);
rhs{4}=simplify(T45*T56*T67);

lhs{5}=simplify(inv(T01*T12*T23*T34*T45)*Tt);
rhs{5}=simplify(T56*T67);

lhs{6}=simplify(inv(T01*T12*T23*T34*T45*T56)*Tt);
rhs{6}=simplify(T67);

%%
c=1;
uk=[];
eqns=[];
for k=1:length(lhs)
    eqns{k}=lhs{k}(1:3,1:4)-rhs{k}(1:3,1:4);
    
    for i=1:size(eqns{k},1)
        for j= 1:size(eqns{k},2)
            ukij=intersect(symvar(eqns{k}(i,j)),[teta1, teta2,teta3, teta4, teta5, teta6, teta7]);
            uk{c,1}=char(ukij);
            uk{c,2}=[k, i, j];
            c=c+1;
        end
    end
end

%%
ids=[2 2 3
     3 3 3
     4 3 3];

 for i=1:size(ids,1)
   eq(i,1)=sym(sprintf('eq(%g,1)',i));
   eq(i,1)=eqns{ids(i,1)}(ids(i,2),ids(i,3));
 end
 
 %%
 temp = solve(eq,teta2,teta5, teta6);
 


% 
% uk=intersect(symvar(eqns(1)),[teta2,teta3, teta4, teta5, teta6, teta7])
% uk=intersect(symvar(eqns(2)),[teta2,teta3, teta4, teta5, teta6, teta7])
% uk=intersect(symvar(eqns(3)),[teta2,teta3, teta4, teta5, teta6, teta7])

%rhs=simplify(T23*T34*T45*T56*T67)


% steta2=solve(lhs(1:3,1:4)==rhs(1:3,1:4),'teta3')





% L1=0; % mm
% L2=230; % mm
% L31=320;
% L32=450; % mm
% L4=975; % mm
% L51=182;
% L52=200; % mm
% L6=705; % mm
% L7=200; % mm 
% 
% % teta1=0*pi/180;
% teta2=10*pi/180;
% teta3=12*pi/180;
% teta4=0*pi/180;
% teta5=0*pi/180;
% teta6=0*pi/180;
% teta7=5*pi/180;
% 
% T07=T01*T12*T23*T34*T45*T56*T67;
% 
% T07=eval(T07)

