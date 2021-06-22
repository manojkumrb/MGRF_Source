% calculate working envelop
function [X, Y, Z]=getWorkingAreaRobot(rob, q1, res)

% rob: robot model
% res: resolution

robmodel=rob.Model{rob.Model{1}+1};

% run calculation
if strcmp(robmodel,'ABB6620') || strcmp(robmodel,'ABB6700-200') || strcmp(robmodel,'ABB6700-235')
    
    nb=5;
    
    q2min=rob.JointLim(2,2);
    q2max=rob.JointLim(1,2);
        
    [q2, b]=meshgrid( linspace(q2min,q2max,res), linspace(0,1,res) );
    
    % loop over boundary 
    X=cell(1,nb); Y=cell(1,nb); Z=cell(1,nb);
    for boundary=1:nb
                
        X{boundary}=zeros(res); Y{boundary}=zeros(res); Z{boundary}=zeros(res);

        for i=1:res
            for j=1:res

                % get coordinates into global frame
                q=[q1 q2(i,j) 0 0 0 0 0];

                [x, y, z]=getOuterBoundary(rob, b(i,j),boundary);

                % transform back to global frame
                robmodel=rob.Model{rob.Model{1}+1};
                rob.Kinematics=initKinematics(robmodel, 7, q); % set home position
                T=solveForwardKinematics(rob);
                T03=setTransformation(T, 3);

                p=apply4x4([x, y, z], T03(1:3,1:3), T03(1:3,4)');

                % save
                X{boundary}(i,j)=p(1);
                Y{boundary}(i,j)=p(2);
                Z{boundary}(i,j)=p(3);
            end
        end
    end
    
else
    

    
    
    %-------------
    
end


% get boundary into local frame (3)
function [x, y, z]=getOuterBoundary(rob, t, idboundary)

% solve boundaries
[Pc(1,:), R(1), alfas(1), alfae(1)]=getOuterC1(rob);
[Pc(2,:), R(2), alfas(2), alfae(2)]=getOuterC2(rob);   
[R(3), alfas(3), alfae(3)]=getOuterC3(rob);
[R(4), alfas(4), alfae(4)]=getOuterC4(rob);
[R(5), alfas(5), alfae(5)]=getOuterC5(rob);

if idboundary==1 % get C1
    t=spaceCircle(alfas(1), alfae(1), t);
    x=Pc(1,1) + R(1).*cos(t);
    y=Pc(1,2) + R(1).*sin(t);
    z=0.0;
elseif idboundary==2 % get C2
    t=spaceCircle(alfas(2), alfae(2), t);
    x=Pc(2,1) + R(2).*cos(t);
    y=Pc(2,2) + R(2).*sin(t);
    z=0.0;
elseif idboundary==3 % get C3
    t=spaceCircle(alfas(3), alfae(3), t);
    x=R(3).*cos(t);
    y=R(3).*sin(t);
    z=0.0;
elseif idboundary==4 % get C4
    t=spaceCircle(alfas(4) , alfae(4), t);
    x=R(4).*cos(t);
    y=R(4).*sin(t);
    z=0.0;
elseif idboundary==5 % get C5
    t=spaceCircle(alfas(5) , alfae(5), t);
    x=R(5).*cos(t);
    y=R(5).*sin(t);
    z=0.0;
end
   


% q3max & [-pi/2, q4max]
function [Pc, R, alfas, alfae]=getOuterC1(rob)

% Pc: (1,3) boundary location
% R: radius of the boundary
% alfas/e: start/end span

robmodel=rob.Model{rob.Model{1}+1};

q3max=rob.JointLim(1,3);
q4max=rob.JointLim(1,4);
q4min=-pi/2;

% get p06 and p04 with q4min
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3max, q4min, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q4min=T06(1:3,4)';
T04=setTransformation(Trob, 4);
p04q4min=T04(1:3,4)';

% get p06 with q4max
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3max, q4max, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q4max=T06(1:3,4)';

% trasform into T3 frame
rob.Kinematics=initKinematics(robmodel, 7, zeros(1,7)); 
Trob=solveForwardKinematics(rob);

T03=setTransformation(Trob, 3);
p06q4min=applyinv4x4(p06q4min, T03(1:3,1:3), T03(1:3,4)');
p06q4max=applyinv4x4(p06q4max, T03(1:3,1:3), T03(1:3,4)');
p04q4min=applyinv4x4(p04q4min, T03(1:3,1:3), T03(1:3,4)');

% get radius
R=norm(p06q4min-p04q4min);

% get angles
alfas=atan2(p06q4min(2)-p04q4min(2), p06q4min(1)-p04q4min(1));
alfas= normalizeq(alfas);
alfae=atan2(p06q4max(2)-p04q4min(2), p06q4max(1)-p04q4min(1));
alfae= normalizeq(alfae);

Pc=p04q4min;

% q3min & [-90, q4min]
function [Pc, R, alfas, alfae]=getOuterC2(rob)

% Pc: (1,3) boundary location
% R: radius of the boundary
% alfas/e: start/end span

robmodel=rob.Model{rob.Model{1}+1};

q3min=rob.JointLim(2,3);
q4min=rob.JointLim(2,4);
q4max=rob.JointLim(1,4); % -pi/2;

% get p06 and p04 with q4min
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3min, q4min, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q4min=T06(1:3,4)';
T04=setTransformation(Trob, 4);
p04q4min=T04(1:3,4)';

% get p06 with q4max
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3min, q4max, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q4max=T06(1:3,4)';

% trasform into T3 frame
rob.Kinematics=initKinematics(robmodel, 7, zeros(1,7)); 
Trob=solveForwardKinematics(rob);

T03=setTransformation(Trob, 3);
p06q4min=applyinv4x4(p06q4min, T03(1:3,1:3), T03(1:3,4)');
p06q4max=applyinv4x4(p06q4max, T03(1:3,1:3), T03(1:3,4)');
p04q4min=applyinv4x4(p04q4min, T03(1:3,1:3), T03(1:3,4)');

% get radius
R=norm(p06q4min-p04q4min);

% get angles
alfae=atan2(p06q4max(2)-p04q4min(2), p06q4max(1)-p04q4min(1));
alfae= normalizeq(alfae);
alfas=atan2(p06q4min(2)-p04q4min(2), p06q4min(1)-p04q4min(1));
alfas= normalizeq(alfas);

Pc=p04q4min;

% -pi/2 & [q3min q3max]
function [R, alfas, alfae]=getOuterC3(rob)

% Pc: (1,3) boundary location
% R: radius of the boundary
% alfas/e: start/end span

robmodel=rob.Model{rob.Model{1}+1};

q3max=rob.JointLim(1,3);
q3min=rob.JointLim(2,3);
q4=-pi/2;

% get p06 with q3min
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3min, q4, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3min=T06(1:3,4)';

% get p06 with q3max
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3max, q4, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3max=T06(1:3,4)';

% trasform into T3 frame
rob.Kinematics=initKinematics(robmodel, 7, zeros(1,7)); 
Trob=solveForwardKinematics(rob);

T03=setTransformation(Trob, 3);
p06q3min=applyinv4x4(p06q3min, T03(1:3,1:3), T03(1:3,4)');
p06q3max=applyinv4x4(p06q3max, T03(1:3,1:3), T03(1:3,4)');

% get radius
R=norm(p06q3min);

% get angles
alfas=atan2(p06q3min(2), p06q3min(1));
alfas= normalizeq(alfas);
alfae=atan2(p06q3max(2), p06q3max(1));
alfae= normalizeq(alfae);

% q3min & q4max 
function [R, alfas, alfae]=getOuterC4(rob)

% R: radius of the boundary
% alfas/e: start/end span

robmodel=rob.Model{rob.Model{1}+1};

q3min=rob.JointLim(2,3);
q3max=rob.JointLim(1,3);
q4max=rob.JointLim(1,4);

% get p06 with q3min
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3min, q4max, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3min=T06(1:3,4)';

% get p06 with q3max
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3max, q4max, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3max=T06(1:3,4)';

% trasform into T3 frame
rob.Kinematics=initKinematics(robmodel, 7, zeros(1,7)); 
Trob=solveForwardKinematics(rob);

T03=setTransformation(Trob, 3);
p06q3min=applyinv4x4(p06q3min, T03(1:3,1:3), T03(1:3,4)');
p06q3max=applyinv4x4(p06q3max, T03(1:3,1:3), T03(1:3,4)');

% get radius
R=norm(p06q3min);

% get angles
alfas=atan2(p06q3min(2), p06q3min(1));
alfas= normalizeq(alfas);
alfae=atan2(p06q3max(2), p06q3max(1));
alfae= normalizeq(alfae);

% q3min & q4max 
function [R, alfas, alfae]=getOuterC5(rob)

% R: radius of the boundary
% alfas/e: start/end span

robmodel=rob.Model{rob.Model{1}+1};

q3min=rob.JointLim(2,3);
q3max=rob.JointLim(1,3);
q4min=rob.JointLim(2,4);

% get p06 with q3min
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3min, q4min, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3min=T06(1:3,4)';

% get p06 with q3max
rob.Kinematics=initKinematics(robmodel, 7, [0, 0, q3max, q4min, zeros(1,3)]); 
Trob=solveForwardKinematics(rob);

T06=setTransformation(Trob, 6);
p06q3max=T06(1:3,4)';

% trasform into T3 frame
rob.Kinematics=initKinematics(robmodel, 7, zeros(1,7)); 
Trob=solveForwardKinematics(rob);

T03=setTransformation(Trob, 3);
p06q3min=applyinv4x4(p06q3min, T03(1:3,1:3), T03(1:3,4)');
p06q3max=applyinv4x4(p06q3max, T03(1:3,1:3), T03(1:3,4)');

% get radius
R=norm(p06q3min);

% get angles
alfas=atan2(p06q3min(2), p06q3min(1));
alfas= normalizeq(alfas);
alfae=atan2(p06q3max(2), p06q3max(1));
alfae= normalizeq(alfae);


% normalise q into [0, 2pi]
function q = normalizeq(q)

for i=1:length(q)
    if q(i)<0
        q(i)=2*pi-abs(q(i));
    end
end

%--
function t=spaceCircle(alfas, alfae, t)

if (alfae>=0 && alfae<=pi) % alfas>=pi && 
    alfae=alfae+2*pi;
end

t=alfas + (alfae-alfas).*t;
