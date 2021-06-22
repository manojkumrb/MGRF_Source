%--
% read wrist position into the "0" frame (ABB IRB6620 model)
function Pw=getWristPos(rob)

% goal orientation
R0t=rob.Kinematics.Goal.R;

% goal position
P0t=rob.Kinematics.Goal.P;

% wrist length
L7=rob.Parameter.L7;

% read tool (tool to flange)
R7t=rob.Parameter.Tool.R;
P7t=rob.Parameter.Tool.P;

% calculate wrist position
Pw=apply4x4 ( applyinv4x4([0 0 -L7], R7t, P7t), R0t, P0t );