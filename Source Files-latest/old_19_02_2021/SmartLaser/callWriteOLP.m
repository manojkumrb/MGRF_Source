function callWriteOLP(filepdl, Trobot, thetaarm2)

if nargin==2
    thetaarm2=[];
end

np=length(Trobot);

posarm2=zeros(np,6);
posarm1=zeros(np,3);
for i=1:np
    
    % ARM[2]
    t=setTransformation(Trobot{i}, 4);
    posarm2(i,1:3)=t(1:3,4)';

    [alfa, beta, gamma]=rot2Euler(t(1:3,1:3));
    posarm2(i,4:6)=[alfa, beta, gamma];
    
    % ARM[1]
    t=setTransformation(Trobot{i}, 7);
    posarm1(i,:)=t(1:3,4);
end

writePDLFile(filepdl, posarm2, posarm1, thetaarm2)