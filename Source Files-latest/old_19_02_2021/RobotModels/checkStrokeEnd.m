% check stroke end of joint coordinates
function flag=checkStrokeEnd(q, rob, idaxis)

% q: joint coordinates
% rob: robot model
% idaxis: axis to be checked

eps=rob.Kinematics.Solver.EpsIK; % num. tolerance

%
flag=true; 

for i=idaxis
    if ( q(i)-rob.JointLim(1,i) ) > eps || ( q(i)-rob.JointLim(2,i) ) < -eps
        flag=false;  % stroke-end reached
        break
    end
end